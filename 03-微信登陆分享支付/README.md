添加文件
---
把文件  
* **jsb_utils_wechat.h**
* **jsb_utils_wechat.cpp**
* **Wechat.h**
* **Wechat-android.cpp**

放入项目 *frameworks\runtime-src\Classes* 目录里。

引入 **jsb_utils_wechat.h** 头文件
---
在文件 *frameworks\runtime-src\Classes\AppDelegate.cpp* 头部引入`#include "jsb_utils_wechat.h"`

向jsb注册方法
---
在 *frameworks\runtime-src\Classes\AppDelegate.cpp* 的 *bool AppDelegate::applicationDidFinishLaunching()* 方法里添加  
`sc->addRegisterCallback(register_jsb_wechat);`

打包Android时
---
* 下载[微信SDK](https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/WeChatSDK_Android221cbf.zip)把 *libs/libammsdk.jar* 放入 *frameworks\runtime-src\proj.android\libs* 目录里。
* eclipse里右键单击工程 选择Build Path中的Configure Build Path... , 选中Libraries这个tab，并通过Add Jars...导入 *frameworks\runtime-src\proj.android\libslibammsdk.jar* 文件。
* 把 *Wechat.java* 放入 *frameworks\runtime-src\proj.android\src* 目录下你项目的包名里。
* 把 *frameworks\runtime-src\proj.android\AndroidManifest.xml* 添加必要的权限支持 

      <uses-permission android:name="android.permission.INTERNET"/>
      <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
      <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
      <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
      <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

* 要使你的程序启动后微信终端能响应你的程序，必须在代码中向微信终端注册你的id（可以在程序入口Activity的onCreate回调函数处，或其他合适的地方将你的应用id注册到微信），在工程里的 *AppActivity.java* 文件里如下代码：。

      @Override
      protected void onCreate(Bundle savedInstanceState) {
      		super.onCreate(savedInstanceState);
      		Wechat.regToWX(this);
      }

* 在 *frameworks\runtime-src\proj.android\jni\Android.mk* 的 *LOCAL_SRC_FILES* 属性添加 *jsb_platformAPI.cpp*，*PlatfromAPI-android.cpp*，*org_cocos2dx_javascript_MP3Encode.cpp* 三个文件。 

      LOCAL_SRC_FILES := hellojavascript/main.cpp \
                       ../../Classes/AppDelegate.cpp \ 
                       ../../Classes/jsb_platformAPI.cpp \ 
                       ../../Classes/PlatfromAPI-android.cpp \ 
		               ../../Classes/org_cocos2dx_javascript_MP3Encode.cpp 
				   
* 把 *AudioRecorder.java* 与 *MP3Encode.java* 放入 *frameworks\runtime-src\proj.android\src* 目录下你项目的包名里。
* 修改 *org_cocos2dx_javascript_MP3Encode.h* 与 *org_cocos2dx_javascript_MP3Encode.cpp* 里3个方法名字为你的项目包名(JNI语法)。 

      包名要与MP3Encode.java的包名一样, ”.” 要替换成 "_"  , 还是不懂，请百度JNI语法。
      	  Java_org_cocos2dx_helloword_MP3Encode_init
      	  Java_包名(org_cocos2dx_helloword)_类名（MP3Encode）_方法名(init)

* 把 *frameworks\runtime-src\proj.android\AndroidManifest.xml* 加入录音权限  
`<uses-permission android:name="android.permission.RECORD_AUDIO" />`


打包IOS时
---
* 把 *AudioRecorder.h* , *AudioRecorder.mm* , *libmp3lame\include\lame.h* , *libmp3lame\prebuilt\ios\libmp3lame.a* 4个文件放入 *frameworks\runtime-src\proj.ios_mac\ios* 目录里。
* 右击 *Classes* 目录引入 *jsb_platformAPI.h* , *jsb_platformAPI.cpp* , *PlatformAPI.h* , *PlatfromAPI-ios.mm* 四个文件。
* 右击 *ios* 目录引入 *AudioRecorder.h* , *AudioRecorder.mm* , *lame.h*  三个文件。
* 在 TARGETS > projectName-mobile >  Build Phases > Link Binary With Libraries 引入 *libmp3lame\prebuilt\ios\libmp3lame.a* 库文件。
* info.plist 添加一行 Key= *Privacy - Microphone Usage Description* , Type= *String* , Key= *是否同意使用麦克风?*

js中如何调用
---

      //开始录音
      jsb.startAudioRecorder(function(audioFile,audioTime){
      	    //audioFile录音文件路径,audioTime录音时间
      	    cc.log(audioFile,audioTime);
      },this);

      //停止录音
      jsb.stopAudioRecorder();

      //取消录音
      jsb.cancelAudioRecorder();
