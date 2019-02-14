{-# LANGUAGE ScopedTypeVariables #-}
import Application () -- for YesodDispatch instance
import Foundation
import Yesod.Core
import System.Environment (getEnv)

main :: IO ()
main = do
   port :: Int <- read <$> getEnv "PORT"
--   putStrLn . show $ port
   warp port App
