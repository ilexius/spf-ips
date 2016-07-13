module Parser.SPF where

import Control.Lens
import Data.ByteString.Char8 (pack)
import qualified Data.Attoparsec.ByteString.Char8 as P

import Data.SPF

parseOnlySpf = P.parseOnly pSpf

pSpf :: P.Parser SpfData
pSpf = do spf <- pSpf1Start
          P.char ' '
          bodies <- appBody
          return $ map' bodies spf

map' :: [a -> a] -> a -> a
map' [] x = x
map' (f:fs) x = map' fs (f x)

pSpf1Start = const defaultSpf1Data <$> P.string spf1Start

appBody = P.sepBy1 appIncludeOrIp4 (P.char ' ')
appIncludeOrIp4 = P.choice [appRedirect, appInclude, appIp4, appIp6]
appRedirect = set redirect . Just <$> pRedirect
appInclude = (\r -> over include (r:)) <$> pInclude
appIp4 = (\r -> over ip4 (r:)) <$> pIp4
appIp6 = (\r -> over ip6 (r:)) <$> pIp6

pRedirect = P.string (pack "redirect=") *> pWord
pInclude = P.string (pack "include:") *> pWord
pIp4 = P.string (pack "ip4:") *> pWord
pIp6 = P.string (pack "ip6:") *> pWord
pWord = P.takeWhile1 (not . P.isSpace)
