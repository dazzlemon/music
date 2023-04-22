module Main (main) where

import System.IO.Utils (lineInteract)
import Data.List (isPrefixOf)
import Control.Monad (guard)
import Data.List.Extra (sortOn)
import Text.EditDistance (levenshteinDistance, defaultEditCosts)

pairs :: [a] -> [(a, a)]
pairs xs = do
  (x, i) <- zip xs [0..]
  (y, j) <- zip xs [0..]
  guard (i < j)
  return (x, y)

main :: IO ()
main = lineInteract $ take 2000
                    . map (\(x, y) -> x ++ "\n" ++ y ++ "\n\n")
                    . sortOn (uncurry $ levenshteinDistance defaultEditCosts)
                    . pairs
                    . map (drop 29)
                    . filter ("https://youtu.be/" `isPrefixOf`)
