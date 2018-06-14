-module(exchange).
-export([start/0]).
-export([printFile/1]).
-export([main/0]).
-export([createprocess/1]).
-export([process/0]).
-import(lists,[nth/2]).

start() ->
	exchange:main().	


%%Place the file in Current working directory, 
%%To find cwd : {ok, CurrentDirectory} = file:get_cwd() 
main() -> 
    {ok,Inputfile} = file:consult("calls.txt"),
	exchange:printFile(Inputfile).
    
%% Printing elements 
printFile(Inputfile) ->  		
		io:fwrite("~n** Calls to be made **~n"),
		lists:foreach(fun(Head)->
						io:format("~p: ~p~n",[element(1,Head),element(2,Head)]) 
					 end, Inputfile),
		io:format("~n"),
		exchange:createprocess(Inputfile).
	
createprocess(InputFile) ->	
	
	    Filelist= tuple_to_list(file:consult("calls.txt")),
		FileMap = maps:from_list(lists:nth(2, Filelist)),
		MapKeys = maps:keys(FileMap),
		MasterID = self(),
		lists:foreach(fun(ItemVal)->
						  register(ItemVal,spawn(calling,sendIntro,[ItemVal,maps:get(ItemVal, FileMap),MasterID]))
				          end , MapKeys),
		process(),
		io:format("\nMaster has received no replies for 1.5 seconds, ending...").
	

 process()->

	receive
		
        {intro,Source,Destination,Time} ->
            io:format("~p received intro message from ~p ~p~n",[Destination,Source,[Time]]),
			process();
        {reply,Source,Destination,Time} ->
            io:format("~p received reply message from ~p ~p~n",[Source,Destination,[Time]]),
            process()
	        after 4000->true
	        
    end.