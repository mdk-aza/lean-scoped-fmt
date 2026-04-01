namespace LeanScopedFmt

inductive RegionKind where
  | on
  | off
  deriving Repr, BEq

structure Region where
  kind  : RegionKind
  lines : List String
  deriving Repr

end LeanScopedFmt

