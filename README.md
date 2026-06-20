# NullPointerExceptionPunch

ターミナルにもインターネッツが欲しい～！

`ぬるぽ` を実行すると `ｶﾞｯ` と出力されます。

## 依存

- `dpkg-deb`
- `gzip`

## ビルド

```sh
make deb
```

`nullpointerpunch.deb` が生成されます。

## インストール

```sh
sudo dpkg -i nullpointerpunch.deb
```

または:

```sh
make install
```

## 使い方

```sh
ぬるぽ              # ｶﾞｯ
ぬるぽ --full       # フル AA 表示
ぬるぽ --version    # バージョン表示
ぬるぽ --help       # ヘルプ表示
man ぬるぽ          # マニュアル
```

## ライセンス

MIT License — 詳細は [LICENSE](LICENSE) を参照。
