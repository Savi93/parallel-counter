# Parallel word counter

The goal of the homework is to realize a concurrent Erlang program to count the number of occurrences of words in a ﬁle. The program consists of three types of processes: 
1. One reader: it reads the ﬁle line by line, and dispatches each line to one of the multiply available scanners; in addition, it is the main orchestrator of the entire program, that is, it spawns the other processes and coordinates their termination. 
2. Many scanners: each scanner receives lines of text; for each received line, the scanner decomposes the line into words, and sends each word to the counter. 
3. One counter: it receives words from the various scanners, and keeps track of the overall occurrences of such words into a dedicated map; ﬁnally, upon completion it prints the content of such a map. 

e.g. 
The result printed by the counter should have the following form:
"bus": 96 occurrences "car": 72 occurrences "plane": 23 occurrences "thisistheend": 1 occurrences "train": 48 occurrences


### Technologies used: Erlang
