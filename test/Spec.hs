import Test.Tasty
import Test.Tasty.HUnit

import Lib

main :: IO ()
main = do
  defaultMain (testGroup "Task Scheduling Tests" [test1, test2, test3, test4])

test1 :: TestTree
test1 = testCase "Test building edges"
  (assertEqual "test 1" [("executor", "processor"), ("processor", "listener")] $ buildEdges ["executor", "processor", "listener"])

test2 :: TestTree
test2 = testCase "Test finding dependencies in graph"
  (assertEqual "test 2" ["processor"] $ findDependencies "listener" (createGraph [("executor", "processor"), ("processor", "listener")]))

test3 :: TestTree
test3 = testCase "Test finding right order for task execution"
  (assertEqual "test 3" ["executor", "processor", "listener"] $ findTasksOrder ["listener", "processor", "executor"] (createGraph [("executor", "processor"), ("processor", "listener")]))

test4 :: TestTree
test4 = testCase "Test double dependency"
  (assertEqual "test 5" [1, 2, 3, 4, 5, 6] $ findTasksOrder [1, 2, 3, 4, 5, 6] (createGraph [(1, 3), (2, 3), (3, 4), (4, 5), (4, 6)]))
