#! /bin/sh
echo Installing all required libraries.

haxelib --skip-dependencies git lime https://github.com/MobilePorting/lime
haxelib --skip-dependencies git openfl https://github.com/MobilePorting/openfl
haxelib --skip-dependencies git flixel https://github.com/swordcubes-grave-of-shite/flixel dev
haxelib --skip-dependencies git flixel-addons https://github.com/swordcubes-grave-of-shite/flixel-addons dev
haxelib --skip-dependencies install flixel-tools
haxelib --skip-dependencies git flixel-ui https://github.com/HaxeFlixel/flixel-ui
haxelib --skip-dependencies git linc_luajit https://github.com/MobilePorting/linc_luajit.git
haxelib --always --skip-dependencies git hscript-improved https://github.com/FNF-CNE-Devs/hscript-improved codename-dev
haxelib --skip-dependencies git scriptless-polymod https://github.com/Vortex2Oblivion/scriptless-polymod
haxelib --skip-dependencies git hxNoise https://github.com/whuop/hxNoise
haxelib --skip-dependencies git hxvlc https://github.com/MobilePorting/hxvlc
haxelib --skip-dependencies git hxdiscord_rpc https://github.com/MobilePorting/hxdiscord_rpc
haxelib --skip-dependencies git fnf-modcharting-tools https://github.com/Vortex2Oblivion/FNF-Modcharting-Tools
haxelib --skip-dependencies git flxanimate https://github.com/Vortex2Oblivion/flxanimate
haxelib --skip-dependencies git thx.core https://github.com/fponticelli/thx.core
haxelib --skip-dependencies git thx.semver https://github.com/fponticelli/thx.semver.git
haxelib --skip-dependencies git jsonpath https://github.com/EliteMasterEric/jsonpath
haxelib --skip-dependencies git jsonpatch https://github.com/EliteMasterEric/jsonpatch
haxelib --skip-dependencies git funkin.vis https://github.com/FunkinCrew/funkVis
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio
haxelib --never --skip-dependencies git hxcpp https://github.com/MobilePorting/hxcpp

echo Finished