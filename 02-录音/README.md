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
在项目 *frameworks\runtime-src\Classes\AppDelegate.cpp* 文件头部引入`#include "jsb_platformAPI.h"`

向jsb注册方法
---
在 *frameworks\runtime-src\Classes\AppDelegate.cpp* 的 *bool AppDelegate::applicationDidFinishLaunching()* 方法里添加 `sc->addRegisterCallback(register_jsb_platfromAPI);`

打包Android时
---
### 1. 引入libmp3lame库

把**libmp3lame**整个文件夹放入
> frameworks\cocos2d-x\external

目录里。

### 2. 在项目

> **frameworks\runtime-src\proj.android\jni\Android.mk**

文件的 **LOCAL_SRC_FILES** 属性添加
* **jsb_platformAPI.cpp**
* **PlatfromAPI-android.cpp**
* **org_cocos2dx_javascript_MP3Encode.cpp**

      LOCAL_SRC_FILES := hellojavascript/main.cpp \
                         ../../Classes/AppDelegate.cpp \
                         ../../Classes/jsb_platformAPI.cpp \
                         ../../Classes/PlatfromAPI-android.cpp \
                         ../../Classes/org_cocos2dx_javascript_MP3Encode.cpp 
                         
打包IOS时
---
在项目中引入 **jsb_utils_captureScreen.h** 与 **jsb_utils_captureScreen.cpp** 即可

js中如何调用
---
      //第3个参数为截屏时保存图片的名称
      jsb.captureScreen(function(success,file){
            //success为true时,截屏成功,file为图片路径
            cc.log(success,file);
      },this,"test.jpg");
      
