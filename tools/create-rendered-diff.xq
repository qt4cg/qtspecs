(:~
 : Compares the HTML specifications built from the master branch and from the working tree,
 : and writes an HTML page with the changed blocks per section.
 :
 : The sources of the master branch are restored temporarily while it is built;
 : its renderings are kept in the build directory and reused until its sources change.
 :
 : @author Christian Grün, BaseX 2026
 :)
declare namespace proc = 'http://basex.org/modules/proc';

(:~ Heading, heading anchor and blocks of a section. :)
declare record section(heading as xs:string, anchor as xs:string?, blocks as xs:string*);
(:~ Title and sections of a specification, keyed by heading anchor or heading. :)
declare record spec-sections(title as xs:string, sections as map(xs:string, section));
(:~ Remaining old and new blocks, and the diff created so far. :)
declare record alignment(old as xs:string*, new as xs:string*, result as element(p)*);

declare variable $BASE := 'master';
declare variable $SOURCES := ('specifications', 'style');
declare variable $REPO := file:parent(file:base-dir());
declare variable $WWW := $REPO || 'build/www/';
declare variable $OUTPUT := $REPO || 'build/rendered-diff.html';
declare variable $CACHE := $REPO || 'build/rendered-diff/';
declare variable $STATE := $CACHE || 'state.txt';
declare variable $HEADINGS := ('h1', 'h2', 'h3', 'h4', 'h5', 'h6');
declare variable $BLOCKS := ($HEADINGS, 'p', 'pre', 'dt', 'dd', 'li', 'td', 'th');
declare variable $MAX-DIFFS := 1000;

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
  let $log := gradle(matching-segments($listing, '^([a-zA-Z][\w_]*_html)(\s|$)', 'm') ! ?groups?1?value)
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
 : @param $base target directory, named after the sources of the base branch
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
 : Returns the title of a specification and the text of all innermost blocks,
 : grouped by the heading that precedes them.
 : @param $path path to the HTML file
 : @return title and sections
 :)
