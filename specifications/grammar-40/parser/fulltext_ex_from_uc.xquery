(: parse tests :)
doc("http://bstore1.example.com/full-text.xml")
   /books/book/metadata/title[. contains text "usability"]
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book/metadata/title[. contains text "usability"]
%%%doc("http://bstore1.example.com/full-text.xml")
   /books/book/metadata/subjects/subject[. contains text 
   "usability testing"]
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book/metadata/subjects/subject[. contains text 
"usability testing"]
%%%doc("http://bstore1.example.com/full-text.xml")
   /books/book/metadata/subjects/subject[. contains text 
   "&#32593;&#31449;" using language "zh"]
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book/metadata/subjects/subject[. contains text 
"&#32593;&#31449;" using language "zh"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $title := $book/(metadata|content/part/chapter)/title
where $title contains text "usability tests"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[(metadata|content/part/chapter)
/title contains text "usability tests"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
where $book/metadata/subjects/subject contains text "usability testing"
return $book/metadata/(title|author)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[metadata/subjects/subject 
contains text "usability testing"]/metadata/(title|author)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $title := $book/metadata/title 
where $title contains text "improving" ftand "usability" 
   ordered distance at most 2 words at start
return $title
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book/metadata/title[. contains text "improving" 
ftand "usability" ordered distance at most 2 words 
at start]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $exactTitle := $book/metadata/title
where $exactTitle contains text "improv.* the usability of a 
   web site through expert reviews and usability testing" 
   using wildcards entire content
return $exactTitle
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book/metadata/title[. contains text 
"improv.* the usability of a web site through expert 
reviews and usability testing" using wildcards entire 
content]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $chap := $book//chapter
where $chap contains text "one of the best known lists of 
   heuristics is Ten Usability Heuristics"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[.//chapter contains text "one of 
the best known lists of heuristics is Ten Usability 
Heuristics"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $intro := $book/content/part/introduction
where $intro contains text "prototypes"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content/part/introduction contains text 
"prototypes"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "tests"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "tests"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content 
where $cont contains text "usability testing once the 
   problems"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "usability 
testing once the problems"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $intro := $book/content/(introduction|part/introduction)   
where $intro [./p contains text "identif.*" using wildcards]
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content/(introduction|part/introduction) 
contains text "identif.*" using wildcards]
%%%doc("http://bstore1.example.com/full-text.xml")[. 
 contains text "mouse"]/books/book
%%%doc("http://bstore1.example.com/full-text.xml")[. 
 contains text "mouse"]/books/book
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
where $book/metadata/title/@shortTitle contains text "improve" 
   using stemming ftand "web" ftand "usability" distance 
   at most 2 words    
return $book/metadata/title
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[metadata/title/@shortTitle contains text 
"improve" using stemming ftand "web" ftand "usability" 
distance at most 2 words]/metadata/title
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $stitle := $book/metadata/title/@shortTitle    
let $ctitle := $book//componentTitle  
where $stitle contains text "manuscript guides"
   using stemming and $ctitle contains text "user profiling" 
   using stemming
return data($stitle)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content 
where $cont contains text "test." using wildcards
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "test." 
using wildcards]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text ".?way" using wildcards
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text ".?way" 
using wildcards]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content 
where $cont contains text "serv.*e" using wildcards
return (concat($book/@number, ", ", 
   $book/metadata/title))
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "serv.*e" using wildcards]
/concat(@number, ", " , metadata/title)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content 
where $cont contains text "us.+ testing" using wildcards
return (concat($book/@number, ", ", 
   $book/metadata/title))
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "us.+ testing"
using wildcards]/concat(@number, ", ", metadata/title)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content 
where $cont contains text "test.{3,4}" using wildcards
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "test.{3,4}"
using wildcards]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "test" using stemming
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "test" 
using stemming]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content 
where $cont contains text ("usability" using stemming ftand "testing" 
   phrase) ftor ("users" using stemming ftand "testing" phrase)
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text ("usability" using stemming
ftand "testing" phrase) ftor ("users" using stemming
ftand "testing" phrase)]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $intro := $book//introduction 
where $intro contains text "quote" using thesaurus at
   "http://bstore1.example.com/UsabilityThesaurus.xml" 
   relationship "synonyms"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[.//introduction contains text "quote" 
using thesaurus at 
"http://bstore1.example.com/UsabilityThesaurus.xml" 
relationship "synonyms"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "web site components" 
   using thesaurus at 
   "http://bstore1.example.com/UsabilityThesaurus.xml" 
   relationship "narrower term" at most 2 levels
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "web site components" 
using thesaurus at 
"http://bstore1.example.com/UsabilityThesaurus.xml" 
relationship "narrower term" at most 2 levels]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[@number="3"]
let $cont := $book/content 
where $cont contains text ("letters" ftor "holiday cards") 
   using thesaurus at 
   "http://bstore1.example.com/UsabilityThesaurus.xml" 
   relationship "BT" exactly 1 levels
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text ("letters" 
ftor "holiday cards") using thesaurus at 
"http://bstore1.example.com/UsabilityThesaurus.xml" 
relationship "BT" exactly 1 levels]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[. contains text "Merrygould" 
   using thesaurus at 
   "http://bstore1.example.com/UsabilitySoundex.xml" 
   relationship "sounds like"]
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[. contains text "Merrygould" 
using thesaurus at 
"http://bstore1.example.com/UsabilitySoundex.xml" 
relationship "sounds like"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[. contains text "sucessfull" 
   using thesaurus at 
   "http://bstore1.example.com/spellcheck.xml" 
   relationship "misspelling of"]
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[. contains text "sucessfull" 
using thesaurus at 
"http://bstore1.example.com/spellcheck.xml" 
relationship "misspelling of"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[@number="3"]
let $comp := $book//component
where $comp contains text "AIDS" using uppercase 
   using thesaurus at 
   "http://bstore1.example.com/OurTaxonomy.xml" 
   relationship "disease in this category"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[@number="3" and .//component contains text 
"AIDS" using uppercase using thesaurus at 
"http://bstore1.example.com/OurTaxonomy.xml" 
relationship "disease in this category"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "planning then conducting" 
   using stop words 
   at "http://bstore1.example.com/StopWordList.xml"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "planning then 
conducting" using stop words at 
"http://bstore1.example.com/StopWordList.xml"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "planning then conducting" 
   using no stop words
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "planning then 
conducting" using no stop words]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text 
   "not been approved" using stop words at
   "http://bstore1.example.com/StopWordList.xml" 
   except ("not")
return ($book/metadata/title, $cont)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "not been 
approved" using stop words at 
"http://bstore1.example.com/StopWordList.xml" 
except ("not")]/(metadata/title, content)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "résumé.?" using wildcards 
   using diacritics sensitive
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "résumé.?" 
using wildcards using diacritics sensitive]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "resume.?" using wildcards 
   using diacritics insensitive
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "resume.?" 
using wildcards using diacritics insensitive]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book  
where $book[. contains text "AIDS" using uppercase] 
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[. contains text "AIDS" using uppercase]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book  
where $book contains text "AIDS" using case insensitive
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[. contains text "AIDS" using case 
insensitive]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "web" ftor "software"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text 
"web" ftor "software"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "web" ftand "software"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text 
"web" ftand "software"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "goal" ftand "obstacles" 
   ftand "task" ordered
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text 
"goal" ftand "obstacles" ftand "task" ordered]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book 
where $book contains text ftnot "us.* testing" 
   using wildcards
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[. contains text ftnot "us.* testing" 
using wildcards]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $up := $book/metadata
where $up contains text "usability" ftand ftnot "plan"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[./metadata contains text "usability" 
ftand ftnot "plan"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text ("résumés" using diacritics sensitive 
   ftor "drafts" ftor "correspondence") ftand ftnot 
   "book drafts"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[./content contains text ("résumés" 
using diacritics sensitive ftor "drafts" ftor "correspondence") 
ftand ftnot "book drafts"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text ("résumés" using diacritics sensitive 
   ftor "drafts" ftor "correspondence") not in "book 
   drafts"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text ("résumés" 
using diacritics sensitive ftor "drafts" ftor "correspondence") 
not in "book drafts"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $subj := $book/metadata/subjects/subject
where $subj contains text "web site" ftand "usability"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[metadata/subjects/subject contains text 
"web site" ftand "usability"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book                        
let $subj := $book/metadata/subjects/subject            
where (some $s1 in $subj satisfies $s1 contains text "web site")    
   and (some $s2 in $subj satisfies $s2 contains text "usability")
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[(some $s1 in ./metadata/subjects/subject satisfies 
$s1 contains text "web site") 
and (some $s2  in ./metadata/subjects/subject satisfies 
$s2 contains text "usability")]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
where every $pub in $book//publisher satisfies 
   $pub contains text "ersatz" ftand "publications"
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[every $pub in .//publisher 
satisfies $pub contains text "ersatz" ftand "publications"]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "expert review methods" 
   occurs at least 2 times
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "expert 
review methods" occurs at least 2 times]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "software" ftand "developer" 
   using stemming distance at most 3 words
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "software" 
ftand "developer" using stemming distance at most 3 words]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "efficient" ftand "task" ftand 
   "completion" ordered distance at most 10 words
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "efficient" 
ftand "task" ftand "completion" ordered
distance at most 10 words]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text ("users" ftand "feeling") 
   using stemming ftand "well served" ftor 
   "well-served" ordered window 15 words
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text ("users" ftand 
"feeling") using stemming ftand "well served" 
ftor "well-served" ordered window 15 words]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text ("users" ftand "would" ftand "know" 
   ftand "step" same sentence) using stemming
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text ("users" ftand "would" 
ftand "know" ftand "step" same sentence) using stemming]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text "usability" ftand "web site" 
   ftand "efficiency" ftand "satisfaction" same paragraph
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text "usability" 
ftand "web site" ftand "efficiency" ftand "satisfaction" 
same paragraph]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $para := $book//p
let $fn := $para/footnote
where $para contains text "computer workstation" 
   and $fn contains text "comfortable"
