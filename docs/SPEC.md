# NullPointerExceptionPunch 仕様書

## 1. 概要

| 項目 | 内容 |
|------|------|
| プロジェクト名 | NullPointerExceptionPunch |
| パッケージ名 | `nullpointerpunch`（Debian） |
| コマンド名 | `ぬるぽ` |
| 目的 | ターミナル上で「ガッ（ｶﾞｯ）」を再現するジョーク CLI |
| ライセンス | MIT |
| 対象 OS | Debian/Ubuntu 系（`.deb` 配布） |
| シェル | POSIX `sh`（`#!/bin/sh`） |
| アーキテクチャ | `all`（スクリプトのみ、バイナリビルド不要） |

### 1.1 背景・コンセプト

ネットミーム「ぬるぽ（ガッ）」をターミナルコマンドとして提供する。
「ターミナルにもインターネッツが欲しい」という趣旨のユーティリティ。

---

## 2. システム構成

### 2.1 ディレクトリ構成

```
NullPointerExceptionPunch/
├── bin/ぬるぽ              # コマンド本体（@VERSION@ はビルド時注入）
├── man/ぬるぽ.1            # man 原稿（@VERSION@ プレースホルダ）
├── DEBIAN/control          # .deb メタデータ（Version はビルド時注入）
├── Makefile                # ビルド・インストール・クリーン
├── scripts/install.sh      # GitHub Release からのリモートインストール（補助）
├── release-please-config.json
├── .github/workflows/
│   ├── release-please.yml
│   └── release.yml
├── .release-please-manifest.json  # バージョン定義の唯一の正
├── CHANGELOG.md            # release-please が管理
├── docs/SPEC.md            # 本仕様書
├── README.md               # 利用者向けクイックスタート
├── LICENSE
├── .gitignore              # build/, *.deb
└── build/                  # ビルド生成物（git 管理外）
    └── nullpointerpunch/   # dpkg-deb 用ステージング
        ├── DEBIAN/control
        └── usr/
            ├── bin/ぬるぽ
            └── share/man/man1/ぬるぽ.1.gz
```

**設計方針:** ソース（`bin/`, `man/`）とインストールレイアウト（`usr/`）を分離する。
リポジトリ直下に `usr/` を置かず、ビルド時に FHS 準拠のツリーを `build/` 内に組み立てる。

### 2.2 コンポーネント関係

```mermaid
flowchart LR
    subgraph source [ソース]
        BIN["bin/ぬるぽ<br/>@VERSION@"]
        MAN["man/ぬるぽ.1<br/>@VERSION@"]
        MANIFEST[".release-please-manifest.json<br/>バージョン定義"]
        CTRL["DEBIAN/control<br/>Version プレースホルダ"]
    end

    subgraph build [make deb]
        MK["Makefile"]
    end

    subgraph artifact [成果物]
        DEB["nullpointerpunch_<version>_all.deb"]
    end

    subgraph installed [インストール先]
        USRBIN["/usr/bin/ぬるぽ"]
        MAN1["/usr/share/man/man1/ぬるぽ.1.gz"]
    end

    BIN --> MK
    MAN --> MK
    MANIFEST --> MK
    CTRL --> MK
    MK --> DEB
    DEB -->|dpkg -i| USRBIN
    DEB -->|dpkg -i| MAN1
```

---

## 3. コマンド仕様（`ぬるぽ`）

### 3.1 起動

```sh
ぬるぽ [OPTION]
```

引数は最大 1 つ。複数引数は未対応（第 2 引数以降は無視されない — 未知オプションとして扱われるのは第 1 引数のみ）。

### 3.2 オプション

| オプション | 短縮形 | 動作 | 終了コード |
|-----------|--------|------|-----------|
| （なし） | — | 標準出力に `ｶﾞｯ` を 1 行出力 | 0 |
| `--full` | — | ASCII アート（AA）を標準出力に表示。末尾行に `$USER` を埋め込む | 0 |
| `--version` | — | `ぬるぽ <VERSION>` を 1 行出力 | 0 |
| `--help` | `-h` | ヘルプテキストを標準出力に表示 | 0 |
| 上記以外 | — | エラーメッセージを標準エラーに出力 | 1 |

