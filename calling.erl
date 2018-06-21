-module(calling).
-export([sendIntro/3]).
-export([handshake/3]).
-import(lists,[map/2]).
-export([manager/2]).





sendIntro(ItemVal,Data,MasterID)->
			   map(fun(Destination)->
				   timer:sleep(rand:uniform(100)),
			   	   manager(ItemVal,Destination)	
			  end,Data),
   			  handshake(Data,ItemVal,MasterID),
   			  io:format("\nProcess ~p has received no calls for 1 second, ending...\n",[ItemVal]).
 
	

manager(Source,Destination) ->
		{Time1,Time2,Time} = erlang:now(),
		%%io:format("\n~p ~p",[Time1,Time2]),
		%%ReceiverID = whereis(Destination),
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
	     after 1000->true
		end.  
