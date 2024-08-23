@echo off
echo Installing all required libraries.

@echo on
haxelib install lime
haxelib install openfl
haxelib git flixel https://github.com/HaxeFlixel/flixel
haxelib install flixel-tools
haxelib git flixel-ui https://github.com/HaxeFlixel/flixel-ui
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
haxelib git linc_luajit https://github.com/Leather128/linc_luajit.git
haxelib git hscript-improved https://github.com/FNF-CNE-Devs/hscript-improved
haxelib git scriptless-polymod https://github.com/Vortex2Oblivion/scriptless-polymod
haxelib git hxNoise https://github.com/whuop/hxNoise
haxelib install hxvlc
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git fnf-modcharting-tools https://github.com/Vortex2Oblivion/FNF-Modcharting-Tools
haxelib git flxanimate https://github.com/Vortex2Oblivion/flxanimate
haxelib git thx.core https://github.com/fponticelli/thx.core
haxelib git thx.semver https://github.com/fponticelli/thx.semver.git
haxelib git jsonpath https://github.com/EliteMasterEric/jsonpath
haxelib git jsonpatch https://github.com/EliteMasterEric/jsonpatch
haxelib git funkin.vis https://github.com/FNF-CNE-Devs/funkVis grig-test
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio
haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp
haxelib install hxcpp-debug-server

@echo off
echo Finished