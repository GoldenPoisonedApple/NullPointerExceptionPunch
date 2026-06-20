# NullPointerExceptionPunch

ターミナルにもインターネッツが欲しい～！

`ぬるぽ` を実行すると `ｶﾞｯ` と出力されます。

## クイックインストール（GitHub Release）

Debian / Ubuntu 向け。Release から `.deb` を取得し `apt install` します。

```sh
curl -fsSL https://raw.githubusercontent.com/GoldenPoisonedApple/NullPointerExceptionPunch/main/scripts/install.sh | sh
```

特定バージョンを指定する場合:

```sh
curl -fsSL https://raw.githubusercontent.com/GoldenPoisonedApple/NullPointerExceptionPunch/main/scripts/install.sh | sh -s -- 1.0.0
```

## 手動インストール（GitHub Release）

[Releases](https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases) から `nullpointerpunch_<version>_all.deb` をダウンロード:

```sh
curl -LO https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases/download/v1.0.0/nullpointerpunch_1.0.0_all.deb
sudo apt install -y ./nullpointerpunch_1.0.0_all.deb
```

## ソースからビルド

### 依存

- `dpkg-deb`
- `gzip`

### ビルド

```sh
make deb
```

`nullpointerpunch_<version>_all.deb` が生成されます。

### インストール

```sh
make install
```

内部的に `sudo apt install -y ./nullpointerpunch_<version>_all.deb` を実行します。

## アンインストール

```sh
make uninstall
```

または:

```sh
sudo apt remove nullpointerpunch
```

設定ファイルも含めて完全に削除する場合:

```sh
make purge
```

## 使い方

```sh
ぬるぽ              # ｶﾞｯ
ぬるぽ --full       # フル AA 表示
ぬるぽ --version    # バージョン表示
ぬるぽ --help       # ヘルプ表示
man ぬるぽ          # マニュアル
```

## Release の出し方（メンテナ向け）

1. `bin/ぬるぽ` の `VERSION` を更新
2. 変更をコミット
3. タグを push（`v` プレフィックス必須、VERSION と一致させる）

```sh
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions が `.deb` をビルドし、Release にアセットとして添付します。

## ドキュメント

- [仕様書](docs/SPEC.md)

## ライセンス

MIT License — 詳細は [LICENSE](LICENSE) を参照。
