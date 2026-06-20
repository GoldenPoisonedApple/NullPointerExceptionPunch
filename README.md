# NullPointerExceptionPunch

ターミナルにもインターネッツが欲しい～！

`ぬるぽ` を実行すると `ｶﾞｯ` と出力されます。

## クイックインストール（GitHub Release）

Debian / Ubuntu 向け。最新版をダウンロードして `apt install` します。

```sh
wget -O /tmp/nullpointerpunch.deb \
  https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases/latest/download/nullpointerpunch_all.deb
sudo apt install -y /tmp/nullpointerpunch.deb
```

`curl` を使う場合:

```sh
curl -fsSLO \
  https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases/latest/download/nullpointerpunch_all.deb
sudo apt install -y ./nullpointerpunch_all.deb
```

## バージョン指定インストール

[Releases](https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases) から特定バージョンを取得:

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

## ドキュメント

- [仕様書](docs/SPEC.md)

## ライセンス

MIT License
