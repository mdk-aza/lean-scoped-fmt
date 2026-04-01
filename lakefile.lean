import Lake
open Lake DSL

package LeanScopedFmt where
  version := v!"0.1.0"

lean_lib LeanScopedFmt

@[default_target]
lean_exe leanscopedfmt where
  root := `Main

