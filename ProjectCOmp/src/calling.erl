%% @author Vigneswar Mourouguessin 40057918
%% @doc @todo Add description to calling.
-module(calling).
-export([]).
-export([sendIntro/1]).

sendIntro(Data) ->
		ProcessID = self().
		%%,io:format("~p :~p~n",[ProcessID,Data]).