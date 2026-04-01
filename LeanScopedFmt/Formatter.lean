import LeanScopedFmt.Types
import LeanScopedFmt.Rules

namespace LeanScopedFmt

def formatRegion (r : Region) : List String :=
  match r.kind with
  | .off => r.lines
  | .on  => formatOnRegion r.lines

def formatRegions (rs : List Region) : List String :=
  rs.foldr (fun r acc => formatRegion r ++ acc) []

end LeanScopedFmt

