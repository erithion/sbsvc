{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Home where

import Foundation
import Yesod.Core
import Smartbook

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Smartbook service"
    let rev = libraryGitInfo
    [whamlet|
        <p> Smartbook service Alpha<br> <p> Smartbook library version: #{rev}
    |]
