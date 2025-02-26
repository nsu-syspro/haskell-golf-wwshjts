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
preserved (TypeSig {}) = False -- ignore type signatures
preserved _ = True
