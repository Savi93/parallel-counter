-module(counter).
-export([receiveWord/1]).
-export([incrementCount/3]).
-import(lists, [member/2]).

receiveWord(Words) ->
	receive 
		"Finish" ->
			countOcc(Words, [], []);
		Word -> 
			List = Words ++ [Word],							receiveWord(List)
	end.

countOcc([H|T], StillInserted, Count) ->
	case lists:member(H, StillInserted) of
		true ->
			Pos = string:str(StillInserted, [H]),
			Count2 = incrementCount(Count, [], Pos),
			
			case T /= [] of
			true ->
				countOcc(T, StillInserted, Count2);
			false ->
				printResult(StillInserted, Count2)
			end;

		false ->
			StillInserted2 = StillInserted ++ [H],
			Count2 = Count ++ [1],

			case T /= [] of
			true ->	
				countOcc(T, StillInserted2, Count2);

			false ->
				printResult(StillInserted2, Count2)
			end
	end.

incrementCount([H|T], NewList, Pos) ->
	if 
		Pos > 1 ->
			NewList2 = NewList ++ [H],
			Pos2 = Pos - 1,
			incrementCount(T, NewList2, Pos2);
		(Pos == 1) and (T /= []) ->
			Hincr = H + 1,
			NewList2 = NewList ++ [Hincr],
			Pos2 = Pos - 1,
			incrementCount(T, NewList2, Pos2);
		(Pos == 1) and (T == []) ->
			Hincr = H + 1,
			NewList2 = NewList ++ [Hincr],
			NewList2;
		(Pos < 1) and (T /= []) ->
			NewList2 = NewList ++ [H],
			incrementCount(T, NewList2, Pos);
		(Pos < 1) and (T == []) ->
			NewList2 = NewList ++ [H],
			NewList2
	end.

printResult([HWords|TWords], [HCount|TCount]) ->
	if 
	TWords /= [] ->
	io:format("Word: ~p ~p occurences~n", [HWords, HCount]),
	printResult(TWords, TCount);

	true ->
	io:format("Word: ~p ~p occurences~n", [HWords, HCount])
	end.
	
			
					
	