return ($book/metadata/title, $para)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[.//p contains text "computer workstation" 
and .//p/footnote contains text "comfortable"]/(metadata/title, 
.//p)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $para := $book//chapter/p
where $para contains text "usability" ftand "test" 
   using stemming
return ($book/metadata/title, $para/step[1], $para/step[2])
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[.//chapter/p contains text "usability" 
ftand "test" using stemming]/(metadata/title, 
.//chapter/p/step[1], .//chapter/p/step[2])
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[@number="3"]
let $comp := $book/content/part/component/
   (subComponent|subComponent/subsubComponent)/
   componentTitle
let $parentComp := $comp[ancestor::node()]
where $comp contains text "flow diagram.?" 
   using wildcards and $parentComp 
   contains text "human computer interaction"
return ($book/metadata/title, $book/content)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[@number="3" and content/part/component/
(subComponent|subComponent/subsubComponent)/ 
componentTitle contains text "flow diagram.?" using wildcards 
and ./ancestor::node()[.//componentTitle contains text "human computer 
interaction"]]/(metadata/title, content)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $chapters := $book//chapter
where $chapters[./p contains text "usability 
   testing" and ./p/following-sibling::p contains text 
   "information architecture"]
return ($book/metadata/title, $chapters)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
        /books/book
     where $book//p[. contains text "testing" ftand "guidance" ftor
        "correct" distance at most 60 words without content *]
     return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[.//p contains text "testing" 
ftand "guidance" ftor "correct" distance at 
most 60 words without content *]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $chap := $book//chapter[. contains text "users 
   can be tested at any computer workstation 
   or in a lab" without content .//footnote]
where $chap
return ($book/metadata/title, $chap)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book//chapter[. contains text
"users can be tested at any computer workstation or in a lab"
without content .//footnote
]/(ancestor::book/metadata/title, .)/.
%%%for $chapter in doc("http://bstore1.example.com/full-text.xml")
   /books/book//chapter
where $chapter contains text "at any computer 
   workstation or in a lab" without content 
   $chapter//footnote[. contains text "workstation.*" 
   using wildcards]
return ($chapter/ancestor::book/metadata/title, $chapter)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book//chapter[. contains text "at any computer 
workstation or in a lab" without content 
.//footnote[. contains text "workstation.*" 
using wildcards]]/(ancestor::book/metadata/title, .)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $matches := $book//chapter/(p|p/footnote)[
   . contains text
   "workstation" ftand "lab" distance at most 6 words
   without content ./footnote]
