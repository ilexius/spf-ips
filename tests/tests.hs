module Main (main) where

import Test.Tasty (defaultMain, testGroup)

import qualified Test.Parser.SPF as TPS

main :: IO ()
main = defaultMain tests

tests = testGroup "Collected" [ TPS.tests ]
