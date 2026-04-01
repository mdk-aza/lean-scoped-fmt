import LeanScopedFmt.Types
import LeanScopedFmt.Scanner
import LeanScopedFmt.Rules
import LeanScopedFmt.Formatter

namespace LeanScopedFmt

def formatText (input : String) : String :=
  let lines := input.splitOn "\n"
  let regions := splitRegions lines
  let out := formatRegions regions
  String.intercalate "\n" out

end LeanScopedFmt

