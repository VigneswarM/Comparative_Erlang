-module(calling).
-export([sendIntro/3]).
-export([handshake/3]).
-import(lists,[map/2]).
-export([manager/2]).
sendIntro(ItemVal,Data,MasterID)->
	
   map(fun(Destination)->
			   manager(ItemVal,Destination)
			   
			  end,Data),
   handshake(Data,ItemVal,MasterID),
   io:format("\nProcess ~p has received no calls for 1 second, ending...",[ItemVal]).
 


manager(Source,Destination) ->
		 
		{Time1,Time2,Time} = erlang:now(),
		ReceiverID = whereis(Destination),
		whereis(Destination)!{intro,Source,Destination,Time}.
		
	

handshake(Data,ItemVal,MasterID)->
	 receive
		{intro,Source,Destination,Time}->
			whereis(Source)! {reply,Source,Destination,Time},
			MasterID! {intro,Source,Destination,Time},
	        handshake(Data,ItemVal,MasterID);
       {reply,Source,Destination,Time}->
         MasterID! {reply,Source,Destination,Time},
		 handshake(Data,ItemVal,MasterID)
	     after 4000->true
		end.  
