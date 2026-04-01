import LeanScopedFmt.Types

namespace LeanScopedFmt

def markerPrefix : String := "-- leanscopedfmt: "

def isOffMarker (line : String) : Bool :=
  (line.trimAscii).toString == (markerPrefix ++ "off")

def isOnMarker (line : String) : Bool :=
  (line.trimAscii).toString == (markerPrefix ++ "on")

partial def flushRegion (kind : RegionKind) (buf : List String) (acc : List Region) : List Region :=
  if buf.isEmpty then
    acc
  else
    acc ++ [{ kind := kind, lines := buf }]

def splitRegions (lines : List String) : List Region :=
  let rec go (rest : List String) (mode : RegionKind) (buf : List String) (acc : List Region) :=
    match rest with
    | [] =>
        flushRegion mode buf acc
    | line :: xs =>
        if isOffMarker line then
          let acc := flushRegion mode buf acc
          go xs .off [line] acc
        else if isOnMarker line then
          let acc := flushRegion mode buf acc
          go xs .on [line] acc
        else
          go xs mode (buf ++ [line]) acc
  go lines .on [] []

end LeanScopedFmt

