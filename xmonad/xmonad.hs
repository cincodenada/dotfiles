import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.Accordion
import Data.List
import System.IO
import qualified XMonad.StackSet as W   -- Managehook rules, for unfloat

myManageHook = composeAll
    [ className =? "Do"  --> doFloat
    , className =? "Kupfer.py"  --> doFloat
    , className =? "Vncviewer" --> doFloat
--    , (not ((stripPrefix "#" title) =? Nothing)) --> doFloat
--    , className =? "Gimp"      --> doFloat
    , className =? "processing-app-Base"  --> doFloat
    , className =? "Mysql-workbench-bin" --> unfloat
    ]
    where unfloat = ask >>= doF . W.sink


main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig ||| Accordion
        , logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , focusFollowsMouse = False
        } `additionalKeys`
        [ ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((controlMask, xK_space), spawn "kupfer")
        ]
