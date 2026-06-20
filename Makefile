VERSION=1.0.0
PKG=nullpointerpunch

all: deb

deb:
	mkdir -p build/$(PKG)
	cp -r usr DEBIAN build/$(PKG)/
	mkdir -p build/$(PKG)/usr/share/man/man1
	gzip -9 -c man/ぬるぽ.1 > build/$(PKG)/usr/share/man/man1/ぬるぽ.1.gz
	dpkg-deb --build build/$(PKG)
	mv build/$(PKG).deb $(PKG).deb

install:
	sudo dpkg -i $(PKG).deb

clean:
	rm -rf build *.deb