declare function parse-sections($path as xs:string) as spec-sections {
  let $doc := parse-html(file:read-text($path))
  let $blocks := $doc//*[local-name() = $BLOCKS][not(descendant::*[local-name() = $BLOCKS])]
  return spec-sections(
    normalize-space(($doc//*:title)[1]),
    map:merge(
      for tumbling window $w in $blocks
        start $h when local-name($h) = $HEADINGS
      let $heading := strip-number(string-join(block-text($h), ' '))
      let $anchor := ($h/@id, $h//*:a/@id)[1] ! string()
      let $content := tail($w) ! block-text(.)
      (: anchors are stable, whereas headings may contain generated text, such as dates :)
      group by $key := $anchor otherwise $heading
      return map:entry($key, section($heading[1], $anchor[1], $content))
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
 : Returns the lines of a block (separated by line breaks in preformatted blocks, and by br elements), without the section numbers of internal links.
 : @param $block block
 : @return lines
 :)
declare function block-text($block as element()) as xs:string* {
  let $pre := local-name($block) = 'pre'
  let $link := fn($node) { $node/ancestor-or-self::*:a[starts-with(@href, '#')] }
  let $nodes := $block/descendant::node()[
    self::text()[empty($link(.))] or self::*:br[empty($link(.))] or self::*[$link(.)[1] is .]
  ]
  let $text := string-join(
    for $node in $nodes
    return switch () {
      case exists($node/self::*:br) return '&#xA;'
      case $node instance of text() return (
        if ($pre) then string($node) else translate($node, '&#xA;&#xD;', '  ')
      )
      default return strip-number(normalize-space($node))
    }
  )
  return tokenize($text, '\r?\n') ! normalize-space()[.]
};

(:~
 : Computes the shortest edit script of two sequences with the Myers algorithm.
 : @param $old old items
 : @param $new new items
 : @return operations, each with a type ('=', '-' or '+') and an item
 :)
declare function edit-script($old as xs:string*, $new as xs:string*) as array(xs:string)* {
  let $n := count($old)
  let $m := count($new)
  (: for each number of differences, the furthest position in $old per diagonal (x - y) :)
  let $done := fn($trace) { $trace[last()]($n - $m) >= $n }
  let $trace := while-do(
    { 1: 0 },
    fn($trace) { not($done($trace)) and count($trace) <= $MAX-DIFFS },
    fn($trace) {
      let $d := count($trace) - 1
      let $v := $trace[last()]
      return ($trace, fold-left((-$d to $d)[(. + $d) mod 2 = 0], $v, fn($next, $k) {
        let $x := if ($k = -$d or ($k != $d and $v($k - 1) < $v($k + 1)))
          then $v($k + 1) else $v($k - 1) + 1
        return map:put($next, $k, snake($old, $new, $x, $x - $k))
      }))
    }
  )
  return if (not($done($trace))) then (
    (: too many differences: everything is replaced :)
    $old ! [ '-', . ], $new ! [ '+', . ]
  ) else (
    (: walk back from the end, and prepend each change and the unchanged items after it :)
    fold-left(reverse(0 to count($trace) - 2), { 'x': $n, 'y': $m, 'ops': () }, fn($s, $d) {
      let $v := $trace[$d + 1]
      let $k := $s?x - $s?y
      let $pk := if ($k = -$d or ($k != $d and $v($k - 1) < $v($k + 1))) then $k + 1 else $k - 1
      let $px := $v($pk)
      let $py := $px - $pk
      let $equal := min(($s?x - $px, $s?y - $py))
      return {
        'x': $px,
        'y': $py,
        'ops': (
          if ($d > 0) { if ($pk = $k + 1) then [ '+', $new[$py + 1] ] else [ '-', $old[$px + 1] ] },
          subsequence($old, $s?x - $equal + 1, $equal) ! [ '=', . ],
          $s?ops
        )
      }
    })?ops
  )
};

(:~
 : Follows a diagonal of the Myers algorithm as long as the items of both sequences are equal.
 : @param $old old items
 : @param $new new items
 : @param $x position in the old items
 : @param $y position in the new items
 : @return position in the old items after the equal items
 :)
declare function snake(
  $old as xs:string*,
  $new as xs:string*,
  $x as xs:integer,
  $y as xs:integer
) as xs:integer {
  if ($old[$x + 1] = $new[$y + 1]) then snake($old, $new, $x + 1, $y + 1) else $x
};

(:~
 : Renders a word-level diff of two blocks, with adjacent deleted and inserted words merged.
 : @param $a old text
 : @param $b new text
 : @return strings and elements
 :)
declare function diff-words($a as xs:string, $b as xs:string) as item()* {
  let $words := fn($text) { tokenize($text, '[\s&#xA0;]+')[.] }
  for tumbling window $w in edit-script($words($a), $words($b))
    start $s previous $p when not($s?1 = $p?1)
  let $text := string-join($w ! ?2, ' ')
  return (
    switch ($s?1) {
      case '-' return <del>{ $text }</del>
      case '+' return <ins>{ $text }</ins>
      default return $text
    },
    ' '
  )
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
 : Compares old and new blocks, and renders deleted, inserted and changed blocks in document order.
 : @param $old old blocks
 : @param $new new blocks
 : @return paragraphs
 :)
declare function diff-blocks($old as xs:string*, $new as xs:string*) as element(p)* {
  (: runs of deleted and inserted blocks between two unchanged ones :)
  for tumbling window $w in edit-script($old, $new)
    start $s when $s?1 != '='
    end next $n when $n?1 = '='
  return pair-blocks($w[?1 = '-'] ! ?2, $w[?1 = '+'] ! ?2)
};

(:~
 : Pairs deleted and inserted blocks, and renders similar ones as changed blocks.
 : @param $old deleted blocks
 : @param $new inserted blocks
 : @return paragraphs
 :)
declare function pair-blocks($old as xs:string*, $new as xs:string*) as element(p)* {
  let $align := fn($s as alignment) as alignment {
    let $a := head($s?old)
    let $b := head($s?new)
    return switch () {
      case ($a = $b) return
        alignment(tail($s?old), tail($s?new), $s?result)
      case (exists($a) and exists($b) and similar($a, $b)) return
        alignment(tail($s?old), tail($s?new), ($s?result, <p>{ diff-words($a, $b) }</p>))
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
 : @param $old sections of the base branch
 : @param $new sections of the working tree
 : @param $path path to the rendering, relative to the web directory
 : @return changed sections
 :)
declare function diff-spec(
  $old as spec-sections,
  $new as spec-sections,
  $path as xs:string
) as element(div) {
  <div>
    <h1>{ $new?title }</h1>
    {
      for $key in distinct-values((map:keys($new?sections), map:keys($old?sections)))
      let $a := $old?sections($key)
      let $b := $new?sections($key)
      where not(deep-equal($a, $b))
      let $heading := if (exists($a) and exists($b) and $a?heading != $b?heading)
        then diff-words($a?heading, $b?heading) else ($b, $a)[1]?heading
      return <section>
        <h3>{
          if ($b?anchor) then <a href='www/{ $path }#{ $b?anchor }'>{ $heading }</a> else $heading
        }</h3>
        { diff-blocks($a?blocks, $b?blocks) }
      </section>
    }
  </div>
};

let $commit := git(('rev-parse', $BASE)) => normalize-space()
let $diff := git(('diff', $commit, '--', $SOURCES))
(: cache key: tree hashes of the sources, which only change if the sources do :)
let $trees := git(('rev-parse', $SOURCES ! `{ $commit }:{ . }`))
let $base := `{ $CACHE }{ lower-case(string(hash($trees, 'sha1'))) }/`
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
    return diff-spec(parse-sections($old), parse-sections($WWW || $path), $path)
  )
  return (
    file:write($OUTPUT, <html>
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
    `written: { $OUTPUT } ({ count($specs/section) } changed sections)`
  )
)
