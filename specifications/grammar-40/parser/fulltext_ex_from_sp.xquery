(: parse tests :)

for $b in /books/book
where $b/title contains text ("dog" using stemming) ftand "cat" 
return $b/author
%%%

/books/book[title contains text ("dog" using stemming) ftand "cat"]/author
%%%
/books/book[price < 50 and title contains text ("train" using stemming)]

%%%
/books/book[title contains text "dog" ftand "cat" ne
            content contains text ("train" using stemming)]

%%%
for $b score $s 
    in /books/book[content contains text "web site" ftand "usability" 
                   and .//chapter/title contains text "testing"]
return $s

%%%
for $b score $s 
    in /books/book[content contains text "web site" ftand "usability"]
where $s > 0.5
order by $s descending
return <result>  
          <title> {$b//title} </title> 
          <score> {$s} </score> 
       </result>

%%%
for $p score $s in 
  //book[title contains text "software"]/para[. contains text "usability"]
     order by $s descending
  return $p

%%%
for $b score $score1 in //book[title contains text "software"]
    order by $score1 descending
return
    for $p score $score2 in $b/para[. contains text "usability"]
       order by $score2 descending
    return $p

%%%
for $b in /books/book[.//chapter/title contains text "testing"]
let score $s := $b/content contains text "web site" ftand "usability" 
order by $s descending
return <result score="{$s}">{$b}</result>

%%%
for $b in /books/book
let score $s := $b/content contains text ("web site" weight {0.5})
                                ftand ("usability" weight {2})
return <result score="{$s}">{$b}</result>

%%%//book[./title contains text "Expert"]
%%%//book[./title contains text "Expert Reviews"]
%%%//book[./title contains text {"Expert", "Reviews"} all]
%%%//book//p contains text "Web Site Usability"
%%%for $book in /books/book[.//author contains text "Marigold"] 
let score $score := $book/title/@shortTitle contains text "Web Site Usability" 
where $score > 0.8 
order by $score descending
return $book/@number
%%%//book[. contains text "usability" occurs at least 2 times]/@number
%%%//book[@number="1" and title contains text {"usability", 
"testing"} any occurs at most 2 times] 
%%%/books/book/title contains text "usability" 
%%%/books/book/title contains text "usability" 
    using language "de"
    using no wildcards
    using no thesaurus
    using no stemming
    using case insensitive 
    using diacritics insensitive 
    using no stop words
%%%//book[@number="1"]/content//p contains text "salon de thé"
using stop words default using language "fr"
%%%//book[@number="1"]/p contains text "w.ll" using wildcards
%%%//book[@number="1"]/title contains text ".?site" using wildcards
%%%//book[@number="1"]/title contains text "improv.*" using wildcards
%%%//book[@number="1"]/p contains text "wi.{5,7]" using wildcards
%%%//book[@number="1"]/title contains text "\s\i\t\e" using wildcards
%%%//book[@number="1"]/title contains text "Usab.+\\" using wildcards
%%%//book[@number="1"]/p contains text "will\" using wildcards
%%%//book[@number="1"]/p contains text "w.ll" using no wildcards
%%%.//book/content contains text "duty" using
thesaurus at "http://bstore1.example.com/UsabilityThesaurus.xml"
relationship "UF"
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[./content contains text "people" using
thesaurus at "http://bstore1.example.com/UsabilityThesaurus.xml"
relationship "NT" at most 2 levels]
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[. contains text "Merrygould" using thesaurus at
"http://bstore1.example.com/UsabilitySoundex.xml" relationship
"sounds like"]
%%%/books/book[@number="1"]/title contains text "improve" using stemming 
%%%//book[@number="1"]/title contains text "Usability" using lowercase 
%%%//book[@number="1"]/title contains text "usability" using case insensitive
%%%//book[@number="1"]//editor contains text "Vera" using diacritics insensitive
%%%//book[@number="1"]/editors contains text "Vera" using diacritics sensitive
%%%/books/book[@number="1"]//p contains text "propagating of errors"
using stop words ("a", "the", "of") 
%%%/books/book[@number="1"]//p contains text "propagating errors" 
using stop words ("few")
%%%/books/book[@number="1"]//p contains text "propagating of errors" 
using no stop words
%%%
doc("http://bstore1.example.com/full-text.xml")
/books/book[.//content contains text "planning then 
conducting" using stop words at 
"http://bstore1.example.com/StopWordList.xml"]

%%%
doc("http://bstore1.example.com/full-text.xml")
/books/book[.//content contains text "planning then conducting"
using stop words at "http://bstore1.example.com/StopWordList.xml"
except ("the", "then")]

%%%
declare namespace exq = "http://example.org/XQueryImplementation";

//para[. contains text
         ("Kinder" ftand "Platz" distance exactly 1 words)
         using stemming
	 using option exq:compounds "distance=1" ]

%%%//book[.//author contains text "Millicent" ftor "Voltaire"]
%%%//book[@number="1"]/title contains text ("usability" ftand "testing")
%%%//book/author contains text "Millicent" ftand "Montana"
%%%/books/book contains text "usability" not in "usability testing"
%%%//book[. contains text ftnot "usability"]
%%%//book contains text "improving" ftand
"usability" ftand ftnot "improving usability"
%%%//book[title/@shortTitle contains text "web site usability" ftand 
ftnot "usability testing"]
%%%//book/title contains text ("web site" ftand "usability") ordered
%%%//book[@number="1"] contains text ("Montana" ftand "Millicent") ordered
%%%/books/book/title contains text "web" ftand "site"
ftand "usability" window 5 words
%%%/books/book contains text ("web" ftand "site" ordered)
ftand ("usability" ftor "testing") window 10 words
%%%/books/book//title contains text "web site" ftand
"usability" window 3 words
%%%/books/book[@number="1" and . contains text "efficient" 
ftand ftnot "and" window 2 words]
%%%/books/book[@number="1" and . contains text "efficient" 
ftand ftnot "and" window 3 words]
%%%/books/book contains text ("completion" ftand "errors" 
distance at least 11 words)
%%%/books/book contains text "web" ftand "site" ftand
"usability" distance at most 2 words
%%%/books/book[.//p contains text "web site"
ftand "usability" distance at most 1 words] 
%%%/books/book[. contains text "web"
ftand "users" distance at most 1 words]/title 
%%%/books/book contains text ((("richard" ftand "nixon") distance at most 2 words) 
                   ftand 
                   (("george" ftand "bush") distance at most 2 words) 
                  distance at least 20 words)
