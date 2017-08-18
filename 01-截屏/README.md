## Cocos2d-x-js 截屏功能

把文件`jsb_utils_captureScreen.h` 与 `jsb_utils_captureScreen.cpp` 放入项目`frameworks\runtime-src\Classes`  目录下

在项目 `frameworks\runtime-src\Classes`  目录下的 `AppDelegate.cpp`文件里头部引入`jsb_utils_captureScreen.h`
	> `#include "jsb_utils_captureScreen.h"`

在`AppDelegate.cpp` 的 `bool AppDelegate::applicationDidFinishLaunching()` 方法里添加`sc->addRegisterCallback(register_jsb_captureScreen);` 代码如下：

`
bool AppDelegate::applicationDidFinishLaunching(){
    		sc->addRegisterCallback(register_jsb_captureScreen);
}
` 
