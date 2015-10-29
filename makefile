
.PHONY: build test unittest

build: Carthage/Checkouts/SwiftShell/SwiftShell2.xcodeproj
	xcodebuild | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

Carthage/Checkouts/SwiftShell/SwiftShell2.xcodeproj:
	git submodule update --init

unittest:
	xcodebuild test -scheme fenestro-cli
	xcodebuild test -scheme Fenestro
