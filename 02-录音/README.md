添加文件
---
把文件  
1. **jsb_platformAPI.h**
2. **jsb_platformAPI.cpp**
3. **PlatformAPI.h**
4. **PlatfromAPI-android.cpp**
5. **PlatfromAPI-ios.mm**
6. **org_cocos2dx_javascript_MP3Encode.h**
7. **org_cocos2dx_javascript_MP3Encode.cpp**

放入项目 **frameworks\runtime-src\Classes** 目录下

引入 **jsb_utils_captureScreen.h** 头文件
---
在项目 **frameworks\runtime-src\Classes\AppDelegate.cpp** 文件里头部引入 **jsb_platformAPI.h**

      #include "jsb_platformAPI.h"

向jsb注册方法
---
在 **AppDelegate.cpp** 的 **bool AppDelegate::applicationDidFinishLaunching()** 方法里添加

      sc->addRegisterCallback(register_jsb_platfromAPI);


打包Android时
---
在项目 **frameworks\runtime-src\proj.android\jni\Android.mk** 文件的 **LOCAL_SRC_FILES** 部引入 **jsb_utils_captureScreen.cpp**

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
      
