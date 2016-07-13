module Main where

import Test.Tasty

import qualified Test.Parser.SPF as TPS

main :: IO ()
main = defaultMain tests

tests = testGroup "Collected" [ TPS.tests ]
