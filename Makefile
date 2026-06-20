PKG=nullpointerpunch
# ぬるぽのバージョンを取得
# cut -d= -f2: =で分割(-d)して2番目のフィールドを取得(-f2)
# tr -d '"': ダブルクオーテーションを削除(-d)
# .release-please-manifest.json からバージョンを取得
VERSION := $(shell sed -n 's/.*"\.\": "\([^"]*\)".*/\1/p' .release-please-manifest.json)
DEB := $(PKG)_$(VERSION)_all.deb

.PHONY: all
all: deb

# sed "": ストリームエディタ ""内は置換パターン 各行に対して処理を行う
# s/: 置換
# ^Version: .*/ : 行頭(^)から始まるVersionの文字列にマッチ .*は任意の文字列 /置換前パターンの終わり
# Version: $(VERSION) : 置換後のパターン
# ビルド生成物を作成
.PHONY: deb
deb: $(DEB)

# nullpointerpunch_<version>_all.deb が最新かどうかを判定して、古い時だけコマンドを実行
$(DEB):
	mkdir -p build/$(PKG)/DEBIAN build/$(PKG)/usr/bin build/$(PKG)/usr/share/man/man1
	sed "s/^Version: .*/Version: $(VERSION)/" DEBIAN/control > build/$(PKG)/DEBIAN/control
	sed "s/@VERSION@/$(VERSION)/" bin/ぬるぽ > build/$(PKG)/usr/bin/ぬるぽ
	chmod 755 build/$(PKG)/usr/bin/ぬるぽ
	sed "s/@VERSION@/$(VERSION)/" man/ぬるぽ.1 | gzip -9 -c > build/$(PKG)/usr/share/man/man1/ぬるぽ.1.gz
	dpkg-deb --build build/$(PKG) $(DEB)

# システムにインストール
.PHONY: install
install: $(DEB)
	sudo apt install -y ./$(DEB)

# システムからアンインストール
.PHONY: uninstall
uninstall:
	sudo apt remove -y $(PKG)

# システムから完全に削除
.PHONY: purge
purge:
	sudo apt purge -y $(PKG)

# ビルド生成物を削除
.PHONY: clean
clean:
	rm -rf build *.deb