where $matches
return ($book/metadata/title, $matches)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book//chapter/(p|p/footnote)[. contains text 
"workstation" ftand "lab" distance at most 6 words 
without content //footnote[. 
contains text "workstation." using wildcards]]   
/(ancestor::book/metadata/title, .)/.
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
where $book//subject[. contains text "&#32593;&#31449;&#21487;&#29992;&#24615;" using language "zh"]
   and $book/content/introduction/author[. contains text 
   "Elina" ftand "Rose" distance at most 3 words]
   and $book/content[. contains text "Millicent" ftand "Marigold" 
   distance at most 3 words]
return <book number="{$book/@number}"> 
          {$book/metadata/title, $book//subject, 
          $book/content/introduction/author, $book/content} 
       </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $para := $book/content//p
where $para contains text (("task" ftand "performing" 
   distance at most 3 words) ftand 
   "expert reviewer") using stemming
return ($book/metadata/title, $book/content)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content//p contains text (("task" 
ftand "performing" distance at most 3 words) 
ftand "expert reviewer") using stemming]/
(metadata/title, content)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $quote := $book/content
where $quote contains text (("millicent" 
   ftand "marigold" ordered distance at most 3 words)
   ftand "quote.{0,5}" using wildcards using thesaurus at  
   "http://bstore1.example.com/UsabilityThesaurus.xml"
   relationship "synonyms" distance at most 3 words)
   ftand "usability testing" ftand "iterating" using stemming 
   distance at most 50 words
