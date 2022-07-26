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
  deriving (ToJSON) via (GenericallyToJSONToEncoding W)

data X = X Int Int
  deriving stock (Generic)
  deriving (ToJSON) via (GenericallyToEncoding X)

toEncodingDerivedBoth :: W -> Encoding
toEncodingDerivedBoth = toEncoding

toEncodingTargetBoth :: W -> Encoding
toEncodingTargetBoth = genericToEncoding defaultOptions

toEncodingDerivedOnly :: X -> Encoding
toEncodingDerivedOnly = toEncoding

toEncodingTargetOnly :: X -> Encoding
toEncodingTargetOnly = genericToEncoding defaultOptions

main :: IO ()
main = pure ()

inspect $ 'toEncodingDerivedBoth ==- 'toEncodingTargetBoth
inspect $ 'toEncodingDerivedOnly ==- 'toEncodingTargetOnly
