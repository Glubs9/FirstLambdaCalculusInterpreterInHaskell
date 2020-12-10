module Parse where

import Lex
import Debug.Trace (trace)

print_and_return :: Show n => n -> n
print_and_return n = trace (show (n)) n

-- might have to change abs char expr to abs var expr but it doesn't really work?
-- might be able to have it as a monad or something like that
-- though we would define it in run
data Expr = Abs Char Expr | App Expr Expr | Var Char | Open | Closed | Dot | Lambda | Star deriving (Show, Eq)

-- really should dry this
-- like literally have 9 things
-- really really bad code but what are you gonna do
-- parse tokens stack -> ast
parse :: [Token] -> [Expr] -> Expr
parse arr ((e@(Abs ac ae)):Dot:(Var c):Lambda:next)	    = parse arr ((Abs c e):next)
parse arr ((e@(App ac ae)):Dot:(Var c):Lambda:next)	    = parse arr ((Abs c e):next)
parse arr ((e@(Var ac)):Dot:(Var c):Lambda:next)	    = parse arr ((Abs c e):next)
parse arr (e2@(Var a2):Star:e1@(Var a1):next)		    = parse arr ((App e1 e2):next)
parse arr (e2@(Var a2):Star:e1@(Abs a1c a1e):next)	    = parse arr ((App e1 e2):next)
parse arr (e2@(Var a2):Star:e1@(App a1e1 a1e2):next)	    = parse arr ((App e1 e2):next)
parse arr (e2@(Abs a2c a2e):Star:e1@(Var a1):next)	    = parse arr ((App e1 e2):next)
parse arr (e2@(Abs a2c a2e):Star:e1@(Abs a1c a1e):next)     = parse arr ((App e1 e2):next)
parse arr (e2@(Abs a2c a2e):Star:e1@(App a1e1 a1e2):next)   = parse arr ((App e1 e2):next)
parse arr (e2@(App a2e1 a2e2):Star:e1@(Var a1):next)        = parse arr ((App e1 e2):next)
parse arr (e2@(App a2e1 a2e2):Star:e1@(Abs a1c a1e):next)   = parse arr ((App e1 e2):next)
parse arr (e2@(App a2e1 a2e2):Star:e1@(App a1e1 a1e2):next) = parse arr ((App e1 e2):next)
parse arr (Closed:e:Open:next)				    = parse arr (e:next)
parse [] [n]						    = n
parse (Tok_Open:next) stack				    = parse next (Open:stack)
parse (Tok_Closed:next) stack				    = parse next (Closed:stack)
parse (Tok_Lambda:next) stack				    = parse next (Lambda:stack)
parse (Tok_Abs:next) stack				    = parse next (Dot:stack)
parse (Tok_App:next) stack				    = parse next (Star:stack)
parse ((Tok_Var c):next) stack				    = parse next ((Var c):stack)
-- parse tokens stack
