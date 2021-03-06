# FirstLambdaCalculusInterpreterInHaskell
This is the first successful lambda calculus interpreter I have written, and it was written in haskell.

# Motivation
I have been trying to write lambda calculus interpreters ever since I heard the concept but I always struggled with it and never got it working properly without loads of bugs but after reading through a thing on shift reduce parsing by mit I decided to give it an implementation (this was also the first time I had a proper look at a bottom up parser). After thinking about it for a while I thought that I could map the algorithm for shift reduce pretty much 1:1 on haskell's pattern matching and custom type system and so I decided to write it in haskell. After having written this I realise that this approach doesn't really work all that well but it was fun to do anyway. This motivation leads to this implementation being very bare, just because I wanted it to work and didn't want to risk any extra features just in case it didn't work.                               

# Usage
download all the files onto your local machine. Then compile Main.hs (I only tested compilation using ghc so it may not work on other compilers).                    
The input is read using the function getContents and then ran through the interpreter. to run a file through the interpreter in linux you can use the command $ cat \[file_name] | Main  . I haven't tested this but on windows you could probably do something like $ type \[file_name] | Main   but idk if it works.                  

# Syntax
variables are written as one character from the alphabet, uppercase or lowercase.                   
abstraction is written as follows: / Variable . Expression                  
Application has to be specified using a \*. ie: Expression \* Expression                  
Brackets () exist and work in much the same way as any other infix system.                       
There are no comments as I couldn't be bothered.                     

# important notes
abstraction has higher precedence then application in this interpreter so /a.a\*a will parse as (/a.a)\*a                              
there is an included program (test.lc) which is an example of adding two numbers together.                     
if there is an error in the syntax of the lambda calculus statement the program will crash with the error non-exhaustive patterns in function.                
if you accidentally run the program without giving it a file in stdin you can enter lambda calculus through the terminal but enter will not exit the function and you need to press CTRL+d to exit the program.                       
For ease of lexing variable names are only one character long, this could be fairly easily changed but tbh i can't be bothered rn.                     

# Compile to SKI
I have recently added the algorithm to convert a lambda calculus statement to ski calculus. I stole this algorithm from wikipedia from https://en.wikipedia.org/wiki/Combinatory_logic. To make use of this compile MainCompile.hs rather than Main.hs . After doing this ./MainCompile will be able to be used in much the same way as ./Main Except instead of a reduced lambda calculus output it will output a string of SKI. The output of this has not been tested but it matches the examples in wikipedia (though the output of this program has far more brackets due to lack of effort in the printing function). 
