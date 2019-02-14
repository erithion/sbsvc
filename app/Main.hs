import Application () -- for YesodDispatch instance
import Foundation
import Yesod.Core
import System.Environment (getEnv)

main :: IO ()
main = do
   port <- read <$> getEnv "PORT"
   warp port App
