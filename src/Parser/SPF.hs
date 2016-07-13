module Parser.SPF where

import Control.Lens
import Data.ByteString.Char8 (pack)
import qualified Data.Attoparsec.ByteString.Char8 as P

import Data.SPF

pSpf = do spf <- pSpf1Start
          P.char ' '
          bodies <- appBody
          return $ map' bodies spf

map' :: [a -> a] -> a -> a
map' [] x = x
map' (f:fs) x = map' fs (f x)

pSpf1Start = const defaultSpf1Data <$> P.string spf1Start

appBody = P.sepBy1 appIncludeOrIp4 (P.char ' ')
appIncludeOrIp4 = P.choice [appInclude, appIp4]
appInclude = (\r -> over include (r:)) <$> pInclude
appIp4 = (\r -> over ip4 (r:)) <$> pIp4

pInclude = P.string (pack "include:") *> pWord
pIp4 = P.string (pack "ip4:") *> pWord
pWord = P.takeWhile1 (not . P.isSpace)
