{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -dsuppress-idinfo -dsuppress-coercions -dsuppress-type-applications
-dsuppress-module-prefixes -dsuppress-type-signatures -dsuppress-uniques -O #-}

module Data.Aeson.ToJSON.DerivingSpec (main) where

import Data.Aeson
import Data.Aeson.ToJSON.Deriving
import GHC.Generics
import Test.Inspection (inspect, (==-))

data W = W Int Int
  deriving stock (Generic)
  deriving (ToJSON) via (ModernToJSON W)

toEncodingDerived :: W -> Encoding
toEncodingDerived = toEncoding

toEncodingTarget :: W -> Encoding
toEncodingTarget = genericToEncoding defaultOptions

main :: IO ()
main = pure ()

inspect $ 'toEncodingDerived ==- 'toEncodingTarget
