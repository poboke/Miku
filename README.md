
# Miku

Miku is a plugin for Xcode. A copy of atom-miku.

说明：这是一个在Xcode里召唤**程序员鼓励师**的插件，[atom-miku](https://github.com/sunqibuhuake/atom-miku)的盗版。

敲代码时Miku会唱歌和跳舞，停止敲代码时Miku的动作就会慢下来。

![image](https://github.com/poboke/Miku/raw/master/Screenshots/about.png)


## Menu

Click the `Plugins` menu, choose the `Miku` sub menu.

点击Xcode的`Plugins`菜单，在`Miku`子菜单里可以选择一些选项。

![image](https://github.com/poboke/Miku/raw/master/Screenshots/menu.jpg)

    "Enable" : 是否启用插件，默认启用
    "Enable Keep Dancing" : 选中后会一直跳舞唱歌，不受打字影响
    "Music Type" : 音乐类型
        "Default 🔈" : 默认模式，跳舞慢动作时音乐播放会变慢
        "Normal  🔊" : 正常模式，跳舞慢动作时音乐播放不变慢
        "Mute    🔇" : 静音模式

## Custom music

Custom music play list

1. Copy the `MikuConfig` directory to `~/MikuConfig`.
2. Put some musics in the `~/MikuConfig` directory.
3. Edit the `~/MikuConfig/MikuConfig.plist` file, add music names to the `MusicNames` array.
4. You can also drag a music onto Miku's body to play.

自定义音乐播放列表

1. 把`MikuConfig`文件夹拷贝到用户目录下，路径为`~/MikuConfig`。
2. 把喜欢的音乐文件放在`~/MikuConfig`里。
3. 编辑`~/MikuConfig/MikuConfig.plist`文件，把音乐名加到`MusicNames`数组里。
4. 你也可以把一首音乐拖到Miku的身上进行播放。

![image](https://github.com/poboke/Miku/raw/master/Screenshots/playlist.jpg)


## Support Xcode versions

- Xcode6
- Xcode7


## Auto install and uninstall

Using [Alcatraz](https://github.com/alcatraz/Alcatraz)


## Manual build and install

- Download source code and open Miku.xcodeproj with Xcode.
- Select "Edit Scheme" and set "Build Configuration" as "Release"
- Build it. It automatically installs the plugin into the correct directory.
- Restart Xcode. (Make sure that the Xcode process is terminated entirely)


## Manual uninstall 

Delete the following directory:
`~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/Miku.xcplugin`


## License

    (The WTFPL)
    
                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                        Version 2, December 2004
    
     Copyright (C) 2015 Jobs (www.poboke.com)
    
     Everyone is permitted to copy and distribute verbatim or modified
     copies of this license document, and changing it is allowed as long
     as the name is changed.
    
                DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
       TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
    
      0. You just DO WHAT THE FUCK YOU WANT TO.

