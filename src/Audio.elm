port module Audio exposing (..)
import Msg

type alias Playback = {
    file: String
  , progress: Float
}

type alias Arg = {
    file: Maybe String
  , position: Maybe Float
  , volume: Maybe Float
}

argNothing: Arg
argNothing =
  { file = Nothing, position =  Nothing, volume = Nothing }

type Command = SetFile String Float Float | Play | Pause | Unpause | SkipTo (Float) | Toggle | SetVolume (Float) | Stop
type alias JsCommand =
  { command : String
  , arg : Arg
  }

toJs : Command -> JsCommand
toJs command =
  case command of
    SetFile name pos vol ->
      { command = "SetFile", arg = { file = Just name,  position = Just pos, volume = Just vol } }
    Play ->
      { command = "Play", arg = argNothing }
    Pause ->
      { command = "Pause", arg = argNothing }
    Unpause ->
      { command = "Unpause", arg = argNothing }
    Toggle ->
      { command = "Toggle", arg = argNothing }
    SkipTo num ->
      { command = "SkipTo", arg = { file = Nothing, position = Just num,  volume = Nothing } }
    SetVolume num ->
      { command = "SetVolume", arg = { file = Nothing, position = Nothing, volume = Just num } }
    Stop ->
      { command = "Stop", arg = argNothing }

port command  : JsCommand -> Cmd msg
port progress : (Float -> msg) -> Sub msg
port volume : (Float -> msg) -> Sub msg
port playing : (Bool -> msg) -> Sub msg
port ready : (Float -> msg) -> Sub msg
