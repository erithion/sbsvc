{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Person where

import Foundation
import Yesod.Core
import Data.Text as T
import qualified Data.Map as M

getPersonR :: Handler TypedContent
getPersonR = selectRep $ do
{-    provideRep $ return
        [shamlet|
            <p>Hello, my name is #{name} and I am #{age} years old.
        |] -}
    provideRep $ do
        value <- requireCheckJsonBody
        let name2 :: Maybe Text = M.lookup ("name" :: Text) value
        return $ object
          [ "name" .= (T.append <$> name2 <*> Just "!!!!")
          , "age" .= age
          ]
  where
    name = "Michael" :: Text
    age = 28 :: Int
