# LeanScopedFmt

A conservative formatter for Lean that preserves fragile metaprogramming regions.

Japanese version: [README.ja.md](README.ja.md)

## Overview

Lean provides powerful metaprogramming features (e.g., elab, macro, syntax),
but conventional formatters may break such code.

LeanScopedFmt is designed with a safety-first philosophy, ensuring fragile code remains intact.

This project also serves as a prototype toward a future official formatter ecosystem
(e.g., similar to format_lean from leanprover-community).

## Features

- Formats .lean files from CLI
- Supports recursive directory formatting
- Supports --check
- Supports stdin/stdout usage
- Preserves explicitly marked regions
- Skips fragile regions heuristically (elab / macro / syntax / quotation)

## Scoped formatting control

You can disable formatting in specific regions using markers:

```lean
-- leanscopedfmt: off
elab "#count_rw " t : command => do
  let rws := collectRw t.raw
  logInfo m!"rw count: {rws.size}"
-- leanscopedfmt: on
```

## Current behavior (conservative design)

This tool prioritizes safety and performs only minimal transformations:

- trims trailing whitespace
- squashes consecutive blank lines
- preserves fragile metaprogramming regions
- supports scoped format disable/enable markers

It does not yet aim to be a full AST-based formatter.

## File types

This formatter only processes .lean files.

Other file types such as .md, .json, and .ts are ignored even if explicitly passed.

## Installation

Clone the repository and build with Lake:

```
git clone https://github.com/YOUR_GITHUB_NAME/lean-scoped-fmt.git
cd LeanScopedFmt
lake build
```

## Usage

Format a file in place:
```Lean
lake exe leanscopedfmt Main.lean
```

Format multiple files:
```Lean
lake exe leanscopedfmt Main.lean LeanScopedFmt/Rules.lean
```


Format all Lean files recursively under a directory:
```Lean
lake exe leanscopedfmt .
```

Check formatting without modifying files:
```Lean
lake exe leanscopedfmt --check .
```


Print formatted output to stdout:
```Lean
lake exe leanscopedfmt --stdout Main.lean
```

Read from stdin and print to stdout:
```Lean
cat Main.lean | lake exe leanscopedfmt
```

## Motivation

Lean metaprogramming code is inherently fragile under aggressive formatting.

Existing approaches often prioritize completeness (e.g., AST-based formatting),
which can introduce subtle breakages in macros, elaborators, or syntax extensions.

LeanScopedFmt takes a different approach:

- prioritize safety over completeness
- avoid modifying fragile regions
- give users explicit control via scoped markers

This project also serves as a prototype toward a future formatter ecosystem,
exploring the trade-offs between heuristic and AST-based approaches.

## Design principles

- Idempotence: repeated runs produce identical output
- Safety-first: avoid modifying fragile constructs
- Scoped control: user-defined formatting boundaries
- CLI-oriented: designed for CI and pipelines

This project also explores the trade-off between:

- safety vs. completeness in formatting
- heuristic vs. AST-based approaches

## Use cases
- Lean projects with metaprogramming
- Avoiding formatter-induced breakage
- CI formatting checks

## Roadmap

- import cleanup (deduplication / sorting)
- token-aware formatting
- configurable ignore rules
- AST-based formatting exploration
- integration with proof refactoring workflows

## License

MIT
