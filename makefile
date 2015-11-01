
.PHONY: build test unittest nextbuildnr

build: Carthage/Checkouts/SwiftShell/SwiftShell2.xcodeproj
	xcodebuild | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

Carthage/Checkouts/SwiftShell/SwiftShell2.xcodeproj:
	git submodule update --init

unittest:
	xcodebuild test -scheme fenestro-cli
	xcodebuild test -scheme Fenestro

nextbuildnr:
	agvtool next-version -all
