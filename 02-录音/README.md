添加文件
---
把文件  
* **jsb_platformAPI.h**
* **jsb_platformAPI.cpp**
* **PlatformAPI.h**
* **PlatfromAPI-android.cpp**
* **PlatfromAPI-ios.mm**
* **org_cocos2dx_javascript_MP3Encode.h**
* **org_cocos2dx_javascript_MP3Encode.cpp**

放入项目 *frameworks\runtime-src\Classes* 目录里。

引入 **jsb_platformAPI.h** 头文件
---
在文件 *frameworks\runtime-src\Classes\AppDelegate.cpp* 头部引入`#include "jsb_platformAPI.h"`

向jsb注册方法
---
在 *frameworks\runtime-src\Classes\AppDelegate.cpp* 的 *bool AppDelegate::applicationDidFinishLaunching()* 方法里添加  
`sc->addRegisterCallback(register_jsb_platfromAPI);`

打包Android时
---
* 把 *libmp3lame* 整个文件夹放入 *frameworks\cocos2d-x\external* 目录里。
* 在 *frameworks\runtime-src\proj.android\jni\Android.mk* 中引用 *libmp3lame* 库。

      LOCAL_STATIC_LIBRARIES := cocos2d_js_static
      LOCAL_STATIC_LIBRARIES += libmp3_static
      
      LOCAL_EXPORT_CFLAGS := -DCOCOS2D_DEBUG=2 -DCOCOS2D_JAVASCRIPT

      include $(BUILD_SHARED_LIBRARY)

      $(call import-module, scripting/js-bindings/proj.android)
      $(call import-module, libmp3lame/prebuilt/android)

* 在 *frameworks\runtime-src\proj.android\jni\Android.mk* 的 *LOCAL_SRC_FILES* 属性添加 *jsb_platformAPI.cpp*，*PlatfromAPI-android.cpp*，*org_cocos2dx_javascript_MP3Encode.cpp* 三个文件。 

      LOCAL_SRC_FILES := hellojavascript/main.cpp \
                       ../../Classes/AppDelegate.cpp \ 
                       ../../Classes/jsb_platformAPI.cpp \ 
                       ../../Classes/PlatfromAPI-android.cpp \ 
		               ../../Classes/org_cocos2dx_javascript_MP3Encode.cpp 
				   
* 把 *AudioRecorder.java* 与 *MP3Encode.java* 放入 *frameworks\runtime-src\proj.android\src* 目录下你项目的包名里。
* 修改 *org_cocos2dx_javascript_MP3Encode.h* 与 *org_cocos2dx_javascript_MP3Encode.cpp* 里3个方法名字为你的项目包名(JNI语法)。 

      包名要与MP3Encode.java的包名一样, ”.” 要替换成 "_"  , 还是不懂，请百度JNI语法
      	 如：Java_org_cocos2dx_helloword_MP3Encode_init
             	   Java_包名(org_cocos2dx_helloword)_类名（MP3Encode）_方法名(init)

* 把 *frameworks\runtime-src\proj.android\AndroidManifest.xml* 加入录音权限  
`<uses-permission android:name="android.permission.RECORD_AUDIO" />`


打包IOS时
---
在项目中引入 *jsb_utils_captureScreen.h* 与 *jsb_utils_captureScreen.cpp* 即可。

js中如何调用
---
      //第3个参数为截屏时保存图片的名称
      jsb.captureScreen(function(success,file){
            //success为true时,截屏成功,file为图片路径
            cc.log(success,file);
      },this,"test.jpg");
      
