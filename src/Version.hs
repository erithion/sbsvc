{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes, ScopedTypeVariables       #-}
module Version where

import Foundation
import Yesod.Core
import System.Environment (getEnv)
import System.IO.Error (catchIOError, isDoesNotExistError)

getVersionR :: Handler Html
getVersionR = defaultLayout $ do
    setTitle "Smartbook service"
    hash :: String <- liftIO $ 
              catchIOError (read <$> getEnv "APP_GIT_HASH")
                           (\e -> if isDoesNotExistError e then return "APP_GIT_HASH has not been set upon the last git push" else ioError e)  
    [whamlet|
        <p> Service version: #{hash}
    |]