return $book
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text (("millicent" 
ftand "marigold" ordered distance at most 3 words)
ftand "quote.{0,5}" using wildcards using thesaurus at 
"http://bstore1.example.com/UsabilityThesaurus.xml"
relationship "synonyms" distance at most 3 words)
ftand "usability testing" ftand "iterating" using stemming 
distance at most 50 words]
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $au := $book/metadata/author
let $co := $book/content
where not( $au contains text ("montana" ftand "marigold"))
   and $co contains text ("correct" ftor "comment" 
   using stemming ftor "guidance" ftor "assistance" 
   ftor "help") ftand "usability test.*" using wildcards 
   window 80 words without content $co//footnote
return <book number="{$book/@number}"> 
          {$book/metadata/title, $co}
          </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $title := $book/metadata/title
let $in := $book/content/introduction
let $pin := $book/content/part/introduction
where $title contains text "usability" and $in contains text 
   "satisfaction" and $pin contains text "identify 
   problems"
return <book number="{$book/@number}">{ 
    ($title, 
         if (count($book/metadata/author) > 0)
         then ($book/metadata/author, $in, $pin)
         else ($book/metadata/publicationInfo/publisher, $in, $pin))
     }
       </book> 
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $var := $book/metadata/title
where $var contains text "usability"
return <result> 
          {$book/metadata/title, $book/metadata/author} 
           </result>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $ct := $book/content/part/chapter/title
where $ct contains text "usability" ftand "test" 
   using stemming
