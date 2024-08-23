# Building the game

Step 1. [Install git-scm](https://git-scm.com/downloads) if you don't have it already.

Step 2. [Install Haxe](https://haxe.org/download/)

Step 3. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/)

Step 4. Run these commands to install the libraries required:

```
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

```

Dependencies for compiling:

## Windows Only

Install Visual Studio Community 2019, and while installing instead of selecting the normal options, only select these components in the 'individual components' instead (or the closest equivalents).

```txt
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows 10 SDK (Latest)
```

## Linux Only

In your package manager, install the following packages:

```sh
sudo apt-get install libvlc-dev
sudo apt-get install libvlccore-dev
sudo apt-get install vlc-bin
sudo apt-get install luajit
```

```sh
sudo pacman -S vlc
sudo pacman -S luajit
```

Step 5. Run `lime test [platform]` in the project directory while replacing '[platform]' with your build target (usually `html5`, `windows`, `linux`, `mac`, or whatever platform you are building for).
