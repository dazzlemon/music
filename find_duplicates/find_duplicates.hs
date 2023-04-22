import Data.List (isPrefixOf)
import Control.Monad (guard)

pairs :: [a] -> [(a, a)]
pairs xs = do
  (x, i) <- zip xs [0..]
  (y, j) <- zip xs [0..]
  guard (i < j)
  return (x, y)

main :: IO ()
main = getContents
     >>= putStrLn
       . unlines
       . map (\(x, y) -> x ++ "\n" ++ y ++ "\n\n")
       . pairs
       . map (drop 29)
       . filter ("https://youtu.be/" `isPrefixOf`)
       . lines
