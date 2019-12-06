module Lib
    (
      order,
      buildEdges,
      createGraph,
      addEdge,
      findDependencies,
      findTasksOrder
    ) where

import Data.List
import Data.Tuple

type Edge a = (a, a)
data Graph a = Graph [Edge a] deriving Show

createGraph :: [Edge a] -> Graph a
createGraph l = Graph l

addEdge :: Graph a -> a -> a -> Graph a
addEdge g a b = case g of (Graph l) -> (Graph ((a, b) : l))

buildEdges :: [a] -> [Edge a]
buildEdges l = zip l (drop 1 l)

eqDependent :: Eq a => a -> (a, a) -> Bool
eqDependent a edge = a == (snd edge)

eqDependency :: Eq a => a -> (a, a) -> Bool
eqDependency a edge = a == (fst edge)

-- Given the graph, find all dependencies for the task
findDependencies :: Eq a => a -> Graph a -> [a]
findDependencies a g = case g of (Graph l) -> map fst (filter (eqDependent a) l)

-- Utility function to determine if the elements of the first list are contained in the second
isContained :: Eq a => [a] -> [a] -> Bool
isContained l1 l2 = length (intersect l1 l2) == length l1

areDependenciesDone :: Eq a => [a] -> Graph a -> a -> Bool
areDependenciesDone done g a =
    let dependencies = findDependencies a g in
        isContained dependencies done


findTasksOrderHelper :: Eq a => [a] -> [a] -> Graph a -> [a]
findTasksOrderHelper todo done g =
        case todo of [] -> done
                     (hd:_) -> let next = find (areDependenciesDone done g) todo in
                         case next of Just a -> findTasksOrderHelper (delete a todo) (done++[a]) g
                                      Nothing -> error "Impossible to find next step (maybe there is a cycle in the graph?)"

findTasksOrder :: Eq a => [a] -> Graph a -> [a]
findTasksOrder todo g = findTasksOrderHelper todo [] g

-- Make all the precedency constraints as edges in the graph
makeAllEdges :: [[a]] -> [Edge a]
makeAllEdges elems = concat (map buildEdges elems)

readArray :: IO [[String]]
readArray = readLn

-- Simple utility function to get all different tasks from input
allTasks :: [[String]] -> [String]
allTasks l = nub (concat l)

-- Schedule a list of tasks with precedency constraints.
-- The list of tasks is given as a List of List of strings
-- In the inner array, each string consecutive to another represents a precedence constraint
-- eg: [["1", "2", "3"] ...] means "2" comes after "1" (first constraint) and "3" comes after "2" (second constraint)
-- inspired by http://pages.cs.wisc.edu/~jolly/talks/jolly_scheduling_wisc.pdf

order :: IO()
order = do
    tasks <- readArray
    let scheduledTasks = findTasksOrder (allTasks tasks) (Graph (makeAllEdges tasks)) in
        putStrLn (show scheduledTasks)

