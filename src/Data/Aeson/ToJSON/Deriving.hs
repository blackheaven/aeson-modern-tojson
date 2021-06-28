{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}

-- |
-- Module:      Data.Time.Format.Typed
-- Copyright:   (c) 20021 Gautier DI FOLCO
-- License:     ISC
-- Maintainer:  Gautier DI FOLCO <gautier.difolco@gmail.com>
-- Stability:   experimental
-- Portability: GHC
--
-- Provide a newtype to be used with DerivingVia to correctly derive <https://hackage.haskell.org/package/aeson-1.5.6.0/docs/Data-Aeson.html#g:7 ToJSON>.
--
-- As simple as:
--
--
-- @
-- data W = W Int Int
--   deriving stock (Generic)
--   deriving (ToJSON) via (ModernToJSON W)
-- @
module Data.Aeson.ToJSON.Deriving
  ( ModernToJSON (..),
    ToJSON (..),
  )
where

import Data.Aeson
import GHC.Generics

newtype ModernToJSON a = ModernToJSON {unModernToJSON :: a}
  deriving stock (Eq, Show, Generic)

instance
  ( Generic a,
    ToJSON a,
    GToJSON' Value Zero (Rep a),
    GToJSON' Encoding Zero (Rep a)
  ) =>
  ToJSON (ModernToJSON a)
  where
  toJSON = genericToJSON defaultOptions . unModernToJSON
  toEncoding = genericToEncoding defaultOptions . unModernToJSON
