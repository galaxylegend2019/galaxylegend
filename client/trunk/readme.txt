GL2:

项目svn地址：
https://svn.tap4fun.com/svn/GL2/trunk

external地址，申请只读权限即可
https://svn.tap4fun.com/svn/zsjtestprj/Dev
https://svn.tap4fun.com/svn/common/CI/trunk/AutoBuild
http://svn.tap4fun.com:81/svn/pfsdk

运行方法：

Windows下运行(PC Win7系统)：
1，安装trunk/tools/python-2.7.7.msi，
2，将python安装目录(默认为C:\Python27\)添加到Path环境变量
3，安装VS2013Express，(\\nas.nibirutech.com\Public\Software\For.Win\vs2013.4_dskexp_CHS\)
4，安装Unity4.7.2 (\\nas.nibirutech.com\Public\Software\For.Win\UnitySetup-4.7.2.exe)
5，创建Unity快捷方式，强制在opengl模式下运行，参数为 -force-opengl,如 ("C:\Program Files (x86)\Unity\Editor\Unity.exe" -force-opengl)
6，将trunk\tools\gameswf\externalDll下的所有dll文件，复制到Unity安装目录， 默认为：("C:\Program Files (x86)\Unity\Editor\)
7，如果要编辑graphml状态机，安装trunk\tools\yEd-3.12.2_with-JRE_setup_d9soft.com.zip
8，运行trunk\FlashUIProj\trunk下的buildWin32Res.bat打资源(可能需要关闭Unity才能成功打资源)
   (Win32下只更改data1下的lua文件或automat下的cst与graphml文件，可以不用打资源，Unity能直接读取)
9，使用-force-opengl模式，打开Unity，打开trunk\UnityPrj\GL2\Assets\Scenes\Game_Start.unity场景，
10，将Game窗口分辨率设为1136x640，并且把Game窗口的大小尽量拖到1136x640，flash的显示才正常。
11，在编辑器里直接点击运行，开始调试。


ios下运行(Mac系统)：
1，安装Unity4.7.2 for mac (smb:\\172.20.130.99\UnitySetup)
2，运行trunk/FlashUIProj/trunk下的 python ./grantRight.py 自动处理各文件可执行权限
3，用Unity打开trunk/UnityPrj/GL2/Assets/Scenes/Game_Start.unity，将平台切换到iOS，选菜单Assets -> [GL2]AssetBundle Auto-Packages[STANDALONE_MODE]
4，运行trunk/FlashUIProj/trunk下的 python ./autobuildRes_ios.py 打资源，ios下有变更就必须重打资源
5，用Unity打开trunk/UnityPrj/GL2/Assets/Scenes/Game_Start.unity，将平台切换到iOS，
6，Build
7，如果没有自动上机的话，打开自动生成的Xcode工程，手动编译并上机，最好使用Release配置
8, 可以使用trunk中的 autoBuildGL2.sh 命令来自动执行3 - 6，并生成ipa文件

Android下运行(Win7)：
1，安装Unity4.7.2, python2.7
2，安装Android SDK，Android Studio
3，定义环境变量 ANDROID_HOME = Android SDK路径，例如 D:\Android\sdk
4，定义环境变量 JAVA_HOME = JDK 安装目录 例如：D:\Java\jdk1.7.0_79
5，定义环境变量 NDK_ROOT = NDK 安装目录 例如: D:\Android\android-ndk-r10e
6，定义环境变量 UNITY_HOME = Unity 执行文件目录 例如：C:\Program Files (x86)\Unity\Editor\
7，定义环境变量 GRADLE_HOME = Gradle安装目录，在Android studio中有一个 例如：D:\Android\Android Studio\gradle\gradle-2.4
8，在PATH环境变量中加入 %ANDROID_HOME%\platform-tools;%NDK_ROOT%;%GRADLE_HOME%\bin;%JAVA_HOME%\bin
9，执行GL2/trunk下的 autoBuildGL2Android.py ，Android包打出后默认在 GL2/trunk/UnityPrj/GL2_Android/GL2/build里面


生成Native Plugin(FlashUIProj, swf, lua):

Windows:
1，进入trunk\FlashUIProj\trunk\tools_project\patch目录，
2，python ./patchFiles.py，选择ap, Apply svn patch
3，
4，安装vs2013 express
   (\\nas.nibirutech.com\Public\Software\For.Win\vs2013.4_dskexp_CHS)
5，打开trunk\FlashUIProj\trunk\prj\WindowsVC2010\GameSWFPrject.sln
6，选择GameSWFProjDll项目为启动项目，选择Unity3D_Debug配置，生成(生成dll时必须关闭Unity)
7，生成的GameSWFProjDll.dll直接在trunk\UnityPrj\GL2\Assets\Plugins目录下，打开Unity运行就可以了。
8，生成的Plugins\GameSWFProjDll.*文件，需要提交svn

ios:
1，第一次使用，需要进入trunk/FlashUIProj/trunk, python ./grantRight.py自动设置可执行权限
2，进入trunk/FlashUIProj/trunk/tools_project/patch目录，
3，python ./patchFiles.py，选择ap, Apply svn patch
4，
5，用Xcode打开trunk/FlashUIProj/trunk/prj/iOS/GameswfProject.xcodeproj
6，选择配置Release，生成Target GameswfProj
7，将生成的libGameswfProjLib.a文件复制到trunk/UnityPrj/GL2/Assets/Plugins/iOS目录下，需要提交svn

Android:
1，Mac上第一次使用，需要进入trunk/FlashUIProj/trunk, python ./grantRight.py自动设置可执行权限
2，进入trunk/FlashUIProj/trunk/tools_project/patch目录，
3，python ./patchFiles.py，选择ap, Apply svn patch
4，配置文件是trunk/FlashUIProj/trunk/prj/Android/Engine/jni/Android.mk
5，PC上可能需要装cygwin，需要cmake, make等
6，进入trunk/FlashUIProj/trunk/prj/Android/Engine目录，运行native_build.sh或native_build_debug.sh(也可以直接调这个脚本里的ndk-build命令)
7，如果成功，会生成trunk/FlashUIProj/trunk/prj/Android/Engine/libs/armeabi-v7a/libT4FEngine.so文件，需要提交svn


重要，关于FlashUIProj里的代码更改：
trunk/FlashUIProj/extern/
上面4个文件夹属于svn external，由引擎组管理，不能直接提交，有任何更改，
需要进入trunk/FlashUIProj/trunk/tools_project/patch目录
执行python ./patchFiles.py，选择gp, Get svn patch，
然后确定无误后，提交trunk/FlashUIProj/trunk/tools_project/patch/patchs/*.patch文件

其他文件可以直接提交svn



其他备注
1.运行后的log
   1.2D的所有输出会纪录在 .\UnityPrj\log.txt文件里
2.lua 发送消息给 c# 的方法
    调用 ext.SendMessageToUnity("cmd","arg");
	C#中处理这些消息的地方在 LuaMessageMgr.cs  的 void ReceiveMessage(cmd,arg) 方法里
3 c# 发送消息给lua
    调用 LuaMessageMgr.SendMessage("cmd","arg");

4 Win32下的快速调试：
	Game_Start.unity里的swf2D GameObject有三个选项可以用于Win32下不打相应资源快速调试：
	-- Directly Load Lua  直接load data1下的lua源文件
	-- Prebuild Automat  每次开始前预处理所有的状态机，需要配合Directly Load Lua使用
	-- Directly Load Swf  直接load data2/flash下的swf文件，此选项默认关闭(无法检查打的2D贴图是否正确)，仅限调功能过程中使用，提交svn前必须关闭此功能，打Win32资源，进游戏验证没有问题。
	
黑mac上Jenkins服务器启动方法:
帐号 tap4fun
密码 Tap4fun99
启动Terminal终端
cd /Applications/Jenkins/
java -jar jenkins.war




