#include "scripting/js-bindings/manual/cocos2d_specifics.hpp"
#include "cocos2d.h"
#include "PlatformAPI.h"

using namespace cocos2d;

//cx是js引擎的设备上下文指针
//argc是参数数目
//vp是参数值

//////////////////////////////////////////////////////////////////////////
bool jsb_platfromAPI_startAudioRecorder(JSContext* cx, uint32_t argc, jsval* vp)
{
	JSB_PRECONDITION2(argc == 2, cx, false, "Invalid number of arguments");
	JS::CallArgs args = JS::CallArgsFromVp(argc, vp);
	bool ok = true;

	if (JS_TypeOfValue(cx, args[0]) != JSTYPE_FUNCTION) {
		JSB_PRECONDITION2(false, cx, false, "arguments 1 processing Error");
	}

	JS::RootedValue cb(cx);
	JS::RootedObject target(cx);
	cb.set(args[0]);
	target.set(args[1].toObjectOrNull());
	std::shared_ptr<JSFunctionWrapper> func(new JSFunctionWrapper(cx, target, cb));
	std::function<void(EventCustom *event)> arg0;
	auto lambda = [=](EventCustom *event) -> void {
		JSB_AUTOCOMPARTMENT_WITH_GLOBAL_OBJCET
		Director::getInstance()->getEventDispatcher()->removeCustomEventListeners(kAudioRecordEvent);
		tagAudioRecordEvent* eventParam = (tagAudioRecordEvent*)event->getUserData();
		jsval val[2];
		val[0] = std_string_to_jsval(cx, eventParam->filePath);
		val[1] = DOUBLE_TO_JSVAL(eventParam->audioTime);
		JS::RootedValue rval(cx);
		func->invoke(2, val, &rval);
		delete eventParam;
	};
	arg0 = lambda;

    bool ret_val = PlatformAPI::startAudioRecorder(arg0);
	args.rval().setBoolean(ret_val);
	return true;
}

bool jsb_platfromAPI_stopAudioRecorder(JSContext* cx, uint32_t argc, jsval* vp)
{
	JSB_PRECONDITION2(argc == 0, cx, false, "Invalid number of arguments");
	JS::CallArgs args = JS::CallArgsFromVp(argc, vp);

    bool ret_val = PlatformAPI::stopAudioRecorder();
	args.rval().setBoolean(ret_val);
	return true;
}

bool jsb_platfromAPI_cancelAudioRecorder(JSContext* cx, uint32_t argc, jsval* vp)
{
	JSB_PRECONDITION2(argc == 0, cx, false, "Invalid number of arguments");
	JS::CallArgs args = JS::CallArgsFromVp(argc, vp);

    bool ret_val = PlatformAPI::cancelAudioRecorder();
	args.rval().setBoolean(ret_val);
	return true;
}


void register_jsb_platfromAPI(JSContext* cx, JS::HandleObject global)
{
	JS::RootedObject ns(cx);
	get_or_create_js_obj(cx, global, "jsb", &ns);

	JS_DefineFunction(cx, ns, "startAudioRecorder", jsb_platfromAPI_startAudioRecorder, 2, JSPROP_READONLY | JSPROP_PERMANENT | JSPROP_ENUMERATE);
	JS_DefineFunction(cx, ns, "stopAudioRecorder", jsb_platfromAPI_stopAudioRecorder, 0, JSPROP_READONLY | JSPROP_PERMANENT | JSPROP_ENUMERATE);
	JS_DefineFunction(cx, ns, "cancelAudioRecorder", jsb_platfromAPI_cancelAudioRecorder, 0, JSPROP_READONLY | JSPROP_PERMANENT | JSPROP_ENUMERATE);
}


