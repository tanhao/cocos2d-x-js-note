添加文件
---
把文件
* **jsb_utils_captureScreen.h**
* **jsb_utils_captureScreen.cpp**

放入项目

> **frameworks\runtime-src\Classes**

目录里。

引入 **jsb_utils_captureScreen.h** 头文件
---
在项目
> **frameworks\runtime-src\Classes\AppDelegate.cpp**

文件里头部引入 **jsb_utils_captureScreen.h**

      #include "jsb_utils_captureScreen.h"

向jsb注册方法
---
在
> **frameworks\runtime-src\Classes\AppDelegate.cpp**

的

> **bool AppDelegate::applicationDidFinishLaunching()**

方法里添加下面代码

      sc->addRegisterCallback(register_jsb_captureScreen);


打包Android时
---
在项目
> **frameworks\runtime-src\proj.android\jni\Android.mk**

文件的

**LOCAL_SRC_FILES** 属性添加 **jsb_utils_captureScreen.cpp**

      LOCAL_SRC_FILES := hellojavascript/main.cpp \
                         ../../Classes/AppDelegate.cpp \
                         ../../Classes/jsb_utils_captureScreen.cpp 
                         
打包IOS时
---
在项目中引入
* **jsb_utils_captureScreen.h**
* **jsb_utils_captureScreen.cpp**

即可。

js中如何调用
---
      //第3个参数为截屏时图片的名称
      jsb.captureScreen(function(success,file){
            //success为true时,截屏成功,file为图片路径
            cc.log(success,file);
      },this,"test.jpg");
