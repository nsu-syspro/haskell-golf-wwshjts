import Language.Haskell.Exts
import Data.Char (isSpace)

main :: IO ()
main = print =<< countFile "src/Task1.hs"

-- | Count number of characters in file ignoring:
-- - whitespaces
-- - imports
-- - module declarations
-- - pragmas
--
countFile :: String -> IO Int
countFile file = do
  ParseOk (Module _ _ _ _ decls) <- parseFile file
  pure $ sum $ map (numNonSpaces . prettyPrint) $ filter preserved decls

numNonSpaces :: String -> Int
numNonSpaces = length . filter (not . isSpace)

preserved :: Decl a -> Bool
preserved decl = case decl of 
  -- ignore type signatures
  TypeSig {} -> False
  -- ignore all pragma declarations
  RulePragmaDecl {} -> False
  DeprPragmaDecl {} -> False
  WarnPragmaDecl {} -> False
  InlineSig {} -> False
  InlineConlikeSig {} -> False
  SpecSig {} -> False
  SpecInlineSig {} -> False
  InstSig {} -> False
  AnnPragma {} -> False
  MinimalPragma {} -> False
  RoleAnnotDecl {} -> False
  CompletePragma {} -> False
  -- preserve everything else
  _ -> True
