import Lex
import Parse
import Run

expr_to_str :: Expr -> [Char]
expr_to_str (Var c) = [c]
expr_to_str (Abs c e) = '/':c:'.':'(':(expr_to_str e) ++ ")"
expr_to_str (App e1 e2) = (expr_to_str e1) ++ "*" ++ (expr_to_str e2)

str_to_ans = run . ((flip parse) []) . tokenize

main = do
	contents <- getContents
	print $ (expr_to_str . str_to_ans) contents
