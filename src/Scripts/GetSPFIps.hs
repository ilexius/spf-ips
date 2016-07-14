module Scripts.GetSPFIps (getSpfIps) where

import Data.ByteString.Char8 (pack)
import Data.Char (ord)
import qualified Pipes.ByteString as PBS
import Options.Applicative
import Pipes

import Network.SPF

scriptParser = strArgument (metavar "DOMAIN" <> help "The domain to query")
scriptInfo = info scriptParser help
  where help = fullDesc <> progDesc desc
        desc = unwords [ "Recursively queries the spf entries of DOMAIN."
                       , "First the TXT entry of DOMAIN is queried."
                       , "All 'ip4' entries are printed to stdout."
                       , "After that all 'include' entries are queried."
                       ]

intersperseNl = do l <- await
                   yield l
                   yield newline
                   intersperseNl
  where newline = pack "\n"

getSpfIps :: IO ()
getSpfIps = do domain <- pack <$> execParser scriptInfo
               runEffect (produceSpfIps domain >-> intersperseNl >-> PBS.stdout)
  where space = (fromIntegral . ord) ' '
