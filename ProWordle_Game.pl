


is_category(C) :- word(_,C).

categories(T) :-  setof(C,is_category(C),T). 
                  
available_length(L):- word(X,_),
                      atom_length(X,L). 

pick_word(W,L,C):- word(W,C),
                   available_length(L).

removeDups([],X,X).				   
removeDups([H|T],Res,ACC) :-  \+ member(H,ACC), 
                              append(ACC,[H],NewACC),
							  removeDups(T,Res,NewACC).
							  
removeDups([H|T],Res,ACC) :-  member(H,ACC), 
							  removeDups(T,Res,ACC).							 


correct_letters(S1,S2,CL):- 
                            string_chars(S1,L1),
                            string_chars(S2,L2),
							intersection(L1,L2,Temp),
                            removeDups(Temp,CL,[]).

correct_positions(S1,S2,PL) :- 
                                string_chars(S1,L1),
                                string_chars(S2,L2),
                                correct_positionsHelper(L1,L2,PL).
								
correct_positionsHelper([],[],[]).                            
correct_positionsHelper([H1|T1],[H2|T2],PL):-
					H1=H2,
					PL = [H1|T3], 
					correct_positionsHelper(T1,T2,T3).

correct_positionsHelper([H1|T1],[H2|T2],PL):-
					H1\==H2, 
					correct_positionsHelper(T1,T2,PL).                        
														 
														 
build_kb :-
write('Please enter a word and its category on separate lines:'),nl,
read(W),
(
	W=done,nl,write('Done building the words database...'),nl;
	read(C),
		assert(word(W,C)),
		build_kb
).		
 
readCategory :-  write("Choose a Category :"),nl,
                 read(Category),
				 (
                     is_category(Category),
                     assert(input_category(Category));					 
					 \+ is_category(Category),
					 write("This category does not exist"),nl,
					 readCategory
				 ). 
readLength :- 
				write("Choose a length :"),nl,
				read(Length),
  				(
	                available_length(Length),
                    assert(input_length(Length));					
					\+ available_length(Length), 
					write("There are no words of this length."),nl,
					readLength
				).
				
readGuess(Length,Remaining,Target) :- 	
                write("Enter a word composed of "),write(Length),write(" letters:"),nl,
		        read(Guess),	
				atom_length(Guess,IL),
				(
				
                Guess == Target,
                write("You Won!");
				 
				Guess \== Target,
				Remaining =< 1,
				write("You lost!");
                				
				IL \== Length,
                write("Word is not composed of "),write(Length),write(" letters. Try again."),nl,	
                write("Remaining Guesses are "),write(Remaining),nl,				 
                readGuess(Length,Remaining,Target);  
				
				\+ word(Guess,_),
				write("this word is not in the Knowledge Base, please Enter another word"),nl,				
				write("Remaining Guesses are "),write(Remaining),nl,
				readGuess(Length,Remaining,Target);				
				
				correct_letters(Guess,Target,List1),
				correct_positions(Guess,Target,List2),
				write("Correct letters are: "),write(List1),nl, 
				write("Correct letters in correct positions are:"),write(List2),nl,
				RemainingDed is Remaining - 1,
				write("Remaining Guesses are "),write(RemainingDed),nl,nl,
				readGuess(Length,RemainingDed,Target)												
				),nl.
                
								
play :- write("The available categories are: "),categories(T),
        write(T),nl,
		readCategory,input_category(Category),
		readLength,input_length(Length),
		L_inc is Length + 1,
		write("Game started. You have "),write(L_inc),write(" guesses."),nl,nl,
		pick_word(Target,Length,Category),
		readGuess(Length,L_inc,Target).
		
main :- write("Welcome to Pro-Wordle!"),nl,nl,
        build_kb,nl,
        play.		
		
		
       
        
		
		
		
		
		

		
		 
















