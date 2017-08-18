#include "base/ccConfig.h"
#ifndef __utils_capture_screen_h__
#define __utils_capture_screen_h__

#include "jsapi.h"
#include "jsfriendapi.h"

#ifdef __cplusplus
extern "C" {
#endif

	bool jsb_utils_captureScreen(JSContext *cx, uint32_t argc, jsval *vp);


#ifdef __cplusplus
}
#endif


void register_jsb_captureScreen(JSContext *globalC, JS::HandleObject globalO);

#endif // __sqlite_h__
