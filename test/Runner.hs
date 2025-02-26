import Test.Tasty

import Task1Suite

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests"
  [ task1Tests
  ]
