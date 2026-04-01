import LeanScopedFmt.Scanner
import LeanScopedFmt.Formatter

open LeanScopedFmt

def formatText (input : String) : String :=
  let lines := input.splitOn "\n"
  let regions := splitRegions lines
  let out := formatRegions regions
  String.intercalate "\n" out ++ "\n"

def readStdin : IO String := do
  let stdin ← IO.getStdin
  stdin.readToEnd

def isLeanFile (path : System.FilePath) : Bool :=
  System.FilePath.extension path == some "lean"

def isIgnored (path : System.FilePath) : Bool :=
  let s := path.toString
  s.contains "/.lake/" ||
  s.endsWith "/.lake" ||
  s.contains "/build/" ||
  s.endsWith "/build" ||
  s.contains "/lake-packages/" ||
  s.endsWith "/lake-packages" ||
  s.contains "/.git/" ||
  s.endsWith "/.git"

def collectLeanFiles (dir : System.FilePath) : IO (List System.FilePath) := do
  let paths ← System.FilePath.walkDir dir
  pure <| paths.toList.filter (fun p => isLeanFile p && !isIgnored p)

def processFile (path : System.FilePath) (check : Bool) : IO Bool := do
  let content ← IO.FS.readFile path
  let formatted := formatText content
  if check then
    if content == formatted then
      pure true
    else
      IO.println s!"needs formatting: {path}"
      pure false
  else
    if content != formatted then
      IO.FS.writeFile path formatted
      IO.println s!"formatted: {path}"
    pure true

def runFormatTargets (targets : List String) (check : Bool) : IO UInt32 := do
  let mut allOk := true

  for t in targets do
    let path := System.FilePath.mk t
    if ← System.FilePath.isDir path then
      let files ← collectLeanFiles path
      for f in files do
        let ok ← processFile f check
        if !ok then
          allOk := false
    else
      let ok ← processFile path check
      if !ok then
        allOk := false

  pure <| if allOk then 0 else 1

def runStdoutFile (path : System.FilePath) : IO UInt32 := do
  let input ← IO.FS.readFile path
  IO.print (formatText input)
  pure 0

def runStdinToStdout : IO UInt32 := do
  let input ← readStdin
  IO.print (formatText input)
  pure 0

def main (args : List String) : IO UInt32 := do
  match args with
  | [] =>
      runStdinToStdout
  | ["--check", file] =>
      runFormatTargets [file] true
  | "--check" :: rest =>
      runFormatTargets rest true
  | ["--stdout", file] =>
      runStdoutFile (System.FilePath.mk file)
  | ["--stdout"] =>
      runStdinToStdout
  | [file] =>
      runFormatTargets [file] false
  | files =>
      runFormatTargets files false

