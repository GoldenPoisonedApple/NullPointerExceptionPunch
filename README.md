# NullPointerExceptionPunch

ターミナルにもインターネッツが欲しい～！

`ぬるぽ` を実行すると `ｶﾞｯ` と出力されます。

## Usage

```sh
ぬるぽ              # ｶﾞｯ
ぬるぽ --full       # フル AA 表示
ぬるぽ --version    # バージョン表示
ぬるぽ --help       # ヘルプ表示
man ぬるぽ          # マニュアル
```

## Description
- パッケージ名: `nullpointerpunch`、`apt show nullpointerpunch` で確認
- [ぬるぽ](bin/ぬるぽ): 本体、使用コマンドは `cat`, `echo`, `exit`のみ、/usr/bin/に配置される
- [DEBIAN/control](DEBIAN/control): deb package 情報
- [man/ぬるぽ.1](man/ぬるぽ.1): man page

## Environment
- Debian系

## Installation
```bash
curl -fsSL -o /tmp/nullpointerpunch.deb https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases/latest/download/nullpointerpunch_all.deb
sudo apt install -y /tmp/nullpointerpunch.deb
```
- バージョン指定の場合
```bash
curl -fsSL -o /tmp/nullpointerpunch.deb https://github.com/GoldenPoisonedApple/NullPointerExceptionPunch/releases/download/v1.0.0/nullpointerpunch_1.0.0_all.deb
sudo apt install -y /tmp/nullpointerpunch.deb
```
- リポジトリをcloneした場合
```bash
# Require: dpkg-deb, gzip
# build deb package
make deb
# install deb package
make install
```

## Uninstallation
```bash
# uninstall deb package
sudo apt remove -y nullpointerpunch
# if you want to remove all config files, run:
sudo apt purge -y nullpointerpunch
```
- リポジトリをcloneした場合
```bash
# uninstall deb package
make uninstall
# if you want to remove all config files, run:
make purge
```

## License

[MIT License](LICENSE)
