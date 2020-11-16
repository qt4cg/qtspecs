(: parse tests :)

let $uid := doc("users.xml")/users/user_tuple[name = "Roger Smith"]/userid
let $topbid := max(doc("bids.xml")/bids/bid_tuple[itemno = 1002]/bid)
let $newbid := $topbid * 1.1
return (
  insert nodes
    <bid_tuple> 
      <userid>{ data($uid) }</userid> 
      <itemno>1002</itemno> 
      <bid>{ $newbid }</bid> 
      <bid_date>1999-03-03</bid_date> 
    </bid_tuple>
  into doc("bids.xml")/bids,
  <new_bid>{ $newbid }</new_bid>
)


%%%
let $uid := doc("users.xml")/users/user_tuple[name = "Roger Smith"]/userid
let $topbid := max(doc("bids.xml")/bids/bid_tuple[itemno = 1007]/bid)
let $newbid := $topbid * 1.1
return
  if($newbid <= 240) then (
    insert nodes
      <bid_tuple>
        <userid>{ data($uid) }</userid>
        <itemno>1002</itemno>
        <bid>{ $newbid }</bid>
        <bid_date>1999-03-03</bid_date>
      </bid_tuple>
    into doc("bids.xml")/bids,
    <new_bid>{ $newbid }</new_bid>
  ) else (
    <top_bid>{ $topbid }</top_bid>
  )


%%%
let $user := doc("users.xml")/users/user_tuple[name = "Dee Linquent"]
let $items := doc("items.xml")/items/item_tuple[offered_by = $user/userid]
let $bids := doc("bids.xml")/bids/bid_tuple[userid = $user/userid]
return (
  delete nodes ($user, $items, $bids),
  <deleted>
    <items>{ count($items) }</items>
    <bids>{ count($bids) }</bids>
  </deleted>
)

%%%
declare variable $uid := doc("users.xml")/users/user_tuple
  [name = "Roger Smith"]/userid;
declare variable $item := doc("items.xml")/items/item_tuple
  [description = "Helicopter"];
declare assignable variable $result :=
  "Error: The auction has already ended or no bids were placed";
declare assignable variable $maximumExceeded := false();

while(xs:date($item/end_date) >= fn:current-date() and not($maximumExceeded)) {
  let $bids := doc("bids.xml")/bids/bid_tuple[itemno = $item/itemno]
  let $topbid := max($bids/bid)
  let $newbid := $topbid + 1
  where $bids[bid = $topbid]/userid != $uid
  return
    if($newbid <= 60000) then (
      insert nodes
        <bid_tuple>
          { $uid, $item/itemno }
          <bid>{ $newbid }</bid> 
          <bid_date>{ fn:current-date() }</bid_date> 
        </bid_tuple>
      into doc("bids.xml")/bids;
      $result := concat("What a bargain! You got a helicopter for ",
        $newbid);
    ) else (
      $result := "Bidding exceeded 60000";
      $maximumExceeded := true();
    )
};

$result;

%%%
declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace book="http://www.example.com/booksearch";

declare simple function book:search($name as xs:string) as element(book)* external;
declare simple function book:get($isbn as xs:string) as element(bookinfo) external;

declare variable $eventNode as element() external;
declare assignable variable $searchResults := ();

insert node <xhtml:div>Loading Book</xhtml:div>
after /xhtml:html/xhtml:body/xhtml:form;

$searchResults :=
  book:search($eventNode/preceding-sibling::xhtml:input[1]);

if($searchResults) then (
  replace node /xhtml:html/xhtml:body/xhtml:div
  with <xhtml:div>{
    book:get($searchResults[1]/isbn)/html/node()
  }</xhtml:div>;
)
else (
  replace node /xhtml:html/xhtml:body/xhtml:div
  with <xhtml:div>No books found!</xhtml:div>;
);

%%%
declare namespace xhtml="http://www.w3.org/1999/xhtml";
declare namespace book="http://www.example.com/booksearch";
declare namespace library="http://www.example.com/library";

declare simple function book:search($name as xs:string)
  as element(book)* external;
declare simple function library:find($isbn as xs:string)
  as element(library)* external;

declare variable $eventNode as element() external;
declare assignable variable $table := ();

insert node <xhtml:div><xhtml:table/></xhtml:div>
after /xhtml:html/xhtml:body/xhtml:form;
$table := //xhtml:table;

for $book in book:search($eventNode/preceding-sibling::xhtml:input[1])
return (
  insert node
    <xhtml:tr>
      <xhtml:td>{data($book/title)}</xhtml:td>
      <xhtml:td>{data($book/isbn)}</xhtml:td>
      <xhtml:td/>
    </xhtml:tr>
  as last into $table;
);

for $row in $table/xhtml:tr
return (
  replace value of node $row/xhtml:td[3]
  with string-join(library:find($row/xhtml:td[2])/name, ", ");
);

%%%
declare variable $request as element(request) external;

declare simple function local:error($message)
{
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Error</title>
    </head>
    <body>
      <h1>Error</h1>
      <p>{ $message }</p>
    </body>
  </html>
};

if($request/method = "POST") then () else
  exit returning local:error(concat("You cannot use the ",
    $request/method, " method with this URL."));

let $user := replace($request/url, "^http://.*/([^/]+)/add$", "$1")
let $blog := collection()/micro-blog[@user = $user]
return (
  if($blog) then () else
    exit returning local:error("Unknown user");

  insert node
    <entry timestamp="{ current-dateTime() }">
      <text>{ $request/param[@name = "text"] }</text>
    </entry>
  as last into $blog;

  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Blog entry added for { $user }</title>
    </head>
    <body>
      <h1>Blog entry added for { $user }</h1>
      <p>{ $request/param[@name = "text"] }</p>
    </body>
  </html>;
);

%%%
declare variable $request as element(request) external;

declare sequential function local:check-user-and-log($username as xs:string) 
  as element(micro-blog)?
{
  declare $entry as element() :=
    <access-attempt>
      <timestamp>{fn:current-dateTime()}</timestamp>
      <user-name>{$username}</user-name>
      <access-allowed/>
    </access-attempt>;
  declare $blog as element(micro-blog)? :=
    collection()/micro-blog[@user = $username];

  if($blog) then
    replace value of node $entry/access-allowed with "Yes"
  else
    replace value of node $entry/access-allowed with "No";

  insert node $entry as last into collection()/log;

  $blog;
}; 


declare simple function local:error($message)
{
  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Error</title>
    </head>
    <body>
      <h1>Error</h1>
      <p>{ $message }</p>
    </body>
  </html>
};

if($request/method = "POST") then () else
  exit returning local:error(concat("You cannot use the ",
    $request/method, " method with this URL."));

let $user := replace($request/url, "^http://.*/([^/]+)/add$", "$1")
let $blog := local:check-user-and-log($user)
return (
  if($blog) then () else
    exit returning local:error("Unknown user");

  insert node
    <entry timestamp="{ current-dateTime() }">
      <text>{ $request/param[@name = "text"] }</text>
    </entry>
  as last into $blog;

  <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
      <title>Blog entry added for { $user }</title>
    </head>
    <body>
      <h1>Blog entry added for { $user }</h1>
      <p>{ $request/param[@name = "text"] }</p>
    </body>
  </html>;
);

%%%