添加文件
---
把文件  
* **jsb_utils_wechatAPI.h**
* **jsb_utils_wechatAPI.cpp**
* **WechatAPI.h**
* **WechatAPI-ios.h**
* **WechatAPI-android.cpp**

放入项目 *frameworks\runtime-src\Classes* 目录里。

引入 **jsb_utils_wechatAPI.h** 头文件
---
在文件 *frameworks\runtime-src\Classes\AppDelegate.cpp* 头部引入`#include "jsb_utils_wechatAPI.h"`

向jsb注册方法
---
在 *frameworks\runtime-src\Classes\AppDelegate.cpp* 的 *bool AppDelegate::applicationDidFinishLaunching()* 方法里向JSB注册：

      bool AppDelegate::applicationDidFinishLaunching()
      {
            ScriptingCore* sc = ScriptingCore::getInstance();
            sc->addRegisterCallback(register_jsb_captureScreen);
      }

打包Android时
---
* 在 *frameworks\runtime-src\proj.android\jni\Android.mk* 的 *LOCAL_SRC_FILES* 属性添加 *jsb_utils_wechatAPI.cpp*，*WechatAPI-android.cpp* 二个文件：

      LOCAL_SRC_FILES := hellojavascript/main.cpp \
                       ../../Classes/AppDelegate.cpp \ 
                       ../../Classes/WechatAPI-android.cpp \ 
		               ../../Classes/jsb_utils_wechatAPI.cpp 
				   
* 到[Android资源下载](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419319167&token=&lang=zh_CN)中心下载[微信安卓SDK](https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/WeChatSDK_Android221cbf.zip)把 *libs/libammsdk.jar* 放入 *frameworks\runtime-src\proj.android\libs* 目录里。
* eclipse里右键单击工程 选择Build Path中的Configure Build Path... , 选中Libraries这个tab，并通过Add Jars...导入 *frameworks\runtime-src\proj.android\libslibammsdk.jar* 文件。
* 把 *Wechat.java* （调微信API封装类）放入 *frameworks\runtime-src\proj.android\src* 目录下你工程相应的包名里。
* 修改 *Wechat.java* 里的 APP_ID 为你从官方网站上就申请到的合法appId
* 修改 *WechatAPI-android.cpp* 里java回调函数 *onLoginEvent* 包名为你的工程包名(JNI语法,Java通过Jni调用C++代码)：

      //public static native void onLoginEvent(boolean success,String token);
      包名要与Wechat.java的包名一样, ”.” 要替换成 "_"  , 还是不懂，请百度JNI语法。  

      Java_org_cocos2dx_helloword_Wechat_onLoginEvent  
      Java_包名(org_cocos2dx_helloword修改成你工程的包名)_类名(Wechat)_方法名(onLoginEvent)

* 在 *frameworks\runtime-src\proj.android\AndroidManifest.xml* 添加必要的权限支持：

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
       <!-- android:name里的包名改成你自己工程的包名 -->

* 打包成功后,把生成的apk应用安装到android手机中，然后到[微信资源中心](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419319167&token=&lang=zh_CN)下载[签名生成工具](https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/Gen_Signature_Android2.apk)签名，然后把生成的签名回填到[微信开放平台](https://open.weixin.qq.com/) > 管理中心 >  选中你的APP查看 > 开发信息 > 修改 > Android 应用 > 应用签名一栏，并且修改应用包名一栏为你工程包名。

* 如有不明白的地方请参考微信官方文档[Android接入指南](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417751808&token=&lang=zh_CN)，[微信登陆开发指南](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN)，[Android微信分享与收藏功能开发文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317340&token=&lang=zh_CN)

打包IOS时
---
* 到[iOS资源下载](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419319164&token=&lang=zh_CN)中心下载[微信苹果SDK](https://res.wx.qq.com/open/zh_CN/htmledition/res/dev/download/sdk/WeChatSDK_Android221cbf.zip)，然后解压把整个文件夹放入 *frameworks\runtime-src\proj.ios_mac\ios* 目录里。
* 右键单击 ios 目录，选择Add Files to "工程名" 导入 *WXApi.h* , *WXApiObject.h* , *WechatAuthSDK.h* , *libWeChatSDK.a* 四个文件。
* 右键单击 Classes 目录，选择Add Files to "工程名" 导入 jsb_utils_wechatAPI.h , jsb_utils_wechatAPI.cpp , WechatAPI.h , WechatAPI-ios.mm 四个文件。
* 要使你的程序启动后微信终端能响应你的程序，必须在代码中向微信终端注册你的id。在 *frameworks\runtime-src\proj.ios_mac\ios\AppController.mm* 的 *didFinishLaunchingWithOptions* 函数中向微信注册id）：

      - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
      {
            //向微信注册,注意修改registerApp参数为你从官方网站上就申请到的合法appId
            [WXApi registerApp:@"wx34900d33eaed55b3" enableMTA:NO];
            return YES;
      }

*  在 *frameworks\runtime-src\proj.ios_mac\ios\AppController.mm* 头部导入 *#import "Wechat.h"* 。
*  重写 *frameworks\runtime-src\proj.ios_mac\ios\AppController.mm* 的 *handleOpenURL* 和 *openURL方法：

       -(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
            return[WXApi handleOpenURL:url delegate:[Wechat sharedInstance]];
       }

       -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
            return [WXApi handleOpenURL:url delegate:[Wechat sharedInstance]];
       }

* 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“Build Phases”标签栏的“Link Binary With Libraries“点击添加SystemConfiguration.framework, CoreTelephony.framework, CFNetwork.framework , libz.dylib, libsqlite3.0.dylib, libc++.dylib, Security.framework 。
* 在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“Info”标签栏的“URL type“点击添加，“URL scheme”为你所注册的应用程序id，“identifier”输入“weixin"
* *info.plist* 添加一行 Key= *LSApplicationQueriesSchemes* , Type= *Array* , 再在 *LSApplicationQueriesSchemes* 下面添加一项 Type=*String* , Value=*weixin* 。  
* 如有不明白的地方请参考微信官方文档[iOS接入指南](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN)，[微信登陆开发指南](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN)，[iOS微信分享与收藏功能开发文档](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317332&token=&lang=zh_CN)

js中如何调用
---

      //分享网页
      //参数 1：要分享的网址，2：标题，3：说明，4：是否分享到朋友圈
      var isSuccess=jsb.wechatShareWebpage("this is url","this is title","this is  description",false);

      //分享图片
      //参数 1：图片路径，2：是否分享到朋友圈
      var isSuccess=jsb.wechatShareImage("this is image path",false);

      //微信登陆
      jsb.wechatLogin(function (success,token) {
            //success是否成功，token为微信返回的access_token
            cc.log("Login:",success,token);
      },this);
