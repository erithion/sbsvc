{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE DeriveGeneric #-}
module Book where

import Foundation
import Yesod.Core
import Yesod.Core.Json
import GHC.Generics
import qualified Data.Map as M
--import Data.Aeson

import qualified Data.ByteString            as BS
import qualified Data.ByteString.Lazy       as BSL
import qualified Data.Text.Lazy.IO          as TL
import qualified Data.Text.Lazy             as TL
import qualified Data.Text.Lazy.Encoding    as TL
import qualified Data.Text             as T (pack)
import Smartbook


newtype RepSb = RepSb BS.ByteString
             deriving (Show, ToContent)

typeSb :: ContentType
typeSb = "application/sb"

instance ToTypedContent RepSb where
    toTypedContent h = TypedContent typeSb (toContent h)

instance HasContentType RepSb where
    getContentType _ = typeSb
--deriving instance ToContent RepSb

-- TODO: On introducing DB the function must be changed
--      - add resource 'books'
--      - PUT 'books' creates a new book
--      - GET 'books' lists all books
--      - GET Content-Type: application/sb 'books'/<book> gets the book in encrypted sb format
--      - GET Content-Type: application/json 'books'/<book> gets the book in unencrypted json format
{-
getBookR :: Handler TypedContent
getBookR = selectRep $ do
    provideRep $ do
        value <- requireCheckJsonBody
        let book :: Maybe TL.Text = M.lookup ("book" :: TL.Text) value
        case book of
            Just txt -> return . RepSb . createBook $ txt
            Nothing  -> invalidArgs ["'book' argument is not found"]
  where
    createBook :: TL.Text -> BS.ByteString
    createBook txt = Crypto.encrypt txt
    encrypt :: TL.Text -> BS.ByteString
    encrypt = BSL.toStrict . BSL.reverse . TL.encodeUtf8
-}

data BookRequest = BookRequest
       { author :: String
       , title  :: String
       , filename :: String
       , bilingualText   :: TL.Text }
       deriving (Generic, Show)

instance FromJSON BookRequest

postBookR :: Handler TypedContent
postBookR = do
    v :: BookRequest <- requireCheckJsonBody
    let book = exampleComposeBook (enruBoilerplate (filename v) (title v) (author v))
                                  (plainChapters ["kapitel", "chapter"] (bilingualText v))
    let bytes = encrypt book
    selectRep $ provideRep $ return $ RepSb bytes
