{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}

-- |
-- Module:      Data.Time.Format.Typed
-- Copyright:   (c) 2021-2022 Gautier DI FOLCO
-- License:     ISC
-- Maintainer:  Gautier DI FOLCO <gautier.difolco@gmail.com>
-- Stability:   experimental
-- Portability: GHC
--
-- Provide a newtype to be used with DerivingVia to correctly derive <https://hackage.haskell.org/package/aeson-2.1.0.0/docs/Data-Aeson.html#g:7 ToJSON>.
--
-- As simple as:
--
--
-- @
-- data W = W Int Int
--   deriving stock (Generic)
--   deriving (ToJSON) via (GenericallyToJSONToEncoding W)
-- @
--
-- @
-- data X = X Int Int
--   deriving stock (Generic)
--   deriving (ToJSON) via (GenericallyToEncoding X)
-- @
module Data.Aeson.ToJSON.Deriving
  ( GenericallyToJSONToEncoding (..),
    GenericallyToEncoding (..),
    ToJSON (..),
  )
where

import Data.Aeson
import Data.Maybe (fromMaybe)
import GHC.Generics

-- | Deriving via 'Generic' 'toJSON' and 'toEncoding'.
newtype GenericallyToJSONToEncoding a = GenericallyToJSONToEncoding {unGenericallyToJSONToEncoding :: a}
  deriving stock (Eq, Show, Generic)

instance
  ( Generic a,
    ToJSON a,
    GToJSON' Value Zero (Rep a),
    GToJSON' Encoding Zero (Rep a)
  ) =>
  ToJSON (GenericallyToJSONToEncoding a)
  where
  toJSON =
    genericToJSON defaultOptions
      . unGenericallyToJSONToEncoding
  toEncoding =
    genericToEncoding defaultOptions
      . unGenericallyToJSONToEncoding

-- | Deriving via 'Generic' 'toEncoding' ('toJSON' is done via 'decode . encode').
newtype GenericallyToEncoding a = GenericallyToEncoding {unGenericallyToEncoding :: a}
  deriving stock (Eq, Show, Generic)

instance
  ( Generic a,
    ToJSON a,
    GToJSON' Encoding Zero (Rep a)
  ) =>
  ToJSON (GenericallyToEncoding a)
  where
  toJSON =
    fromMaybe (error "GenericallyToEncoding.toJSON: unable to decode encoded Value")
      . decode
      . encode
      . unGenericallyToEncoding
  toEncoding =
    genericToEncoding defaultOptions
      . unGenericallyToEncoding
