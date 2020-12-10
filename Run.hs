module Run where

import Parse

replace :: Char -> Expr -> Expr -> Expr
replace test replace_expr edit_expr
	| (Var c) <- edit_expr = if test == c then replace_expr else edit_expr
	| (App e1 e2) <- edit_expr = (App (f e1) (f e2))
	| (Abs c e) <- edit_expr = if test == c then edit_expr else (Abs c (f e))
	where f = replace test replace_expr

-- if application (abstraction) e then replace else just recurse
-- something is wrong here
beta_recurse :: Expr -> Expr
beta_recurse (Var c) = (Var c)
beta_recurse (Abs c e) = (Abs c (beta_recurse e))
beta_recurse (App e1@(Abs ac ae) e2) = beta_recurse $ replace ac e2 ae
beta_recurse (App e1 e2) = (App (beta_recurse e1) (beta_recurse e2))

run' :: Expr -> Expr -> Expr
run' expr_before expr_after
	| expr_before == expr_after = expr_after
	| otherwise = run' expr_after (beta_recurse expr_after)

run :: Expr -> Expr
run e = run' e (beta_recurse e)
