namespace LeanScopedFmt

def isDangerousLine (s : String) : Bool :=
  let t := s.trimAscii
  t.startsWith "elab " ||
  t.startsWith "macro " ||
  t.startsWith "syntax " ||
  t.contains "`(" ||
  t.contains "match " ||
  t.contains "where" ||
  t.contains " by" ||
  t.contains " do"

def trimRight (s : String) : String :=
  (s.trimAsciiEnd).toString

def formatSafeLine (s : String) : String :=
  trimRight s

def squashBlankLines : List String → List String
  | [] => []
  | [x] => [x]
  | x :: y :: xs =>
      if x.trimAscii.isEmpty && y.trimAscii.isEmpty then
        squashBlankLines (y :: xs)
      else
        x :: squashBlankLines (y :: xs)

def formatOnRegion (lines : List String) : List String :=
  lines
    |>.map (fun line => if isDangerousLine line then line else formatSafeLine line)
    |> squashBlankLines

end LeanScopedFmt

