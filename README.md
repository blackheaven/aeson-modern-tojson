# aeson-modern-tojson
Provide a newtype to be used with DerivingVia to correctly derive [ToJSON](https://hackage.haskell.org/package/aeson-2.1.0.0/docs/Data-Aeson.html#g:7).

As simple as:


```
data W = W Int Int
    deriving stock (Generic)
    deriving (ToJSON) via (GenericallyToJSONToEncoding W)
```

```
data X = X Int Int
    deriving stock (Generic)
    deriving (ToJSON) via (GenericallyToEncoding X)
```