### 3.3 入出力

| 項目 | 仕様 |
|------|------|
| 標準入力 | 使用しない |
| 標準出力 | 正常時のテキスト出力先 |
| 標準エラー | エラーメッセージ出力先 |
| 環境変数 | `$USER`（`--full` 時のみ参照） |
| 外部依存 | なし（POSIX シェル組み込みのみ） |

### 3.4 `--full` 出力仕様

固定の AA テキストを heredoc で出力する。
最終行は `(＿フ彡 ... /  <- >> $USER` 形式で、実行ユーザ名を表示する。

### 3.5 エラーメッセージ

未知オプション `OPT` に対して:

```
ぬるぽ: unknown option: OPT
Try 'ぬるぽ --help' for more information.
```

（stderr、終了コード 1）

---

## 4. バージョン管理

### 4.1 単一ソース

**`.release-please-manifest.json` が唯一の正。**  
`bin/ぬるぽ` と man ページのバージョンはビルド時に Makefile が注入する。

| 反映先 | 方法 |
|--------|------|
| `ぬるぽ --version` | ビルド時に `bin/ぬるぽ` の `@VERSION@` へ注入 |
| `DEBIAN/control` | `sed 's/^Version: .*/Version: $(VERSION)/'` |
| `man/ぬるぽ.1` | `sed 's/@VERSION@/$(VERSION)/'` → gzip |
| `nullpointerpunch_<version>_all.deb` | manifest のバージョンで命名 |

### 4.2 バージョン更新手順

Conventional Commits 形式で `main` に push すると release-please が Release PR を作成する。

1. `feat:`, `fix:` 等でコミット・push
2. release-please が `.release-please-manifest.json` と `CHANGELOG.md` を更新する PR を作成
3. PR マージ → タグ `vX.Y.Z` が自動作成 → CI が `.deb` をビルド

`make deb` 実行時、`control`・`bin/ぬるぽ`・man ページは manifest の `VERSION` から自動同期される。

`DEBIAN/control` の `Version:` 行はテンプレートとして残す（手動同期不要）。

---

## 5. パッケージ仕様（Debian `.deb`）

### 5.1 メタデータ（`DEBIAN/control`）

| フィールド | 値 |
|-----------|-----|
| Package | `nullpointerpunch` |
| Version | ビルド時に `.release-please-manifest.json` から注入 |
| Section | `utils` |
| Priority | `optional` |
| Architecture | `all` |
| Maintainer | `GoldenPoisonedApple` |

### 5.2 インストールされるファイル

| パス | 権限 | 内容 |
|------|------|------|
| `/usr/bin/ぬるぽ` | `755` | `bin/ぬるぽ` に VERSION を注入して配置 |
| `/usr/share/man/man1/ぬるぽ.1.gz` | `644` | `man/ぬるぽ.1` を gzip -9 圧縮 |

### 5.3 未実装・意図的に省略したもの

| 項目 | 理由 |
|------|------|
| `postinst` / `prerm` | 設定不要の単純スクリプトのため |
| `Depends` | 実行時依存なし |
| `Recommends` / `Suggests` | 不要 |

---

## 6. man ページ仕様（`man/ぬるぽ.1`）

| セクション | 内容 |
|-----------|------|
| NAME | `ぬるぽ - ガッ` |
| SYNOPSIS | `ぬるぽ [--full] [--version] [--help]` |
| DESCRIPTION | コマンドの概要 |
| OPTIONS | 各オプションの説明 |
| EXIT STATUS | 0: 成功、1: 不明なオプション |
| EXAMPLES | 使用例 |
| AUTHOR | `GoldenPoisonedApple` |

man 参照名は `.TH "ぬるぽ"` により `man ぬるぽ` で開ける。

---

## 7. ビルド仕様（Makefile）

### 7.1 ターゲット

