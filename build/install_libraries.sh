#! /bin/sh

echo Installing all required libraries.

haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp
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
haxelib install hxcpp-debug-server
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis useGrig
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio

echo Finished