-module(reader).
-export([word_count/2]).
-export([createScanner/3]).
-export([sendText/4]).
-import(lists,[append/2]).

word_count(FileName, N) ->
	Size = filelib:file_size(FileName),
	
	if
		(Size > 0) and (N > 0) ->
			{ok, File} = file:open(FileName, [read]),
			Counter = spawn(counter, receiveWord, [[]]),
			MyList = createScanner(N, Counter, []),
			Rows = sendText(MyList, MyList, File, 0),
			waitAllScanners([], Rows),
			notifyAll(MyList, Counter),
			io:format("The Reader has finished!~n");
	
		Size == 0 ->
			io:format("File is empty or inexisting!~n");
		(N == 0) or (N < 0) ->
			io:format("No enough processes created!~n")
	end.

createScanner(N, Counter, Registered) ->
	if N > 0 ->
		Nr = list_to_atom(integer_to_list(N)),
		register(Nr, spawn(fun scanner:receiveCounter/0)),
		N2 = N - 1,
		io:format("Created Scanner nr. ~p~n", [whereis(Nr)]),
		Nr ! Counter,
		createScanner(N2, Counter, lists:append(Registered, [Nr]));
	true ->
    		io:format("Scan processes success. created! ~n"),
		Registered
	end.	

sendText([H|T], Copy, File, RowsCount) ->
	
	Text = io:get_line(File, ''),

	if 
		(T == []) and (is_atom(Text) == false) ->
			TextMod = (Text -- "\n"),
			H ! {self(), TextMod},
			RowsCount2 = RowsCount + 1,
			sendText(Copy, Copy, File, RowsCount2);
		(T /= []) and (is_atom(Text) == false)  ->
			TextMod = (Text -- "\n"),
			H ! {self(), TextMod},
			RowsCount2 = RowsCount + 1,
			sendText(T, Copy, File, RowsCount2);
		true ->
			RowsCount
	end.

waitAllScanners(List, Length) ->
	receive
		Pid -> 
			List2 = List ++ [Pid],
			
			if
				length(List2) < Length ->
					waitAllScanners(List2, Length);
				true ->
					io:format("All Scanners are done! ~n")			end
		end.			
	
	
notifyAll([H|T], Counter) ->
	if
		T /= [] ->
			H ! "Finish",
			notifyAll(T, Counter);
		true ->
			H ! "Finish",
			Counter ! "Finish"
	end.	
	