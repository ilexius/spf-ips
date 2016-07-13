module Network.SPF where

import qualified Data.ByteString as BS
import Data.ByteString.Char8 (pack)
import Data.List
import Network.DNS
import Control.Monad.IO.Class

import Data.SPF

withDefaultResolver :: MonadIO m => (Resolver -> IO b) -> m b
withDefaultResolver f = do seed <- (liftIO . makeResolvSeed) defaultResolvConf
                           (liftIO . withResolver seed) f

getSpf1 resolver domain = fmap filterSpf1 <$> lookupTXT resolver domain
  where filterSpf1 = filter (spf1Start `BS.isPrefixOf`)

