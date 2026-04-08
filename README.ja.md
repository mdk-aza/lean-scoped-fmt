# LeanScopedFmt（日本語版）

Lean のメタプログラミングコードを壊さないことを重視した、安全志向のフォーマッタです。

[English README](README.md)

---

## 概要

Lean には強力なメタプログラミング機能（elab / macro / syntax など）がありますが、
一般的なフォーマッタはこれらのコードを壊してしまうことがあります。

LeanScopedFmt は「壊さないこと」を最優先に設計された、保守的なフォーマッタです。

また本ツールは、将来的な公式フォーマッタ（例：leanprover-community の format_lean など）に向けた
プロトタイプ的な位置付けも持っています。

---

## 特徴

- .lean ファイル専用のフォーマッタ
- CLI から実行可能
- ディレクトリを再帰的に処理
- `--check` に対応（CIで利用可能）
- stdin / stdout に対応
- フォーマット対象の明示的な制御が可能
- マーカーによるフォーマット範囲の制御
- 危険な構文（elab / macro / syntax / quotation）をヒューリスティックにスキップ

---

## フォーマット制御（重要）

以下のマーカーで、フォーマットを無効化できます：

```lean
-- leanscopedfmt: off
elab "#count_rw " t:tacticSeq : command => do
  let rws := collectRw t.raw
  logInfo m!"rw count: {rws.size}"
-- leanscopedfmt: on
```

---

## 現在の仕様（保守的設計）

本ツールは安全性を重視し、以下の処理のみを行います：

- 行末の空白削除
- 連続する空行の圧縮
- メタプログラミング構文のスキップ
- off/on マーカーの尊重

※ ASTベースの積極的な整形は行いません

---

## 対応ファイル

本ツールは `.lean` ファイルのみを対象とします。

以下のファイルは無視されます：

- .md, .json , .ts
- build / .lake / .git などのディレクトリ

---

## インストール

リポジトリをクローンしてビルドします：
```
git clone https://github.com/YOUR_GITHUB_NAME/lean-scoped-fmt.git
cd LeanScopedFmt
lake build
```

---

## 使い方

### ファイル整形
```
lake exe leanscopedfmt Main.lean
```
### 複数ファイル
```
lake exe leanscopedfmt Main.lean LeanScopedFmt/Rules.lean
```
### ディレクトリ全体
```
lake exe leanscopedfmt .
```
### チェックのみ（CI用）
```
lake exe leanscopedfmt --check .
```
### stdout出力
```
lake exe leanscopedfmt --stdout Main.lean
```
### stdin → stdout
```
cat Main.lean | lake exe leanscopedfmt
```
---

## モチベーション

Lean のメタプログラミングコードは、フォーマットによって壊れやすいという特性があります。

既存のフォーマッタは完全性（ASTベース整形など）を重視する傾向があり、
macro や elab などのコードに対して破壊的な変更を加えてしまう可能性があります。

LeanScopedFmt はこれに対して：

- 完全性よりも安全性を優先する
- 危険な領域には触れない
- スコープによる明示的制御を可能にする

という設計思想を採用しています。

また本プロジェクトは、将来的なフォーマッタの在り方（ヒューリスティック vs AST）を探る
プロトタイプとしての側面も持っています。

---

## 設計思想

- **idempotent（冪等性）**：何度実行しても結果が変わらない
- **安全性優先**：壊れる可能性がある箇所は触らない
- **スコープ制御**：ユーザーが整形範囲を明示できる
- **CLI設計**：CI / パイプラインでの利用を想定

また本プロジェクトは：

フォーマッタ設計における安全性 vs 完全性のトレードオフの検証
Leanにおけるフォーマット戦略のプロトタイプ

という側面も持っています。

---

## 想定ユースケース

- Lean のメタプログラミングコードを扱うプロジェクト
- フォーマッタによる破壊を避けたい場合
- CIでフォーマットチェックを行いたい場合

---

## 今後の予定

- import 文の整理
- トークンベース整形
- ignore 設定の拡張
- ASTベースフォーマットの検討
- proofリファクタリングとの統合
---

## ライセンス

MIT
