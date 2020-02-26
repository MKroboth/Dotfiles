{-# LANGUAGE RebindableSyntax #-}
import XMonad.Config.Prime
import Data.List (sortBy)
import Data.List.Split(splitOn)
import Data.Function (on)

import XMonad.Layout.Fullscreen (fullscreenSupport)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Hooks.ManageDocks
import Control.Monad (forM_, join)
import XMonad.Util.Run (safeSpawn, safeSpawnProg, unsafeSpawn)
import XMonad.Util.NamedWindows (getName)
import qualified XMonad.StackSet as W
import qualified Prelude as P
import System.Environment(getEnv, setEnv)
import System.Directory(doesFileExist)
import XMonad.Hooks.DynamicLog

withLogFifo x = forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file ->  safeSpawn "mkfifo" ["/tmp/" ++ file] >>= x
  

polybarLogHook = dynamicLogWithPP polybarPP
  where polybarPP = (def :: PP) { ppCurrent = wrap "%{u#ff9900}" "%{-u}" . pad . nameWs
                                , ppHidden = pad . nameWs
                                , ppHiddenNoWindows = pad . nameWs
                                , ppUrgent = pad . nameWs
                                , ppVisible =  wrap "%{u#555555}" "%{-u}" . pad . nameWs
                                , ppVisibleNoWindows = Nothing
                                , ppWsSep = ""
                                , ppSep = "\0"
                                , ppExtras = []
                                , ppOutput  = \w -> let x = parts w in do
                                    appendFile "/tmp/.xmonad-workspace-log" ((x !! 0) ++ "\n")
                                    appendFile "/tmp/.xmonad-title-log" ((x !! 2) ++ "\n")
                                }
        parts = splitOn "\0"
        nameWs "0" = "S"
        nameWs x = x
        (>>) = (P.>>)



getPlatform :: IO String
getPlatform = return "workstation"

main = withLogFifo $ \logFifo -> (getEnv "HOME") >>= \home -> xmonad $ do 
  terminal =: "kitty"
  modMask =: mod4Mask
  modifyLayout smartBorders
  apply docks
  apply fullscreenSupport
  startupHook =+ liftIO (setEnv "_JAVA_AWT_WM_NONREPARENTING" "1")
  startupHook =+ (safeSpawnProg $ home ++ "/.xmonad/xmonadrc")
  logHook =+ polybarLogHook
  modifyLayout avoidStruts
  withWorkspaces $ do
    wsKeys =+ ["0"]
    wsSetName 0 "Scratchpad"
  keys =+ [ ("M-p", safeSpawn "rofi" ["-show", "run"])
          , ("M-S-<Return>", safeSpawnProg "kitty")
          , ("M-x w", safeSpawnProg "qutebrowser")
          , ("M-x e", safeSpawn "emacsclient" ["-c", "-a", "emacs"])
          , ("M-b", sendMessage ToggleStruts)
          ]
  keys =- [ "M-w", "M-e", "M-r", "M-S-w", "M-S-e", "M-S-r" ]
  withScreens $ do
    sKeys =: ["w","e","r"]
