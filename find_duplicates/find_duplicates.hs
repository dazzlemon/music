import Data.List (isPrefixOf)

main :: IO ()
main = getContents
     >>= putStrLn
       . unlines
       . filter (isPrefixOf "https")
       . lines
