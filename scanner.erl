-module(scanner).
-export([receiveCounter/0]).

receiveCounter() ->
	receive
		Counter -> receiveLine(Counter)
	end.
	
receiveLine(Counter) ->
	receive
		"Finish" -> 
			io:format("Scanner ~p killed! ~n", [self()]);
		{Pid, Text} ->
			io:format("Scanner: ~p received Text: ~p~n", [self(), Text]),
			List = string:split(Text, " ", all),
			sendWords(List, Counter),
			Pid ! self(),
			receiveLine(Counter)
		end.

sendWords([H|T], Counter) ->
	if 
		T /= [] ->
			Counter  ! H,
			sendWords(T, Counter);
		true ->
			Counter ! H
	end.
			
	