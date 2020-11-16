(: FT semantic functions for syntax and type checking :)
module namespace myfns = "http://www.example.com/function-library";

(: simplified version not dealing with special match options :)
declare function fts:applyQueryTokensAsPhrase (
      $searchContext as item(),
      $matchOptions as element(fts:matchOptions),
      $queryTokens as element(fts:queryToken)*,
      $queryPos as xs:integer )
   as element(fts:allMatches)
{
   <fts:allMatches stokenNum="{$queryPos}"> 
   {
      for $tokenInfo in
         fts:matchTokenInfos( 
            $searchContext,
            $matchOptions,
            (),
            $queryTokens )
      return  
         <fts:match>  
            <fts:stringInclude queryPos="{$queryPos}" isContiguous="true"> 
            {$tokenInfo}
            </fts:stringInclude> 
         </fts:match>
   } 
   </fts:allMatches>
};

%%%
