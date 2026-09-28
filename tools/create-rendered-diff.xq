(:~
 : Compares the HTML specifications built from the master branch and from the working tree,
 : and writes an HTML page with the changed blocks per section.
 :
 : The sources of the master branch are restored temporarily while it is built;
 : its renderings are kept in the build directory and reused until the branch changes.
 :
 : @author Christian Grün, BaseX 2026
 :)
declare namespace proc = 'http://basex.org/modules/proc';

(:~ Title, sections and heading anchors of a specification. :)
declare record spec-sections(title as xs:string, sections as map(*), anchors as map(*));
(:~ Remaining old and new blocks, and the diff created so far. :)
declare record alignment(old as xs:string*, new as xs:string*, result as element(p)*);

declare variable $BASE := 'master';
declare variable $SOURCES := ('specifications', 'style');
declare variable $REPO := file:parent(file:base-dir());
declare variable $WWW := $REPO || 'build/www/';
declare variable $OUT := $REPO || 'build/rendered-diff.html';
declare variable $CACHE := $REPO || 'build/rendered-diff/';
declare variable $STATE := $CACHE || 'state.txt';
declare variable $HEADINGS := ('h1', 'h2', 'h3', 'h4', 'h5', 'h6');
declare variable $BLOCKS := ($HEADINGS, 'p', 'pre', 'dt', 'dd', 'li', 'td', 'th');

(:~
 : Runs an external command and returns its output.
 : @param $command command
 : @param $args arguments
 : @return standard output
 :)
declare function run-command($command as xs:string, $args as xs:string*) as xs:string {
  (: currently BaseX-specific: this call must be rewritten for other processors :)
  let $system := function-lookup(#proc:system, 2) otherwise error((),
    'proc:system is not available; adapt the function run-command() to your processor.'
  )
  return $system($command, $args)
};

(:~
 : Runs a git command in the repository and returns its output.
 : @param $args arguments
 : @return standard output
 :)
declare function git($args as xs:string*) as xs:string {
  run-command('git', ('-C', $REPO, $args))
};

(:~
 : Runs gradle in the repository and returns its output.
 : @param $args arguments
 : @return standard output
 :)
