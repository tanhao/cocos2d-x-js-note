# Cocos2d-x-js 截屏功能
###使用方法
---
* 把 `jsb_utils_captureScreen.h` 与 `jsb_utils_captureScreen.cpp` 放入项目 `frameworks\runtime-src\Classes` 目录下。

* 项目 `frameworks\runtime-src\Classes` 目录下 `AppDelegate.cpp` 引入`jsb_utils_captureScreen.h`
	> `#include "jsb_utils_captureScreen.h"`

* `AppDelegate.cpp` 的 `bool AppDelegate::applicationDidFinishLaunching()` 方法添加`sc->addRegisterCallback(register_jsb_captureScreen);`


		bool AppDelegate::applicationDidFinishLaunching(){
    		sc->addRegisterCallback(register_jsb_captureScreen);
    	}

* 