| ターゲット | 動作 |
|-----------|------|
| `all` | `deb` のエイリアス |
| `deb` | `nullpointerpunch_<version>_all.deb` を生成 |
| `install` | `deb` ビルド後、`sudo apt install -y ./<deb>` |
| `uninstall` | `sudo apt remove -y nullpointerpunch` |
| `purge` | `sudo apt purge -y nullpointerpunch` |
| `clean` | `build/` と `*.deb` を削除 |

### 7.2 `deb` ターゲットの処理フロー

```
1. build/nullpointerpunch/{DEBIAN,usr/bin,usr/share/man/man1} を作成
2. `.release-please-manifest.json` から VERSION を取得
3. DEBIAN/control に VERSION を注入してステージング
4. bin/ぬるぽ に VERSION を注入 → usr/bin/ に配置（chmod 755）
5. man/ぬるぽ.1 に VERSION を注入 → gzip → usr/share/man/man1/ぬるぽ.1.gz
6. dpkg-deb --build build/nullpointerpunch nullpointerpunch_<version>_all.deb
```

成果物の命名規則: `nullpointerpunch_<version>_all.deb`（Debian 慣習）

### 7.3 ビルド依存

| ツール | 用途 |
|--------|------|
| `make` | ビルドオーケストレーション |
| `dpkg-deb` | `.deb` 生成 |
| `gzip` | man ページ圧縮 |
| `sed` | バージョン注入 |
| `sed`（manifest 解析） | VERSION 抽出 |

---

## 8. 配布・インストール仕様

### 8.1 GitHub Release

| 項目 | 内容 |
|------|------|
| バージョン管理 | release-please（Conventional Commits → Release PR → タグ自動作成） |
| トリガー | release-please による `v*` タグの push |
| CI | `.github/workflows/release-please.yml`, `.github/workflows/release.yml` |
| アセット名 | `nullpointerpunch_<version>_all.deb`（バージョン固定用） |
| | `nullpointerpunch_all.deb`（latest ダウンロード用・固定名） |
| タグ検証 | タグ `vX.Y.Z` と `.release-please-manifest.json` のバージョンが一致すること |

### 8.2 リモートインストール

**最新版（推奨）:**

```
https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases/latest/download/nullpointerpunch_all.deb
```

`wget` / `curl` でダウンロード後、`sudo apt install -y <deb>` でインストール。

**バージョン指定:**

`https://github.com/.../releases/download/v<version>/nullpointerpunch_<version>_all.deb`

**補助スクリプト（`scripts/install.sh`）:**

上記 URL をラップする。引数省略時は latest、指定時はバージョン固定 URL を使用。

### 8.3 アンインストール

| 方法 | コマンド |
|------|---------|
| Makefile | `make uninstall` / `make purge` |
| 直接 | `sudo apt remove nullpointerpunch` |

パッケージ削除により `/usr/bin/ぬるぽ` と man ページが除去される。

---

## 9. 非機能要件

| 項目 | 方針 |
|------|------|
| 移植性 | POSIX `sh` 互換を維持（bash 固有機能不使用） |
| セキュリティ | ネットワーク・ファイル書き込み・権限昇格なし |
| パフォーマンス | 即時終了（外部プロセス起動なし） |
| テスト | 現状自動テストなし（手動確認: `make deb`, `sh bin/ぬるぽ`, ビルド後 `sh build/nullpointerpunch/usr/bin/ぬるぽ --version`） |

---

## 10. 将来の拡張（スコープ外）

以下は現バージョンのスコープ外とする。

- 公式 apt リポジトリ（`apt install nullpointerpunch` をパス指定なしで）
- shellcheck 等の静的解析 CI
- 複数引数の組み合わせ対応
- 設定ファイル（`.nulporc` 等）
- 他 distro 向けパッケージ（RPM 等）

---

## 11. 用語

| 用語 | 意味 |
|------|------|
| ぬるぽ | ネットスラング。Null Pointer Exception に関連するミーム。本ツールでは「ガッ」の擬音として使用 |
| ｶﾞｯ | 半角カタカナによる擬音表現 |
| AA | ASCII Art。`--full` で表示する文字画 |
| FHS | Filesystem Hierarchy Standard。`/usr/bin`, `/usr/share/man` 等の配置規約 |