declare function gradle($args as xs:string*) as xs:string {
  let $gradlew := $REPO || 'gradlew' || (if (file:dir-separator() = '\') { '.bat' })
  return run-command($gradlew, ('-p', $REPO, $args))
};

(:~
 : Renders all specifications (gradle tasks named *_html) and records the state of the sources.
 : @param $state state of the sources
 : @return log message
 :)
declare function build-specs($state as xs:string) as xs:string {
  let $listing := gradle(('-q', 'tasks', '--all'))
  let $log := gradle(matching-segments($listing, '^([\w_]+_html)(\s|$)', 'm') ! ?groups?1?value)
  return (file:write-text($STATE, $state), 'built specifications')
};

(:~
 : Returns the paths to all rendered specifications, relative to the web directory.
 : @return paths
 :)
declare function renderings() as xs:string* {
  for $path in file:list($WWW, recursive := true(), pattern := '*.html') ! translate(., '\', '/')
  where count(tokenize($path, '/')) = 2 and not(matches($path, '^grammar-explorer/|-diff\.html$'))
  return $path
};

(:~
 : Renders all specifications from the base branch and keeps copies of the renderings.
 : @param $commit commit of the base branch
 : @param $base target directory, named after the commit
 : @return log messages
 :)
declare function build-base($commit as xs:string, $base as xs:string) as xs:string* {
  (: snapshot of the working tree, without touching it (empty if nothing has changed) :)
  let $saved := normalize-space(git(('stash', 'create')))[.] otherwise 'HEAD'
  let $restore := fn($source) {
    git(('restore', '--source=' || $source, '--worktree', '--', $SOURCES))
  }
  return try {
    let $checkout := $restore($commit)
    return (
      build-specs($commit),
      (: delete the renderings of previous commits :)
      file:children($CACHE)[file:is-dir(.)] ! file:delete(., recursive := true()),
      for $path in renderings()
      let $target := $base || $path
      return (file:create-dir(file:parent($target)), file:copy($WWW || $path, $target)),
      `built { $BASE } ({ substring($commit, 1, 9) })`
    )
  } finally {
    void((
      $restore($saved),
      (: files that only exist in the base branch are not removed by git restore :)
      let $added := git(('diff', '--name-only', '--diff-filter=A', $saved, $commit, '--', $SOURCES))
      for $file in tokenize($added, '\r?\n')[.]
      return file:delete($REPO || $file)
    ))
  }
};

(:~
 : Returns the title of a specification, the text of all innermost blocks,
 : grouped by the heading that precedes them, and the anchors of the headings.
 : @param $path path to the HTML file
 : @return title, sections and anchors
 :)
declare function parse-sections($path as xs:string) as spec-sections {
  let $doc := parse-html(file:read-text($path))
  let $blocks := $doc//*[local-name() = $BLOCKS][not(descendant::*[local-name() = $BLOCKS])]
  return spec-sections(
    normalize-space(($doc//*:title)[1]),
    map:merge(
      for tumbling window $w in $blocks
        start $h when local-name($h) = $HEADINGS
      return map:entry(strip-number(block-text($h)), tail($w) ! block-text(.)[.]),
      { 'duplicates': 'combine' }
    ),
    map:merge(
      for $h in $blocks[local-name() = $HEADINGS]
      let $id := ($h/@id, $h//*:a/@id)[1]
      where $id
      return map:entry(strip-number(block-text($h)), string($id)),
      { 'duplicates': 'use-first' }
    )
  )
};

(:~
 : Removes a leading section number, which changes when sections are added or removed.
 : @param $text text of a heading or block
 : @return text without section number
 :)
declare function strip-number($text as xs:string) as xs:string {
  replace($text, '^([A-Z]|\d+)(\.\d+)*\s+', '')
};

(:~
 : Returns the text of a block, without the section numbers of internal links.
 : @param $block block
 : @return text
 :)
declare function block-text($block as element()) as xs:string {
  let $link := fn($node) { $node/ancestor-or-self::*:a[starts-with(@href, '#')] }
  let $nodes := $block/descendant::node()[
    self::text()[empty($link(.))] or self::*[$link(.)[1] is .]
  ]
  return normalize-space(string-join(
    $nodes ! (if (. instance of text()) then string() else strip-number(normalize-space()))
  ))
};

(:~
 : Renders a word-level diff of two blocks: the words between the common prefix and suffix
 : are marked as deleted and inserted.
 : @param $a old text
 : @param $b new text
 : @return paragraph
 :)
declare function diff-words($a as xs:string, $b as xs:string) as element(p) {
  let $x := tokenize($a)
  let $y := tokenize($b)
  let $common := fn($c, $d) {
    count(for $equal in for-each-pair($c, $d, op('=')) while $equal return $equal)
  }
  let $pre := $common($x, $y)
  let $suf := min(($common(reverse($x), reverse($y)), count($x) - $pre, count($y) - $pre))
  let $middle := fn($z) { string-join(subsequence($z, $pre + 1, count($z) - $pre - $suf), ' ') }
  return <p>{
    string-join(subsequence($x, 1, $pre), ' '), ' ',
    <del>{ $middle($x) }</del>, ' ', <ins>{ $middle($y) }</ins>, ' ',
    string-join(subsequence($x, count($x) - $suf + 1), ' ')
  }</p>
};

(:~
 : Checks if two blocks are similar: at least 40% of their distinct words are shared.
 : @param $a old text
 : @param $b new text
 : @return result of check
 :)
declare function similar($a as xs:string, $b as xs:string) as xs:boolean {
  let $x := distinct-values(tokenize($a))
  let $y := distinct-values(tokenize($b))
  return 2 * count($x[. = $y]) >= 0.4 * (count($x) + count($y))
};

(:~
 : Aligns old and new blocks, and renders deleted, inserted and changed blocks in document order.
 : @param $old old blocks
 : @param $new new blocks
 : @return paragraphs
 :)
declare function diff-blocks($old as xs:string*, $new as xs:string*) as element(p)* {
  let $align := fn($s as alignment) as alignment {
    let $a := head($s?old)
    let $b := head($s?new)
    return switch () {
      case ($a = $b) return
        alignment(tail($s?old), tail($s?new), $s?result)
      case (exists($a) and exists($b) and similar($a, $b)) return
        alignment(tail($s?old), tail($s?new), ($s?result, diff-words($a, $b)))
      (: no old block left, or it occurs later: the new block was inserted :)
      case (empty($a) or $a = tail($s?new) or (some $n in tail($s?new) satisfies similar($a, $n)))
      return
        alignment($s?old, tail($s?new), ($s?result, <p class='inserted'>{ $b }</p>))
      default return
        alignment(tail($s?old), $s?new, ($s?result, <p class='deleted'>{ $a }</p>))
    }
  }
  return while-do(alignment($old, $new, ()), fn($s) { exists(($s?old, $s?new)) }, $align)?result
};

(:~
 : Compares two renderings of a specification.
 : @param $base directory with the renderings of the base branch
 : @param $path path to the rendering, relative to the web directory
 : @return changed sections
 :)
declare function diff-spec($base as xs:string, $path as xs:string) as element(div) {
  let $old := parse-sections($base || $path)
  let $new := parse-sections($WWW || $path)
  let $sections := (
    for $key in distinct-values((map:keys($new?sections), map:keys($old?sections)))
    let $a := $old?sections($key)
    let $b := $new?sections($key)
    where not(deep-equal($a, $b))
    let $anchor := $new?anchors($key)
    return <section>
      <h3>{
        if ($anchor) then <a href='www/{ $path }#{ $anchor }'>{ $key }</a> else $key
      }</h3>
      { diff-blocks($a, $b) }
    </section>
  )
  return <div>
    <h1>{ $new?title }</h1>
    { $sections }
  </div>
};

let $commit := git(('rev-parse', $BASE)) => normalize-space()
let $diff := git(('diff', $commit, '--', $SOURCES))
let $base := `{ $CACHE }{ $commit }/`
let $state := $commit || $diff
return if (not($diff)) then (
  `No changes compared to { $BASE }.`
) else (
  file:create-dir($CACHE),
  if (not(file:exists($base))) { build-base($commit, $base) },
  if (not((if (file:exists($STATE)) { file:read-text($STATE) }) = $state)) { build-specs($state) },
  (: renderings that differ from the base branch :)
  let $specs := (
    for $path in renderings()
    let $old := $base || $path
    where file:exists($old) and file:read-binary($old) != file:read-binary($WWW || $path)
    return diff-spec($base, $path)
  )
  return (
    file:write($OUT, <html>
      <head>
        <title>Rendered diff</title>
        <link rel='stylesheet' href='../specifications/css/w3c-base.css'/>
        <link rel='stylesheet' href='../specifications/css/qtspecs.css'/>
        <style>
          del, .deleted {{ background: rgb(255 85 85 / 0.3); text-decoration: line-through; }}
          ins, .inserted {{ background: rgb(144 238 238 / 0.3); text-decoration: none; }}
          .deleted {{ border-right: 6px solid #e43322; }}
          .inserted {{ border-right: 6px solid #3f7f21; }}
        </style>
      </head>
      <body>
        { if (empty($specs)) { <p>No changes.</p> } }
        { $specs }
        <p>{ $BASE } ({ substring($commit, 1, 9) }) → working tree</p>
      </body>
    </html>, { 'method': 'html' }),
    $specs ! `{ h1 }: { count(section) } changed sections`,
    `written: { $OUT }`
  )
)
