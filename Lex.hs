module Lex where

import Data.Char

data Token = Tok_Open | Tok_Closed | Tok_Lambda | Tok_Abs | Tok_App | Tok_Var Char deriving (Show, Eq)

-- dry function up
tokenize :: String -> [Token]
tokenize [] = []
tokenize ('(':next) = Tok_Open : (tokenize next)
tokenize (')':next) = Tok_Closed : (tokenize next)
tokenize ('/':next) = Tok_Lambda : (tokenize next)
tokenize ('.':next) = Tok_Abs : (tokenize next)
tokenize ('*':next) = Tok_App : (tokenize next)
tokenize (c:next) = if isLetter c then (Tok_Var c) : (tokenize next) else tokenize next
