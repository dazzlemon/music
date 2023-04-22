module Main (main) where

import System.IO.Utils (lineInteract)
import Data.List.Extra (sortOn)
import Text.EditDistance (levenshteinDistance, defaultEditCosts)
import Text.Regex.Posix ((=~))
import Data.Maybe (mapMaybe)
import GHC.Utils.Misc (last2)

pairs :: [a] -> [[a]]
pairs xs = [ [x, y] | (x, i) <- zip xs [0..]
                    , (y, j) <- zip xs [0..]
                    , i < j
                    ]

extractTitle :: String -> Maybe String
extractTitle line = case line =~ "^https://youtu.be/[A-Za-z0-9]+ (.+)$" of
  [[_, title]] -> Just title
  _            -> Nothing

main :: IO ()
main = lineInteract $ take 2000
                    . map unlines
                    . sortOn (uncurry (levenshteinDistance defaultEditCosts) . last2)
                    . pairs
                    . mapMaybe extractTitle
