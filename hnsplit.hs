{-# LANGUAGE OverloadedStrings #-}
import Prelude hiding (readFile, writeFile, lines, unlines, splitAt, takeWhile, dropWhile)
import System.Environment (getArgs, getProgName)
import System.Exit (exitFailure)
import System.FilePath (replaceBaseName, takeBaseName)
import Data.Char (isDigit)
import Data.Text hiding (map, head, length, take, drop)
import qualified Data.Text as T (drop, length)
import Data.Text.IO (readFile, writeFile)

separator :: Text
separator = ";"

main :: IO ()
main = do
    args <- getArgs
    prog <- getProgName
    case args of
      ["0", _] -> showUsage prog
      [i, fn]  -> runProgram (read i) fn
      _        -> showUsage prog

runProgram :: Int -> FilePath -> IO ()
runProgram i fn = do
    contents <- readFile fn
    writeFile newName $ unlines $ processLines (i - 1) $ lines contents
  where newName = replaceBaseName fn (takeBaseName fn ++ "-hnsplit")

processLines :: Int -> [Text] -> [Text]
processLines i ls  = header : rows
  where header     = splitColumn colNames i $ head ls
        rows       = map (splitColumn splitHn i) (tail' ls)
        colNames _ = ["HouseNumber", "HouseNumberExtension"]

splitColumn :: (Text -> [Text]) -> Int -> Text -> Text
splitColumn f i ln
    | i - 1 > length cols = ln
    | otherwise           = intercalate separator newCols
  where cols     = splitOn separator ln
        newCols  = replaceAt (f $ cols !! i) i cols

replaceAt :: [a] -> Int -> [a] -> [a]
replaceAt xs i ys = prev ++ xs ++ next
  where prev = take i ys
        next = drop (i + 1) ys

splitHn :: Text -> [Text]
splitHn s     = [hn, toLower ext]
  where hn    = takeWhile isDigit s
        ext   = dropWhile (`elem` chars) $ T.drop (T.length hn) s
        chars = ".\\/- \t_"

tail' :: [a] -> [a]
tail' (_:cs) = cs
tail' _      = []

showUsage :: String -> IO ()
showUsage name = do
  putStrLn $ "Usage: " ++ name ++ " [column index] [filename]"
  putStrLn "       Column count starts at 1."
  exitFailure

