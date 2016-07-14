module Parser.SPF
  ( parseOnlySpf
  , pSpf
  ) where

import Control.Lens (over, set)
import Data.ByteString.Char8 (ByteString, pack)
import qualified Data.Attoparsec.ByteString.Char8 as P
import Data.Attoparsec.ByteString.Char8 (Parser)

import Data.SPF

parseOnlySpf :: ByteString -> Either String SpfData
parseOnlySpf = P.parseOnly pSpf

pSpf :: Parser SpfData
pSpf = do spf <- pSpf1Start
          P.char ' '
          bodies <- appBody
          return (foldr ($) spf bodies)

pSpf1Start :: Parser SpfData
pSpf1Start = const defaultSpf1Data <$> P.string spf1Start

appBody :: Parser [SpfData -> SpfData]
appBody = P.sepBy1 appMechanisms (P.char ' ')

-- The following parsers result in functions (SpfData -> SpfData)
-- which manipulate a SpfData instance. appMechanisms :: Parser (SpfData -> SpfData)
appMechanisms = P.choice mechanisms
  where mechanisms = [appRedirect, appInclude, appIp4, appIp6]

appRedirect = set redirect . Just <$> pRedirect
appInclude = (\r -> over include (r:)) <$> pInclude
appIp4 = (\r -> over ip4 (r:)) <$> pIp4
appIp6 = (\r -> over ip6 (r:)) <$> pIp6

pRedirect = P.string (pack "redirect=") *> pWord
pInclude = P.string (pack "include:") *> pWord
pIp4 = P.string (pack "ip4:") *> pWord
pIp6 = P.string (pack "ip6:") *> pWord
pWord = P.takeWhile1 (not . P.isSpace)
