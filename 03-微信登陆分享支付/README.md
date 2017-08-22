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
* 把 *Wechat.java* （调微信API封装类）放入 *frameworks\runtime-src\proj.android\src* 目录下你工程相应的包名里。
* 修改 *Wechat.java* 里的 APP_ID 为你的应用从官方网站上就申请到的合法appId
* 修改 *Wechat-android.cpp* 里java回调函数为你的工程包名(JNI语法,Java通过Jni调用C++代码)。

      //public static native void onLoginEvent(boolean success,String token);
      包名要与Wechat.java的包名一样, ”.” 要替换成 "_"  , 还是不懂，请百度JNI语法。  

      Java_org_cocos2dx_helloword_Wechat_onLoginEvent  
      Java_包名(org_cocos2dx_helloword修改成你工程的包名)_类名(Wechat)_方法名(onLoginEvent)

* 在 *frameworks\runtime-src\proj.android\AndroidManifest.xml* 添加必要的权限支持 

      <uses-permission android:name="android.permission.INTERNET"/>
      <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
      <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
      <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
      <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

* 要使你的程序启动后微信终端能响应你的程序，必须在代码中向微信终端注册你的id（可以在程序入口Activity的onCreate回调函数处，或其他合适的地方将你的应用id注册到微信），在工程里的 *AppActivity.java* 文件里添加如下代码：

      @Override
      protected void onCreate(Bundle savedInstanceState) {
      		super.onCreate(savedInstanceState);
      		Wechat.regToWX(this);
      }

* 接收微信的请求及返回值，必须在你的包名相应目录下新建一个wxapi目录，并在该wxapi目录下新增一个WXEntryActivity类，该类继承自Activity（微信强制要求的），把 *WXEntryActivity.java* 放入 *frameworks\runtime-src\proj.android\src* 目录下你工程相应的包名下面的 *wxapi* 目录里。

*  在 *frameworks\runtime-src\proj.android\AndroidManifest.xml* 添加 *WXEntryActivity* 代码如下：

       <activity  android:name="org.cocos2dx.helloword.wxapi.WXEntryActivity"
          android:exported="true"  
          android:label="@string/app_name"
          android:theme="@android:style/Theme.NoTitleBar.Fullscreen">  
       </activity>

* 打包成功后,把生成的apk应用安装到android手机中，然后下载[签名生成工具](https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/Gen_Signature_Android2.apk)签名，然后把生成的签名回填到[微信开放平台](https://open.weixin.qq.com/) > 管理中心 >  选中你的APP查看 > 开发信息 > 修改 > Android 应用 > 应用签名一栏，并且修改应用包名一栏为你工程包名。

* 如有不明白的地方请参考微信官方文档[Android接入指南](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417751808&token=&lang=zh_CN)，[Android微信登陆开发指南](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN)，[Android微信分享与收藏功能开发文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317340&token=&lang=zh_CN)

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
