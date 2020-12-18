module Compile where

{-
this file encodes the below algorithm (from wikipedia on combinatory logic) into haskell

T[ ] may be defined as follows:
1. T[x] => x
2. T[(E₁ E₂)] => (T[E₁] T[E₂])
3. T[λx.E] => (K T[E]) (if x does not occur free in E)
4. T[λx.x] => I
5. T[λx.λy.E] => T[λx.T[λy.E]] (if x occurs free in E) (I am struggling to think of a way to implement this because of the type mismatch. I did solve it but it made my code pretty bad)
6. T[λx.(E₁ E₂)] => (S T[λx.E₁] T[λx.E₂]) (if x occurs free in E₁ or E₂)
-}

import Parse
import Debug.Trace

-- thinking about it now I have misused data types a bit here and should have used dataclasses
-- instead but it's too late now lol
-- also TmpVar and TmpAbs is not ski but it's needed for the compilation
-- also TmpAbs is only needed because of rule 5 and that rule makes my code so much worse because of the inclusion of TmpAbs
data SKI = S | K | I | TmpVar Char | SKIApp SKI SKI | TmpAbs Char SKI deriving (Show, Eq)

show :: SKI -> String
show (SKIApp e1 e2) = "(" ++ (Compile.show e1) ++ " " ++ (Compile.show e2) ++ ")"
show e = Prelude.show e

-- not tested but it should work right???
free :: Char -> SKI -> Bool
free c1 (TmpVar c2) = c1 == c2
free c (SKIApp e1 e2) = (free c e1) || (free c e2) 
free c1 (TmpAbs c2 e) = if c1 == c2 then False else (free c1 e)
free c e = False --could match with s k or i
-- error for all others
-- non exhaustive patterns in function defintion

is_abs :: SKI -> Bool
is_abs (TmpAbs _ _) = True 
is_abs e = False

expr_from_abs (TmpAbs _ e) = e

k_match (TmpAbs c e) = not $ free c e

i_match (TmpAbs c1 (TmpVar c2)) = c1 == c2
i_match e = False

five_match (TmpAbs c1 (TmpAbs c2 e)) = ((not (c1 == c2)) && (free c1 e))
five_match e = False

five_reduce (TmpAbs c1 (TmpAbs c2 e)) = t (TmpAbs c1 (t (TmpAbs c2 e)))

s_match (TmpAbs c (SKIApp e1 e2)) = (free c e1) || (free c e2)
s_match e = False

s_reduce (TmpAbs c (SKIApp e1 e2)) = (SKIApp (SKIApp S (t (TmpAbs c e1))) (t (TmpAbs c e2)))

t :: SKI -> SKI
t inp_expr
	| (TmpVar c) <- inp_expr = (TmpVar c)
	| (SKIApp e1 e2) <- inp_expr = (SKIApp (t e1) (t e2))
	| (is_abs inp_expr) && (k_match inp_expr) = (SKIApp K (t $ expr_from_abs inp_expr))
	| (is_abs inp_expr) && (i_match inp_expr) = I
	| (is_abs inp_expr) && (five_match inp_expr) = five_reduce inp_expr
	| (is_abs inp_expr) && (s_match inp_expr) = s_reduce inp_expr
	| otherwise = inp_expr -- idk what might be matching here

convert :: Expr -> SKI
convert (Var c) = (TmpVar c)
convert (App e1 e2) = (SKIApp (convert e1) (convert e2))
convert (Abs c e) = (TmpAbs c (convert e))

compile = t . convert
