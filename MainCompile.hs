import Lex
import Parse
import Compile

str_to_ans = compile . ((flip parse) []) . tokenize

main = do
	contents <- getContents
	putStrLn $ Compile.show $ str_to_ans contents
