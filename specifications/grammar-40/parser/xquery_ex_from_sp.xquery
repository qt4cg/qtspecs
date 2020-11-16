(: parse tests :)
"&amp;"
%%%pi
%%%math:pi
%%%Q{http://www.w3.org/2005/xpath-functions/math}pi
%%%
in-scope-prefixes($e) ! namespace {namespace-uri-for-prefix($e,.)} {.}

%%%E1/E2
%%%E1[E2]
%%%E2
%%%E1
%%%E2
%%%E2
%%%E1
%%%E2
%%%.
%%%E1/E2
%%%E1[E2]
%%%E1
%%%E2
%%%fn:position()
%%%E1/E2
%%%E1[E2]
%%%E2
%%%E1
%%%fn:last()
%%%E1/E2
%%%E1[E2]
%%%E2
%%%E1
%%%fn:doc(fn:document-uri($N)) is $N
%%%fn:document-uri($N)
%%%fn:doc(fn:document-uri($N)) is $N
%%%module namespace myfns = "http://www.example.com/function-library";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method   "xml";
declare option output:encoding "iso-8859-1";
declare option output:indent   "yes";
declare option output:parameter-document "file:///home/me/serialization-parameters.xml";

%%%
error()

%%%
if (empty($arg))
then
  "cat" * 2
else
  0

%%%($x div $y) + xs:decimal($z)
%%%($x div $y)
%%%xs:decimal($z)
%%%fn:error(xs:QName("app:err057"), "Unexpected value", fn:string($v))
%%%$s[1]
%%%position()=1
%%%//book[author eq 'Berners-Lee']
%%%$e eq 0
%%%S1 = S2
%%%some $x in $expr1 satisfies $x = 47
%%%//product[id = 47]
%%%if (doc-available('abc.xml')) then doc('abc.xml') else ()
%%%string-length(//title)
%%%//part[color eq "Red"]
%%%//part[color = "Red"][color eq
"Red"]
%%%$N[@x castable as xs:date][xs:date(@x) gt xs:date("2000-01-01")]
%%%$N[if (@x castable as xs:date)
   then xs:date(@x) gt xs:date("2000-01-01")
   else false()]
%%%fn:collection("http://example.org")//customer
%%%fn:normalize-space(N)
%%%processing-instruction(xml-stylesheet)
%%%processing-instruction("xml-stylesheet")
%%%comment()
%%%namespace-node()
%%%document-node()
%%%document-node(element(book))
%%%element(book)
%%%element()
%%%element(*)
%%%element(person)
%%%element(person, surgeon)
%%%element(person, surgeon?)
%%%element(*, surgeon)
%%%element(*, surgeon?)
%%%schema-element(customer)
%%%attribute()
%%%attribute(*)
%%%attribute(price)
%%%attribute(price, currency)
%%%attribute(*, currency)
%%%schema-attribute(color)
%%%"12.5"
%%%12
%%%12.5
%%%125E2
%%%"He said, ""I don't like it."""
%%%"Ben &amp; Jerry&apos;s"
%%%"&#8364;99.50"
%%%xs:integer("12")
%%%xs:date("2001-08-25")
%%%xs:dayTimeDuration("PT5H")
%%%xs:float("NaN")
%%%xs:double("INF")
%%%9 cast as
                        hatsize
%%%(2 + 4)
		    * 5
%%%(2 + 4)
%%%2 + 4 * 5
%%%fn:doc("bib.xml")/books/book[fn:count(./author)>1]
%%%(1 to
              100)[. mod 5 eq 0]
%%%my:three-argument-function(1,
			2, 3)
%%%my:two-argument-function((1,
			2), 3)
%%%my:two-argument-function(1,
			())
%%%my:one-argument-function((1, 2,
			3))
%%%my:one-argument-function(( ))
%%%my:zero-argument-function( )
%%%
declare function local:filter($s as item()*, $p as function(xs:string) as xs:boolean) as item()*
{
  $s[$p(.)]
};

let $f := function($a) { starts-with($a, "E") }
return
  local:filter(("Ethel", "Enid", "Gertrude"), $f)
      
%%%fn:abs#1
%%%fn:concat#5
%%%local:myfunc#2
%%%function() as xs:integer+ { 2, 3, 5, 7, 11, 13 }
%%%function($a as xs:double, $b as xs:double) as xs:double { $a * $b }
%%%function($a) { $a }
%%%collection()/(let $a := . return function() { $a })
%%%$products[price gt 100]
%%%(1 to 100)[. mod 5 eq 0]
%%%(21 to 29)[5]
%%%$orders[fn:position() = (5 to 9)]
%%%$book/(chapter | appendix)[fn:last()]
%%%$f(2, 3)
%%%$f[2]("Hi there")
%%%$f()[2]
%%%child::div1/child::para
%%%*
%%%/*
%%%/
	 *
%%%(/) * 5
%%%4 + (/) * 5
%%%4 + /
%%%/
	 union /*
%%%(/)
	 union /*
%%%child::para
%%%child::para
%%%attribute::abc:href
%%%child::*
%%%attribute::*
%%%NCName:*
%%%Q{http://example.com/msg}*
%%%*:NCName
%%%node()
%%%text()
%%%comment()
%%%namespace-node()
%%%element()
%%%schema-element(person)
%%%element(person)
%%%element(person, surgeon)
%%%element(*,
		  surgeon)
%%%attribute()
%%%attribute(price)
%%%attribute(*,
                  xs:decimal)
%%%document-node()
%%%document-node(element(book))
%%%element(book)
%%%child::chapter[2]
%%%descendant::toy[attribute::color = "red"]
%%%child::employee[secretary][assistant]
%%%preceding::foo[1]
%%%(preceding::foo)[1]
%%%(preceding::foo)
%%%ancestor::*[1]
%%%(ancestor::*)[1]
%%%child::para
%%%child::*
%%%child::text()
%%%child::node()
%%%attribute::name
%%%attribute::*
%%%parent::node()
%%%descendant::para
%%%ancestor::div
%%%ancestor-or-self::div
%%%descendant-or-self::para
%%%self::para
%%%child::chapter/descendant::para
%%%child::*/child::para
%%%/
%%%/descendant::para
%%%/descendant::list/child::member
%%%child::para[fn:position() = 1]
%%%child::para[fn:position() = fn:last()]
%%%child::para[fn:position() = fn:last()-1]
%%%child::para[fn:position() > 1]
%%%following-sibling::chapter[fn:position() = 1]
%%%preceding-sibling::chapter[fn:position() = 1]
%%%/descendant::figure[fn:position() = 42]
%%%/child::book/child::chapter[fn:position() = 5]/child::section[fn:position() = 2]
%%%child::para[attribute::type eq "warning"]
%%%child::para[attribute::type eq 'warning'][fn:position() = 5]
%%%child::para[fn:position() = 5][attribute::type eq "warning"]
%%%child::chapter[child::title = 'Introduction']
%%%child::chapter[child::title]
%%%child::*[self::chapter or self::appendix]
%%%child::*[self::chapter or
self::appendix][fn:position() = fn:last()]
%%%para[@type="warning"]
%%%child::para[attribute::type="warning"]
%%%section/para
%%%child::section/child::para
%%%section/@id
%%%child::section/attribute::id
%%%section/attribute(id)
%%%child::section/attribute::attribute(id)
%%%div1//para
%%%child::div1/descendant-or-self::node()/child::para
%%%//para[1]
%%%/descendant::para[1]
%%%..
%%%parent::node()
%%%../title
%%%parent::node()/child::title
%%%*
%%%text()
%%%@name
%%%@*
%%%para[1]
%%%para[fn:last()]
%%%*/para
%%%/book/chapter[5]/section[2]
%%%chapter//para
%%%//para
%%%//@version
%%%//list/member
%%%.//para
%%%..
%%%../@lang
%%%para[@type="warning"]
%%%para[@type="warning"][5]
%%%para[5][@type="warning"]
%%%chapter[title="Introduction"]
%%%chapter[title]
%%%employee[@secretary and @assistant]
%%%book/(chapter|appendix)/section
%%%E/.
%%%(10, 1, 2, 3, 4)
%%%(10, (1, 2), (), (3, 4))
%%%(salary, bonus)
%%%($price, $price)
%%%(10, 1 to 4)
%%%10 to 10
%%%15 to 10
%%%fn:reverse(10 to 15)
%%%$seq1 union $seq2
%%%$seq2 union $seq3
%%%$seq1 intersect $seq2
%%%$seq2 intersect $seq3
%%%$seq1 except $seq2
%%%$seq2 except $seq3
%%%a-b
%%%a - b
%%%a -b
%%%A - B + C - D
%%%((A - B) + C) - D
%%%$arg1 idiv $arg2
%%%($arg1 div $arg2) cast as xs:integer?
%%%-1.5
%%%-1
%%%-3 div 2
-3 idiv 2
%%%$emp/hiredate - $emp/birthdate
%%%$unit-price - $unit-discount
%%%$book1/author eq "Kennedy"
%%%//product[weight gt 100]
%%%<a>5</a> eq <a>5</a>
%%%<a>5</a> eq <b>5</b>
%%%my:hatsize(5) eq my:shoesize(5)
%%%fn:QName("http://example.com/ns1", "this:color")
   eq fn:QName("http://example.com/ns1", "that:color")
%%%x < 17
%%%$book1/author = "Kennedy"
%%%($a, $b) = ($c, 3.0)
%%%($a, $b) = ($c, 2.0)
%%%/books/book[isbn="1558604820"] is /books/book[call="QA76.9 C3845"]
%%%<a>5</a> is <a>5</a>
%%%/transactions/purchase[parcel="28-451"]
   << /transactions/sale[parcel="33-870"]
%%%1 eq 1 and 2 eq 2
%%%1 eq 1 or 2 eq 3
%%%1 eq 2 and 3 idiv 0 = 1
%%%1 eq 1 or 3 idiv 0 = 1
%%%1 eq 1 and 3 idiv 0 = 1
%%%<book isbn="isbn-0060229357">
    <title>Harold and the Purple Crayon</title>
    <author>
        <first>Crockett</first>
        <last>Johnson</last>
    </author>
</book>
%%%<example>
   <p> Here is a query. </p>
   <eg> $b/title </eg>
   <p> Here is the result of the query. </p>
   <eg>{ $b/title }</eg>
</example>
%%%
<example>
  <p> Here is a query. </p>
  <eg> $b/title </eg>
  <p> Here is the result of the query. </p>
  <eg><title>Harold and the Purple Crayon</title></eg>
</example>
%%%<shoe size="7"/>
%%%<shoe size="{7}"/>
%%%<shoe size="{()}"/>
%%%<chapter ref="[{1, 5 to 7, 9}]"/>
%%%<shoe size="As big as {$hat/@size}"/>
%%%<cat xmlns = "http://example.org/animals">
  <breed>Persian</breed>
</cat>
%%%<box xmlns:metric = "http://example.org/metric/units"
     xmlns:english = "http://example.org/english/units">
  <height> <metric:meters>3</metric:meters> </height>
  <width> <english:feet>6</english:feet> </width>
  <depth> <english:inches>18</english:inches> </depth>
</box>
%%%<a>{1}</a>
%%%<a>{1, 2, 3}</a>
%%%<c>{1}{2}{3}</c>
%%%<b>{1, "2", "3"}</b>
%%%<fact>I saw 8 cats.</fact>
%%%<fact>I saw {5 + 3} cats.</fact>
%%%<fact>I saw <howmany>{5 + 3}</howmany> cats.</fact>
%%%<book isbn="isbn-0060229357">
    <title>Harold and the Purple Crayon</title>
    <author>
        <first>Crockett</first>
        <last>Johnson</last>
    </author>
</book>
%%%<cat>
   <breed>{$b}</breed>
   <color>{$c}</color>
</cat>
%%%<a>  {"abc"}  </a>
%%%<a>abc</a>
%%%<a>  abc  </a>
%%%<a> z {"abc"}</a>
%%%<a> z abc</a>
%%%<a>&#x20;{"abc"}</a>
%%%<a> abc</a>
%%%<a>{"  "}</a>
%%%<?format role="output" ?>
%%%<!-- Tags are ignored in the following section -->
%%%element book {
   attribute isbn {"isbn-0060229357" },
   element title { "Harold and the Purple Crayon"},
   element author {
      element first { "Crockett" },
      element last {"Johnson" }
   }
}
%%%element {fn:node-name($e)}
   {$e/@*, 2 * fn:data($e)}
%%%fn:node-name($e)
%%%fn:node-name($e)
%%%fn:exactly-one(fn:node-name($e))
%%%
<entry word="address">
   <variant xml:lang="de">Adresse</variant>
   <variant xml:lang="it">indirizzo</variant>
</entry>

%%%<address>123 Roosevelt Ave. Flushing, NY 11368</address>
%%%
  element
    {$dict/entry[@word=name($e)]/variant[@xml:lang="it"]}
    {$e/@*, $e/node()}
%%%<indirizzo>123 Roosevelt Ave. Flushing, NY 11368</indirizzo>
%%%attribute size {4 + 3}
%%%
attribute
   { if ($sex = "M") then "husband" else "wife" }
   { <a>Hello</a>, 1 to 3, <b>Goodbye</b> }

%%%document
  {
      <author-list>
         {fn:doc("bib.xml")/bib/book/author}
      </author-list>
  }
%%%text {"Hello"}
%%%let $target := "audio-output",
    $content := "beep"
return processing-instruction {$target} {$content}
%%%let $homebase := "Houston"
return comment {fn:concat($homebase, ", we have a problem.")}
%%%namespace a {"http://a.example.com" }
%%%namespace {"a"} {"http://a.example.com" }
%%%namespace { "" } {"http://a.example.com" }
%%%
<age xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> {
  namespace xs {"http://www.w3.org/2001/XMLSchema"},
  attribute xsi:type {"xs:integer"},
  23
}</age>

%%%
<a:form>
 {
  namespace a { "http://a.example.com" }
 }
</a:form>

%%%element e { namespace {''} {'u'} }
%%%declare namespace p="http://example.com/ns/p";
declare namespace q="http://example.com/ns/q";
declare namespace f="http://example.com/ns/f";

<p:a q:b="{f:func(2)}" xmlns:r="http://example.com/ns/r"/>

%%%<p xsi:type="xs:integer">3</p>
%%%<p xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xsi:type="xs:integer">3</p>
%%%for tumbling window $w in (2, 4, 6, 8, 10, 12, 14)
    start at $s when fn:true()
    only end at $e when $e - $s eq 2
return <window>{ $w }</window>
%%%
for tumbling window $w in (2, 4, 6, 8, 10, 12, 14)
    start at $s when fn:true()
    only end at $e when $e - $s eq 2
return avg($w)
%%%for tumbling window $w in (2, 4, 6, 8, 10, 12, 14)
    start $first at $s when fn:true()
    only end $last at $e when $e - $s eq 2
return <window>{ $first, $last }</window>
%%%for tumbling window $w in (2, 4, 6, 8, 10, 12, 14)
    start at $s when fn:true()
    end at $e when $e - $s eq 2
return <window>{ $w }</window>
%%%for tumbling window $w in (2, 4, 6, 8, 10, 12, 14)
    start at $s when $s mod 3 = 1
return <window>{ $w }</window>
%%%for tumbling window $w in (2, 4, 6, 8, 10, 12, 14)
    start $first when $first mod 3 = 0
return <window>{ $w }</window>
%%%for sliding window $w in (2, 4, 6, 8, 10, 12, 14)
    start at $s when fn:true()
    only end at $e when $e - $s eq 2
return <window>{ $w }</window>
%%%for sliding window $w in (2, 4, 6, 8, 10, 12, 14)
    start at $s when fn:true()
    only end at $e when $e - $s eq 2
return avg($w)
%%%for sliding window $w in (2, 4, 6, 8, 10, 12, 14)
    start at $s when fn:true()
    end at $e when $e - $s eq 2
return <window>{ $w }</window>
%%%for tumbling window $w in //closing
   start $first next $second when $first/price < $second/price
   end $last next $beyond when $last/price > $beyond/price
return
   <run-up>
      <start-date>{fn:data($first/date)}</start-date>
      <start-price>{fn:data($first/price)}</start-price>
      <end-date>{fn:data($last/date)}</end-date>
      <end-price>{fn:data($last/price)}</end-price>
   </run-up>
%%%for $symbol in fn:distinct-values(//symbol)
let $closings := //closing[symbol = $symbol]
for tumbling window $w in $closings
   start $first next $second when $first/price < $second/price
   end $last next $beyond when $last/price > $beyond/price
return
   <run-up symbol="{$symbol}">
      <start-date>{fn:data($first/date)}</start-date>
      <start-price>{fn:data($first/price)}</start-price>
      <end-date>{fn:data($last/date)}</end-date>
      <end-price>{fn:data($last/price)}</end-price>
   </run-up>
%%%for $x at $i in $inputvalues
where $i mod 100 = 0
return $x
%%%for $x at $i in $inputvalues
where $i mod 100 = 0
return $x
%%%for $p in $products
order by $p/sales descending
count $rank
where $rank <= 3
return
   <product rank="{$rank}">
      {$p/name, $p/sales}
   </product>
%%%

let $x := 64000
for $c in //customer
let $d := $c/department
where $c/salary > $x
group by $d
return
 <department name="{$d}">
  Number of employees earning more than ${$x} is {count($c)}
 </department>
%%%let $x := 64000
for $c in //customer
where $c/salary > $x
group by $d := $c/department
return
<department name="{$d}">
   Number of employees earning more than ${$x} is {count($c)}
</department>
%%%
let $x := 64000
for $c in //customer
let $d := $c/department
where $c/salary > $x
group by $d
return
 <department name="{$d}">
  Number of employees earning more than ${distinct-values($x)} is {count($c)}
 </department>
%%%for $s in $sales
let $storeno := $s/storeno
group by $storeno
return <store number="{$storeno}" total-qty="{sum($s/qty)}"/>
%%%for $s in $sales,
    $p in $products[itemno = $s/itemno]
let $storeno := $s/storeno,
    $category := $p/category,
    $revenue := $s/qty * $p/price
group by $storeno, $category
return
    <summary storeno="{$storeno}"
             category="{$category}"
             revenue="{sum($revenue)}"/>
%%%
for $s in $sales,
    $p in $products[itemno = $s/itemno]
let $revenue := $s/qty * $p/price
group by $storeno := $s/storeno, 
    $category := $p/category
return
    <summary storeno="{$storeno}"
              category="{$category}"
              revenue="{sum($revenue)}"/>

%%%for $s1 in $sales
let $storeno := $s1/storeno
group by $storeno
order by $storeno
return
  <store storeno="{$storeno}">
    {for $s2 in $s1,
         $p in $products[itemno = $s2/itemno]
     let $category := $p/category,
         $revenue := $s2/qty * $p/price
     group by $category
     let $group-revenue := sum($revenue)
     where $group-revenue > 10000
     order by $group-revenue descending
     return <category name="{$category}" revenue="{$group-revenue}"/>
    }
  </store>

%%%let $high-price := 1000
for $p in $products[price > $high-price]
let $category := $p/category
group by $category
return
   <category name="{$category}">
      {fn:count($p)} products have price greater than {$high-price}.
   </category>
%%%let $high-price := 1000
return
   for $p in $products[price > $high-price]
   let $category := $p/category
   group by $category
   return
      <category name="{$category}">
         {fn:count($p)} products have price greater than {$high-price}.
      </category>
%%%+0.0 gt -0.0
%%%-0.0 gt +0.0
%%%for $e in $employees
order by $e/salary descending
return $e/name
%%%$books/book[price < 100]
%%%for $b in $books/book[price < 100]
order by $b/title
return $b
%%%for $d in fn:doc("depts.xml")//dept
let $e := fn:doc("emps.xml")//emp[deptno eq $d/deptno]
where fn:count($e) >= 10
order by fn:avg($e/salary) descending
return
   <big-dept>
      {
      $d/deptno,
      <headcount>{fn:count($e)}</headcount>,
      <avgsal>{fn:avg($e/salary)}</avgsal>
      }
   </big-dept>
%%%for $d in fn:doc("depts.xml")//dept
order by $d/deptno
for $e in fn:doc("emps.xml")//emp[deptno eq $d/deptno]
return
   <assignment>
      {$d/deptno, $e/name}
   </assignment>
%%%let $i := 5,
    $j := 20 * $i
return $i, $j
%%%let $i := 5,
    $j := 20 * $i
return ($i, $j)
%%%(//a/b)[5]
%%%unordered {
  for $p in fn:doc("parts.xml")/parts/part[color = "Red"],
      $s in fn:doc("suppliers.xml")/suppliers/supplier
  where $p/suppno = $s/suppno
  return
    <ps>
       { $p/partno, $s/suppno }
    </ps>
}
%%%if ($widget1/unit-cost < $widget2/unit-cost)
  then $widget1
  else $widget2
%%%if ($part/@discounted)
  then $part/wholesale
  else $part/retail
%%%
switch ($animal)
   case "Cow" return "Moo"
   case "Cat" return "Meow"
   case "Duck" return "Quack"
   default return "What's that odd noise?"
 
%%%every $part in /parts/part satisfies $part/@discounted
%%%some $emp in /emps/employee satisfies
     ($emp/bonus > 0.25 * $emp/salary)
%%%some $x in (1, 2, 3), $y in (2, 3, 4)
satisfies $x + $y = 4
%%%every $x in (1, 2, 3), $y in (2, 3, 4)
satisfies $x + $y = 4
%%%some $x in (1, 2, "cat") satisfies $x * 2 = 4
%%%every $x in (1, 2, "cat") satisfies $x * 2 = 4
%%%some $x as xs:integer in (1, 2, "cat") satisfies $x * 2 = 4
%%%try {
    $x cast as xs:integer
}
catch * {
    0
}
%%%try {
    $x cast as xs:integer
}
catch err:FORG0001 {
    0
}
%%%try {
    $x cast as xs:integer
}
catch err:FORG0001 | err:XPTY0004 {
    0
}
%%%try {
    fn:error(fn:QName('http://www.w3.org/2005/xqt-errors', 'err:FOER0000'))
}
catch * {
    $err:code, $err:value, " module: ",
    $err:module, "(", $err:line-number, ",", $err:column-number, ")"
}
%%%
declare function local:thrice($x as xs:integer) as xs:integer
{
    3*$x
};

local:thrice(try { "oops" } catch * { 3 } )

%%%5 instance of xs:integer
%%%<a>{5}</a> instance of xs:integer
%%%(5, 6) instance of xs:integer+
%%%. instance of element()
%%%typeswitch($customer/billing-address)
   case $a as element(*, USAddress) return $a/state
   case $a as element(*, CanadaAddress) return $a/province
   case $a as element(*, JapanAddress) return $a/prefecture
   default return "unknown"

%%%typeswitch($customer/billing-address)
   case $a as element(*, USAddress)
            | element(*, AustraliaAddress)
            | element(*, MexicoAddress)
     return $a/state
   case $a as element(*, CanadaAddress)
     return $a/province
   case $a as element(*, JapanAddress)
     return $a/prefecture
   default
     return "unknown"
%%%"2003-02-31" cast as xs:date
%%%E castable as T
%%%
if ($x castable as hatsize)
   then $x cast as hatsize
   else if ($x castable as IQ)
   then $x cast as IQ
   else $x cast as xs:string
%%%(($arg) cast as T?)
%%%("2000-01-01" cast as
xs:date?)
%%%xs:date("2000-01-01")
%%%(($floatvalue * 0.2E-5) cast as xs:decimal?)
%%%xs:decimal($floatvalue * 0.2E-5)
%%%("P21D" cast as xs:dayTimeDuration?)
%%%xs:dayTimeDuration("P21D")
%%%("12345" cast as
usa:zipcode?)
%%%usa:zipcode("12345")
%%%17 cast as apple
%%%apple(17)

%%%$myaddress treat as element(*, USAddress)
%%%child::div1 / child::para / string() ! concat("id-", .)
%%%$emp ! (@first, @middle, @last)
%%%$docs ! ( //employee)
%%%avg( //employee / salary ! translate(., '$', '') ! number(.))
%%%declare namespace exq = "http://example.org/XQueryImplementation";
   (# exq:use-index #)
      { $bib/book/author[name='Berners-Lee'] }

%%%declare namespace exq = "http://example.org/XQueryImplementation";
   for $x in
      (# exq:distinct //city by @country #)
      { //city[not(@country = preceding::city/@country)] }
   return f:show-city($x)

%%%//city[not(@country =
preceding::city/@country)]
%%%xquery version "1.0";
foo
%%%xquery version "3.0" encoding "utf-8";
foo
%%%module namespace math = "http://example.org/math-functions";
declare base-uri "http://example.org";
%%%module namespace gis = "http://example.org/gis-functions";
declare base-uri "http://example.org";
%%%module namespace myfns = "http://www.example.com/function-library";
declare boundary-space preserve;
%%%module namespace myfns = "http://www.example.com/function-library";
declare default collation
  "http://example.org/languages/Icelandic";
%%%module namespace myfns = "http://www.example.com/function-library";
declare base-uri "http://example.org";
%%%module namespace myfns = "http://www.example.com/function-library";
declare construction strip;
%%%module namespace myfns = "http://www.example.com/function-library";
declare ordering unordered;
%%%module namespace myfns = "http://www.example.com/function-library";
declare default order empty least;
%%%module namespace myfns = "http://www.example.com/function-library";
declare copy-namespaces preserve, no-inherit;
%%%declare decimal-format local:de decimal-separator = "," grouping-separator = ".";
declare decimal-format local:en decimal-separator = "." grouping-separator = ",";

let $numbers := (1234.567, 789, 1234567.765)
for $i in $numbers
return (
  format-number($i, "#.###,##", "local:de"),
  format-number($i, "#,###.##", "local:en")
)
%%%module namespace myfns = "http://www.example.com/function-library";
import schema namespace soap="http://www.w3.org/2003/05/soap-envelope"
at "http://www.w3.org/2003/05/soap-envelope/";
%%%module namespace myfns = "http://www.example.com/function-library";
import schema default element namespace "http://example.org/abc";
%%%module namespace myfns = "http://www.example.com/function-library";
import schema default element namespace ""
at "http://example.org/xyz.xsd";
%%%module namespace myfns = "http://www.example.com/function-library";
import schema default element namespace "";
%%%module namespace myfns = "http://www.example.com/function-library";
import module namespace gis="http://example.org/gis-functions";
%%%(: Error - geometry:triangle is not defined :)
import module namespace geo = "http://example.org/geo-functions";
declare variable $t as geometry:triangle := geo:make-triangle();

$t
%%%import module namespace geo = "http://example.org/geo-functions";
declare variable $t := geo:make-triangle();

$t
%%%import schema namespace geometry = "http://example.org/geo-schema-declarations";
import module namespace geo = "http://example.org/geo-functions";
declare variable $t as geometry:triangle := geo:make-triangle();

$t
%%%
declare namespace foo = "http://example.org";
<foo:bar> Lentils </foo:bar>

%%%
declare namespace xx = "http://example.org";

let $i := <foo:bar xmlns:foo = "http://example.org">
              <foo:bing> Lentils </foo:bing>
          </foo:bar>
return $i/xx:bing

%%%
<foo:bing xmlns:foo = "http://example.org"> Lentils </foo:bing>

%%%module namespace myfns = "http://www.example.com/function-library";
declare default element namespace "http://example.org/names";
%%%module namespace myfns = "http://www.example.com/function-library";
declare default function namespace
      "http://example.org/math-functions";
%%%module namespace myfns = "http://www.example.com/function-library";
declare default function namespace "http://www.w3.org/2005/xpath-functions/math";
%%%module namespace myfns = "http://www.example.com/function-library";
declare variable $x as xs:integer := 7;
%%%module namespace myfns = "http://www.example.com/function-library";
declare variable $x := 7.5;
%%%module namespace myfns = "http://www.example.com/function-library";
declare variable $x as xs:integer external;
%%%module namespace myfns = "http://www.example.com/function-library";
declare variable $x external;
%%%module namespace myfns = "http://www.example.com/function-library";
declare variable $math:pi as xs:double := 3.14159E0;
%%%module namespace myfns = "http://www.example.com/function-library";
declare variable $sasl:username as xs:string := "jonathan@example.com";
%%%module namespace myfns = "http://www.example.com/function-library";
declare variable $x as xs:integer external := 47;
%%%module namespace myfns = "http://www.example.com/function-library";
declare %eg:volatile variable $time as xs:time external;
%%%module namespace myfns = "http://www.example.com/function-library";

declare variable $a := local:f();
declare variable $b := 1;
declare function local:f() { $b };

%%%module namespace myfns = "http://www.example.com/function-library";
declare namespace env="http://www.w3.org/2003/05/soap-envelope";
declare context item as element(env:Envelope) external;
%%%module namespace myfns = "http://www.example.com/function-library";

declare context item as element(sys:log) external := doc("/var/xlogs/sysevent.xml")/sys:log;

%%%module namespace myfns = "http://www.example.com/function-library";

declare %nondeterministic function my:random( ) as xs:integer external;

%%%let $r := my:random( )
return
   if ($r > 0 and $r < 10) then "Yes" else "No"

%%%if (my:random( ) > 0 and my:random( ) < 10) then "Yes" else "No"
%%%for $i in 1 to 10
return my:random( )
%%%let $r := my:random( )
return
     for $i in 1 to 10
     return $r
%%%module namespace myfns = "http://www.example.com/function-library";
declare %java:method("java.lang.Math.sin") function math:sin($a) external;
%%%module namespace myfns = "http://www.example.com/function-library";
declare %java:method("java.lang.StrictMath.copySign") function smath:copySign($magnitude, $sign) external;
%%%declare function local:summary($emps as element(employee)*)
   as element(dept)*
{
   for $d in fn:distinct-values($emps/deptno)
   let $e := $emps[deptno = $d]
   return
      <dept>
         <deptno>{$d}</deptno>
         <headcount> {fn:count($e)} </headcount>
         <payroll> {fn:sum($e/salary)} </payroll>
      </dept>
};

local:summary(fn:doc("acme_corp.xml")//employee[location = "Denver"])
%%%declare function local:depth($e as node()) as xs:integer
{
   (: A node with no children has depth 1 :)
   (: Otherwise, add 1 to max depth of children :)
   if (fn:empty($e/*)) then 1
   else fn:max(for $c in $e/* return local:depth($c)) + 1
};

local:depth(fn:doc("partlist.xml"))

%%%module namespace myfns = "http://www.example.com/function-library";
declare option exq:strip-comments "true";

%%%module namespace myfns = "http://www.example.com/function-library";
declare namespace smath = "http://example.org/MathLibrary";
declare option exq:java-class "smath = java.lang.StrictMath";

%%%module namespace myfns = "http://www.example.com/function-library";
declare option require-feature "schema-aware higher-order-function";
declare option prohibit-feature "static-typing";
	  
%%%module namespace myfns = "http://www.example.com/function-library";
declare namespace rand = "http://random.example.com/xquery";
declare option require-feature "rand:random-result";
	  
%%%module namespace myfns = "http://www.example.com/function-library";
declare option prohibit-feature "all-extensions";
%%%module namespace myfns = "http://www.example.com/function-library";
declare option require-feature "all-optional-features";
%%%module namespace myfns = "http://www.example.com/function-library";
declare namespace gis="http://geography.example.com/gis";
declare option require-feature "gis:geography-terrain";
declare option prohibit-feature "gis:all-optional-features";
	  
%%%/ *
%%%(/) * 5
%%%5 * /
%%%4 treat as item() + -
	5
%%%(4
	treat as item()+) - 5
%%%(4
	treat as item()) + -5
%%%address (: this may be empty
              :)
%%%for (: whom the bell :)
              $tolls in 3 return $tolls
%%%"this is just a string
                  :)"
%%%"this is another string
                  (:"
%%%for (: set up loop :) $i
                  in $x return $i
%%%5 instance (: strange
                  place for a comment :) of xs:integer
%%%
                    <eg> (: an example:) </eg>

%%%foo -foo
%%%foo - foo
%%%foo(: This is a comment :)-
            foo
%%%foo-foo
%%%xquery version "1.0" encoding "utf-8";
foo
%%%<descriptive-catalog>
   { 
     for $i in fn:doc("catalog.xml")/items/item,
         $p in fn:doc("parts.xml")/parts/part[partno = $i/partno],
         $s in fn:doc("suppliers.xml")/suppliers
                  /supplier[suppno = $i/suppno]
     order by $p/description, $s/suppname
     return
        <item>
           {
           $p/description,
           $s/suppname,
           $i/price
           }
        </item>
   }
</descriptive-catalog>
%%%for $s in fn:doc("suppliers.xml")/suppliers/supplier
order by $s/suppname
return
   <supplier>
      { 
        $s/suppname,
        for $i in fn:doc("catalog.xml")/items/item
                 [suppno = $s/suppno],
            $p in fn:doc("parts.xml")/parts/part
                 [partno = $i/partno]
        order by $p/description
        return $p/description 
      }
   </supplier>
%%%<master-list>
 {
    for $s in fn:doc("suppliers.xml")/suppliers/supplier
    order by $s/suppname
    return
        <supplier>
           { 
             $s/suppname,
             for $i in fn:doc("catalog.xml")/items/item
                     [suppno = $s/suppno],
                 $p in fn:doc("parts.xml")/parts/part
                     [partno = $i/partno]
             order by $p/description
             return
                <part>
                   {
                     $p/description,
                     $i/price
                   }
                </part> 
           }
        </supplier> 
    ,
    (: parts that have no supplier :)
    <orphan-parts>
       { for $p in fn:doc("parts.xml")/parts/part
         where fn:empty(fn:doc("catalog.xml")/items/item
               [partno = $p/partno] )
         order by $p/description
         return $p/description 
       }
    </orphan-parts>
 }
</master-list>
%%%let $proc := /report/procedure[1]
for $i in $proc//action
where $i >> ($proc//incision)[1]
   and $i << ($proc//incision)[2]
return $i
%%%module namespace myfns = "http://www.example.com/function-library";
declare function local:precedes($a as node(), $b as node()) 
   as boolean
   {
      $a << $b
        and
      fn:empty($a//node() intersect $b) 
   };

%%%module namespace myfns = "http://www.example.com/function-library";
declare function local:follows($a as node(), $b as node()) 
   as boolean
   {
      $a >> $b
        and
      fn:empty($b//node() intersect $a) 
   };

%%%let $proc := /report/procedure[1]
for $i in $proc//instrument
where local:precedes(($proc//incision)[1], $i)
   and local:precedes($i, ($proc//incision)[2])
return $i
%%%for $proc in /report/procedure
where some $i in $proc//incision satisfies
         fn:empty($proc//anesthesia[. << $i])
return $proc
%%%let $intro := //h2[text()="Introduction"],
    $next-h := //(h1|h2)[. >> $intro][1]
return
   <div>
     {
       $intro,
       if (fn:empty($next-h))
         then //node()[. >> $intro]
         else //node()[. >> $intro and . << $next-h]
     }
   </div>
%%%module namespace myfns = "http://www.example.com/function-library";
declare function local:sections-and-titles($n as node()) as node()?
   {
   if (fn:local-name($n) = "section")
   then element
          { fn:local-name($n) }
          { for $c in $n/* return local:sections-and-titles($c) }
   else if (fn:local-name($n) = "title")
   then $n
   else ( )
   };
%%%local:sections-and-titles(fn:doc("cookbook.xml"))
%%%module namespace myfns = "http://www.example.com/function-library";
declare function local:swizzle($n as node()) as node() 
  { 
   typeswitch($n)
     case $a as attribute(color)
       return element color { fn:string($a) } 
     case $es as element(size) 
       return attribute size { fn:string($es) } 
     case $e as element() 
       return element 
         { fn:local-name($e) } 
         { for $c in 
             ($e/@* except $e/@color,     (: attr -> attr :)
              $e/size,                    (: elem -> attr :)
              $e/@color,                  (: attr -> elem :)
              $e/node() except $e/size )  (: elem -> elem :)
           return local:swizzle($c) }
     case $d as document-node() 
       return document 
         { for $c in $d/* return local:swizzle($c) } 
     default return $n 
  };
%%%local:swizzle(fn:doc("plans.xml"))
%%%for $p in fn:distinct-values(/orders/order/product),
    $s in fn:distinct-values(/orders/order/size),
    $c in fn:distinct-values(/orders/order/color)
    order by $p, $s, $c
    return
       if (fn:exists(/orders/order[product eq $p
                and size eq $s and color eq $c]))
       then
          <option>
             <product>{$p}</product>
             <size>{$s}</size>
             <color>{$c}</color>
          </option>
       else ()
%%%