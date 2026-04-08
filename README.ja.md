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

---

## フォーマット制御（重要）

以下のマーカーで、フォーマットを無効化できます：

-- leanscopedfmt: off
（この範囲はフォーマットされない）
-- leanscopedfmt: on

例：

-- leanscopedfmt: off
elab "#count_rw " t:tacticSeq : command => do
  let rws := collectRw t.raw
  logInfo m!"rw count: {rws.size}"
-- leanscopedfmt: on

---

## 現在の仕様（保守的設計）

本ツールは安全性を重視し、以下の処理のみを行います：

- 行末の空白削除
- 連続する空行の圧縮
- 危険な構文（elab / macro など）のスキップ
- 明示的な off/on 範囲の保護

※ ASTベースの積極的な整形は行いません
※ 将来的には AST ベースフォーマッタへの橋渡しを意識しています
---

## 対応ファイル

本ツールは `.lean` ファイルのみを対象とします。

以下のファイルは無視されます：

- .md
- .json
- .ts
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

## 技術的ポイント（ポートフォリオ）

本ツールは以下の設計思想に基づいています：

- **idempotent（冪等性）**：何度実行しても結果が変わらない
- **安全性優先**：壊れる可能性がある箇所は触らない
- **スコープ制御**：ユーザーが明示的に整形範囲を指定できる
- **CLIツール設計**：CI / パイプラインでの利用を想定

また、これは単なるツールではなく：

フォーマッタ設計における「安全性 vs 完全性」のトレードオフの実験
Lean におけるフォーマット戦略の研究的プロトタイプ

という側面も持っています。
---

## 想定ユースケース

- Lean のメタプログラミングコードを扱うプロジェクト
- フォーマッタによる破壊を避けたい場合
- CIでフォーマットチェックを行いたい場合

---

## 今後の予定

- import 文の整理（重複削除・ソート）
- より安全なトークンベース整形
- ignore 設定の拡張
- Lean AST を用いたフォーマットの検討
- proof リファクタリングとの統合検討
---

## ライセンス

MIT
