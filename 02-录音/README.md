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

放入工程 *frameworks\runtime-src\Classes* 目录里。

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
				   
* 把 *AudioRecorder.java* 与 *MP3Encode.java* 放入 *frameworks\runtime-src\proj.android\src* 目录下你工程相应的包名里。
* 修改 *org_cocos2dx_javascript_MP3Encode.h* 与 *org_cocos2dx_javascript_MP3Encode.cpp* 里3个方法名改为你的工程包名(JNI语法)。

      包名要与MP3Encode.java的包名一样, ”.” 要替换成 "_"  , 还是不懂，请百度JNI语法。  
      
      Java_org_cocos2dx_helloword_MP3Encode_init
      Java_包名(org_cocos2dx_helloword修改成你工程的包名)_类名(MP3Encode)_方法名(init)  
      
      Java_org_cocos2dx_helloword_MP3Encode_destroy
      Java_包名(org_cocos2dx_helloword修改成你工程的包名)_类名(MP3Encode)_方法名(destroy)  
      
      Java_org_cocos2dx_helloword_MP3Encode_encode
      Java_包名(org_cocos2dx_helloword修改成你工程的包名)_类名(MP3Encode)_方法名(encode)

* 修改 *PlatfromAPI-android.cpp* 里的java回调函数 *onAudioRecordEvent* 为你的工程包名(JNI语法,Java通过Jni调用C++代码)。

      //private static native void onAudioRecordEvent(String path, double audioTime);
      包名要与AudioRecorder.java的包名一样, ”.” 要替换成 "_"  , 还是不懂，请百度JNI语法。  
      
      Java_org_cocos2dx_helloword_AudioRecorder_onAudioRecordEvent
      Java_包名(org_cocos2dx_helloword修改成你工程的包名)_类名（AudioRecorder）_方法名(onAudioRecordEvent)

* 把 *frameworks\runtime-src\proj.android\AndroidManifest.xml* 加入录音权限  
`<uses-permission android:name="android.permission.RECORD_AUDIO" />`


打包IOS时
---
* 把 *AudioRecorder.h* , *AudioRecorder.mm* , *libmp3lame\include\lame.h* , *libmp3lame\prebuilt\ios\libmp3lame.a* 四个文件放入 *frameworks\runtime-src\proj.ios_mac\ios* 目录里。
* 右键单击 *Classes* 目录，选择Add Files to "工程名" 导入 *jsb_platformAPI.h* , *jsb_platformAPI.cpp* , *PlatformAPI.h* , *PlatfromAPI-ios.mm* 四个文件。
* 右键单击 *ios* 目录，选择Add Files to "工程名" 导入 *AudioRecorder.h* , *AudioRecorder.mm* , *lame.h* , *libmp3lame.a* 四个文件。
~~* 在 TARGETS > projectName-mobile >  Build Phases > Link Binary With Libraries 导入 *libmp3lame\prebuilt\ios\libmp3lame.a* 库文件。~~
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
