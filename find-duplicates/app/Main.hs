module Main (main) where

import System.IO.Utils (lineInteract)
import Data.List (isPrefixOf)
import Control.Monad (guard)
import Data.List.Extra (sortOn)
import Text.EditDistance (levenshteinDistance, defaultEditCosts)

pairs :: [a] -> [(a, a)]
pairs xs = [ (x, y) | (x, i) <- zip xs [0..]
                    , (y, j) <- zip xs [0..]
                    , i < j
                    ]


main :: IO ()
main = lineInteract $ take 2000
                    . map (unlines . (\(x, y) -> [x, y]))
                    . sortOn (uncurry $ levenshteinDistance defaultEditCosts)
                    . pairs
                    . map (drop 29)
                    . filter ("https://youtu.be/" `isPrefixOf`)