return <book number="{$book/@number}"> 
          {$book/metadata/title,
          for $title in $ct
          return 
             ($title, 
             <number-of-steps> 
                {count($title/..//step)}
             </number-of-steps>)}
       </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[./metadata/title contains text 
   "usability"]
return <book number="{$book/@number}">
          {$book/metadata/title,
             if (count($book/metadata//author) > 0) 
             then $book/metadata//author 
             else $book/metadata//publisher}
       </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[metadata/title contains text "usability"]
return <book number="{$book/@number}">
           {$book/metadata/title,  
             if ($book/metadata/price > 25)
             then <price>{concat("$", round($book/metadata/price))}</price>
             else ()
           }   
       </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[.//publicationInfo/place/text() 
   = "Washington, D.C."]
let $intro := $book/content/introduction
where $intro contains text "résumés" using diacritics sensitive
   ftand "drafts" ftand "correspondence"
return <book number="{$book/@number}"> 
           {$book/metadata/title, $intro}
           </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[metadata/title contains text 
   "usability"]
return <book number="{$book/@number}">
          {$book/metadata/title} 
          <has-publishers> 
             {if (count($book//publisher) > 1) 
             then "true" else "false"}
          </has-publishers>
       </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book[./metadata/publicationInfo/
   (dateIssued|dateRevised) > "2000-12-31" 
   and count(metadata/author) > 1]
let $subj := $book//subject[
             . contains text "usability test.*" using wildcards]
where $subj
return <book number="{$book/@number}"> 
          {$book/metadata/title, $book/metadata/author, $subj}
           </book>
%%%let $books := doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $bookSubject := 
   $books/metadata[./title/@shortTitle 
   contains text "Usability Basics"]/subjects/subject
for $book in $books   
where $book/metadata/publicationInfo/
(dateIssued|dateRevised) > 2001 and 
$book/metadata/subjects/subject contains text 
     {$bookSubject} any
return
        <book number="{$book/@number}">
           {$book/metadata/title,
           $book/metadata/author}
        </book>
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $cont := $book/content
where $cont contains text ("successfully" 
   ftand "completing" ftand "tasks"
   window (count($cont/part/chapter) * 4) 
   words) using stemming
return ($book/metadata/title, $cont)
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[content contains text ("successfully" 
ftand "completing" ftand "tasks"
window (count(content/part/chapter) * 4) 
words) using stemming]/(metadata/title, content)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
  /books/book
let score $s := ($book/metadata/title contains text 
   "usability" or $book/content contains text "usability") 
where $s > 0  
order by $s descending 
return <book number="{$book/@number}"> 
          {$book/metadata/title}
          <score>{$s}</score> 
       </book>
%%%for $result at $i in
     for $book score $s in 
        doc("http://bstore1.example.com/full-text.xml")
        /books/book[. contains text "usability"]
      order by $s ascending
      return $book
   where $i <= 2
   return <book number="{$result/@number}"> 
      {$result/metadata/title}</book>
%%%for $book score $s in 
   doc("http://bstore1.example.com/full-text.xml")
   /books/book[. contains text "usability"]
where $s > 0.1
return $book/metadata/title
%%%doc("http://bstore1.example.com/full-text.xml")
/books/book[(for $i score $s in .[. contains text "usability"]
return $s) > 0.1]/metadata/title
%%%declare function local:filter ( $nodes 
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
                      local:filter( $e/node() except $exclude, 
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
return local:filter($book, $irrelevantParts)
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let score $s := $book/content contains text "software"
order by $s descending
return $book
%%%for $book in doc("http://bstore1.example.com/full-text.xml")
   /books/book
let $booktext := $book/content [. contains text ("conduct"
   ftand "usability" ftand "tests" distance at most
   10 words) using stemming]
let score $s := $booktext contains text
   (("measuring" ftand "success" distance
   at most 4 words) weight {1.8}) using stemming  
where $booktext
order by $s descending
return ($book/metadata/title, $booktext)
%%%