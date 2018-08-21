module Main where
import qualified System.Environment as SE
import qualified System.Directory as D
import qualified Data.ByteString.Lazy as BS
import qualified Data.ByteString.Lazy.Char8 as Char8
import qualified Control.Concurrent.Async as Async
import qualified Control.Concurrent as C
import qualified Control.Monad as M
import GHC.Conc
import Debug.Trace

newline = BS.head $ Char8.singleton '\n'

readAndCountNewlines :: FilePath -> IO Int
readAndCountNewlines s = fromIntegral <$> BS.count newline <$> BS.readFile s

readAndCountNewlinesWorker :: C.Chan Integer -> FilePath -> IO ()
readAndCountNewlinesWorker chan s = do
  t <- forkIO $ do
    traceEventIO "before read"
    int <- fromIntegral <$> BS.count newline <$> BS.readFile s 
    traceEventIO "after count"
    C.writeChan chan int
    traceEventIO "after write chan"
  labelThread t s
  return ()

main :: IO ()
main = do
  t <- myThreadId
  labelThread t "main"
  args <- SE.getArgs
  chan <- C.newChan
  let dir = head args
  absolutePath <- D.canonicalizePath dir
  files <- D.listDirectory dir
  let absolutePaths = fmap ((absolutePath <> "/") <>) files
  --counts <- Async.mapConcurrently readAndCountNewlines absolutePaths
  traverse (readAndCountNewlinesWorker chan) absolutePaths
  counts <- M.replicateM (length files) (C.readChan chan)
  print $ sum counts
