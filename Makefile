build: buildapk

# Build apk
buildapk:
	flutter build apk --dart-define=cronetHttpNoPlay=true --target-platform android-arm,android-arm64

builddebugapk:
	flutter build apk --debug --dart-define=cronetHttpNoPlay=true --target-platform android-arm,android-arm64

.PHONY: pg
pg:
	flutter pub get

.PHONY: pu
pu: 
	make clean 
	flutter pub upgrade

.PHONY: clean
clean:
	flutter clean

.PHONY: init
init:
	make clean && make pg

# Makes lint
lint:
	flutter analyze
format:
	dart format . --line-length=120
fix:
	dart fix --apply
ff:	fix format

createScreenshot:
	adb exec-out screencap -p > screen.png

.PHONY: analyze
analyze:
	@echo "Analyzing the code..."
	@dart analyze .
