{-# LANGUAGE TemplateHaskell #-}
module Data.SPF where -- (SpfData(..), defaultSpf1Data, spf1Start) where

import Control.Lens
import Data.ByteString.Char8 (ByteString, pack)

data SpfData = SpfData { _version  :: Int
                       , _redirect :: Maybe ByteString
                       , _include  :: [ByteString]
                       , _ip4      :: [ByteString]
                       , _ip6      :: [ByteString]
                       }
                       deriving (Eq, Show)

makeLenses ''SpfData

defaultSpf1Data :: SpfData
defaultSpf1Data = SpfData 1 Nothing [] [] []

spf1Start :: ByteString
spf1Start = pack "v=spf1"
