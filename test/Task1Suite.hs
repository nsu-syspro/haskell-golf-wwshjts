module Task1Suite where

import Test.Tasty
import Test.Tasty.QuickCheck

import Task1


task1Tests :: TestTree
task1Tests = testGroup "Task1"
  [ testProperty "decode . encode = id" $ withMaxSuccess 1000 $
      \xs -> decode (encode (xs :: [Int])) === xs

  , testProperty "encode . decode = id" $ withMaxSuccess 1000 $
      \(Encoded xs) -> encode (decode (xs :: [(Int, Int)])) === xs

  , testProperty "rotate left" $ withMaxSuccess 1000 $
      \(Blind over, Blind l, Blind r) -> 
        let n  = over * length xs + length (l :: [Int])
            xs = l ++ r
            expected = r ++ l
        in counterexample ("unexpected result of rotate " ++ show n ++ " " ++ show xs) $
            rotate n xs === expected

  , testProperty "rotate right" $ withMaxSuccess 1000 $
      \(Blind over, Blind l, Blind r) ->
        let n  = over * length xs - length (l :: [Int])
            xs = r ++ l
            expected = l ++ r
        in counterexample ("unexpected result of rotate " ++ show n ++ " " ++ show xs) $
            rotate n xs === expected
  ]

valid :: Eq a => [(Int, a)] -> Bool
valid xs = all ((> 0) . fst) xs && distinctValues xs

distinctValues :: Eq a => [(Int, a)] -> Bool
distinctValues [ ] = True
distinctValues [_] = True
distinctValues (x : y : xs) = snd x /= snd y && distinctValues (y : xs)

newtype Encoded a = Encoded [(Int, a)]
  deriving (Eq)

instance Show a => Show (Encoded a) where
  show (Encoded xs) = show xs

instance (Eq a, Arbitrary a) => Arbitrary (Encoded a) where
  arbitrary = Encoded <$> suchThat arbitrary valid
  shrink (Encoded xs) = map Encoded $ filter valid $ shrink xs

