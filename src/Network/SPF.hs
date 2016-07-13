module Network.SPF where

import Control.Lens (view)
import Control.Monad.IO.Class
import qualified Data.ByteString as BS
import Data.ByteString.Char8 (pack)
import Data.Either (lefts)
import Data.Either.Utils (forceEither)
import Data.Maybe (catMaybes)
import Network.DNS
import Pipes

import Data.SPF
import Parser.SPF

withDefaultResolver :: MonadIO m => (Resolver -> IO b) -> m b
withDefaultResolver f = do seed <- (liftIO . makeResolvSeed) defaultResolvConf
                           (liftIO . withResolver seed) f

lookupSpf1 :: Domain -> Resolver -> IO (Either DNSError [BS.ByteString])
lookupSpf1 domain resolver = fmap filterSpf1 <$> lookupTXT resolver domain
  where filterSpf1 = filter (spf1Start `BS.isPrefixOf`)


produceSpfIps :: MonadIO m => Domain -> Producer BS.ByteString m ()
produceSpfIps domain = do spf1s <- forceEither <$> withDefaultResolver (lookupSpf1 domain)
                          -- each spf1s -- for debugging
                          let parsed = map parseOnlySpf spf1s
                              parsed' = map forceEither parsed
                              includes = concat . map (view include) $ parsed'
                              ip4s = concat . map (view ip4) $ parsed'
                              redirects = catMaybes . map (view redirect) $ parsed'
                          each ip4s
                          for (each includes) produceSpfIps
                          for (each redirects) produceSpfIps



