@echo off
echo Installing all required libraries.

@echo on
haxelib git hxcpp https://github.com/Vortex2Oblivion/hxcpp-compiled
haxelib install lime
haxelib install openfl
haxelib --never install flixel 
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install flixel-addons
haxelib git linc_luajit https://github.com/Leather128/linc_luajit.git
haxelib git hscript-improved https://github.com/FNF-CNE-Devs/hscript-improved
haxelib git scriptless-polymod https://github.com/swordcube/scriptless-polymod
haxelib git hxNoise https://github.com/whuop/hxNoise
haxelib install hxvlc
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git fnf-modcharting-tools https://github.com/Vortex2Oblivion/FNF-Modcharting-Tools
haxelib git flxanimate https://github.com/Vortex2Oblivion/flxanimate
haxelib git thx.semver https://github.com/fponticelli/thx.semver.git
haxelib git funkin.vis https://github.com/FNF-CNE-Devs/funkVis grig-test
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio
haxelib install hxcpp-debug-server

@echo off
echo Finished