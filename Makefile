PKG=nullpointerpunch
# ぬるぽのバージョンを取得
# cut -d= -f2: =で分割(-d)して2番目のフィールドを取得(-f2)
# tr -d '"': ダブルクオーテーションを削除(-d)
VERSION := $(shell grep '^VERSION=' bin/ぬるぽ | cut -d= -f2 | tr -d '"')
DEB := $(PKG)_$(VERSION)_all.deb

all: deb

# sed "": ストリームエディタ ""内は置換パターン 各行に対して処理を行う
# s/: 置換
# ^Version: .*/ : 行頭(^)から始まるVersionの文字列にマッチ .*は任意の文字列 /置換前パターンの終わり
# Version: $(VERSION) : 置換後のパターン
deb: $(DEB)

$(DEB):
	mkdir -p build/$(PKG)/DEBIAN build/$(PKG)/usr/bin build/$(PKG)/usr/share/man/man1
	sed "s/^Version: .*/Version: $(VERSION)/" DEBIAN/control > build/$(PKG)/DEBIAN/control
	cp bin/ぬるぽ build/$(PKG)/usr/bin/
	chmod 755 build/$(PKG)/usr/bin/ぬるぽ
	sed "s/@VERSION@/$(VERSION)/" man/ぬるぽ.1 | gzip -9 -c > build/$(PKG)/usr/share/man/man1/ぬるぽ.1.gz
	dpkg-deb --build build/$(PKG) $(DEB)

install: $(DEB)
	sudo apt install -y ./$(DEB)

uninstall:
	sudo apt remove -y $(PKG)

purge:
	sudo apt purge -y $(PKG)

clean:
	rm -rf build *.deb
