import Language.Haskell.Exts
import Data.Char (isSpace)

-- | Count number of characters in file ignoring:
-- - whitespaces
-- - imports
-- - module declarations
-- - pragmas
--
main :: IO ()
main = do
  ParseOk (Module _ _ _ _ decls) <- parseFile "src/Task1.hs"
  print $ sum $ map (numNonSpaces . prettyPrint) $ filter preserved decls

numNonSpaces :: String -> Int
numNonSpaces = length . filter (not . isSpace)

preserved :: Decl a -> Bool
preserved (TypeSig {}) = False -- ignore type signatures
preserved _ = True
