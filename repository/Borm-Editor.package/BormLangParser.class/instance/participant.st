accessing
participant
	^ (participantType , space , nameExpression , space , ${ asParser , #newline asParser , nodes
		, #newline asParser optional , $} asParser)
		==> [ :arr | 
			{(#type -> arr first).
			(#name -> arr third).
			(#nodes -> arr seventh)} asDictionary ]