%%%//book contains text "usability" ftand "Marigold" same sentence
%%%//book contains text "usability" ftand "Marigold" different sentence
%%%//book[. contains text "usability" ftand "testing" same paragraph] 
%%%//book[. contains text "site" ftand "errors" same sentence] 
%%%/books//title[. contains text "improving the usability
of a web site" at start]
%%%/books//p[. contains text "propagat.*" using wildcards ftand "few
errors" distance at most 2 words at end]
%%%/books//note[. contains text "this book has been
approved by the web site users association" entire content]
%%%/books//* contains text "Association" at end
%%%
declare namespace exq = "http://example.org/XQueryImplementation";

/books/book/author[name contains text (# exq:use-index #) {'Berners-Lee'}]

%%%
declare namespace exq = "http://example.org/XQueryImplementation";

/books/book[.//p contains text (# exq:distance #) { "web site"
ftand "usability" distance at most 1 words }]

%%%
declare namespace exq = "http://example.org/XQueryImplementation";

//city[. contains text (# exq:classifier with class 'Animals' #) 
       {"animal" using thesaurus at "http://example.org/thesaurus.xml" 
        relationship "RT"}]

%%%
<p kind='secret'>Sensitive material <!-- secret --></p> contains text 'secret'


%%%
"one two three four"
contains text
   ("one" ftand "three" window 3 words)
   ftand
   ("two" ftand "four" window 3 words)
   entire content

%%%
    $doc contains text (
        (
            "Mustang"
            ftand
            ({("great", "excellent")} any word occurs at least 2 times)
            window 11 words
        )
        ftand
        ftnot "rust"
    ) same paragraph

%%%
declare function local:filter ( $nodes 
   as node()*, $exclude as element()* ) as node()*
   {
      for $node in $nodes except $exclude
      return
         typeswitch ($node)
            case $e as element()
               return 
                 element {node-name($e)}
                   {
                       $e/@*,
                      filter( $e/node() except $exclude, 
                      $exclude )
                   }
            default 
               return $node
   };

for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $irrelevantParts := 
   for $part in $book//part
   let score $score := $part contains text "usability test.*" 
      using wildcards
   where $score < 0.5
   return $part
where count($irrelevantParts) < count($book//part)
return filter($book, $irrelevantParts)

%%%
declare function local:filter($nodes as node()*, $exclude as element()*) as node()
{
( for $node in ($nodes except $exclude)
  return ( typeswitch($node)
             case $e as element()
               return element {fn:node-name($e)}
                  {( $e/child::attribute(*),
                     fn:filter( ($e/child::node() except $exclude), $exclude ) )}
             default return $node )
)
};

( for $book
    in fn:doc("http://bstore1.example.com/full-text.xml")/child::books/child::book
  let $irrelevantParts:=
  ( for $part in $book/descendant-or-self::part
    let score $score := $part contains text "usability test.*"
        using wildcards
    where ($score < 0.5)
    return $part
)
  where (fn:count($irrelevantParts) < fn:count($book/descendant-or-self::part))
  return local:filter($book, $irrelevantParts)
)

%%%