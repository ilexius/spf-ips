{-# LANGUAGE TemplateHaskell #-}
module Test.Parser.SPF (tests) where

import Data.ByteString.Char8 (pack)
import Data.Attoparsec.ByteString (parseOnly)
import Control.Lens (set)
import Test.Tasty.TH
import Test.Tasty.HUnit

import Data.SPF
import Parser.SPF

tests = $(testGroupGenerator)

testParser parser str exp = case parseOnly parser packedStr of
                              Right result -> result @?= exp 
                              x -> assertFailure $ "Expected Right got: " ++ show x
  where packedStr = pack str

case_whole_spf_data = testParser pSpf src expected
  where src = unwords [ "v=spf1 include:spf-a.outlook.com include:spf-b.outlook.com"
                      , "ip4:157.55.9.128/25 include:spf.protection.outlook.com"
                      , "include:spf-a.hotmail.com include:_spf-ssg-b.microsoft.com"
                      , "include:_spf-ssg-c.microsoft.com ~all"
                      ]
        expected = SpfData 
                     1
                     Nothing
                     (map pack [ "spf-a.outlook.com"
                               , "spf-b.outlook.com"
                               , "spf.protection.outlook.com"
                               , "spf-a.hotmail.com"
                               , "_spf-ssg-b.microsoft.com"
                               , "_spf-ssg-c.microsoft.com"
                               ])
                     [pack "157.55.9.128/25" ]
                     []

case_spf_data_w_ip6 = testParser pSpf src expected
  where src = "v=spf1 ip6:2a01:111:f400::/48"
        expected = set ip6 [pack "2a01:111:f400::/48"] defaultSpf1Data

case_spf_data_w_redirect = testParser pSpf src expected
  where src = "v=spf1 redirect=_spf.google.com"
        expected = set redirect (Just . pack $ "_spf.google.com") defaultSpf1Data
