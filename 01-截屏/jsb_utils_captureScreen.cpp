#include "jsb_utils_captureScreen.h"
#include "scripting/js-bindings/manual/cocos2d_specifics.hpp"
#include "base/ccUtils.h"

bool jsb_utils_captureScreen(JSContext *cx, uint32_t argc, jsval *vp)
{
	JSB_PRECONDITION2(argc == 3, cx, false, "Invalid number of arguments");
	JS::CallArgs args = JS::CallArgsFromVp(argc, vp);

	JSB_PRECONDITION2(JS_TypeOfValue(cx, args[0]) == JSTYPE_FUNCTION, cx, false, "arguments 1 processing Error");

	JS::RootedValue cb(cx);
	JS::RootedObject target(cx);
	cb.set(args[0]);
	target.set(args[1].toObjectOrNull());

	bool ok = true;
	std::string arg2;
	ok &= jsval_to_std_string(cx, args[2], &arg2);
	JSB_PRECONDITION2(ok, cx, false, "arguments 3 processing Error");

	std::shared_ptr<JSFunctionWrapper> func(new JSFunctionWrapper(cx, target, cb));
	std::function<void(bool, const std::string&)> callback;
	auto lambda = [=](bool success, const std::string& outputFile) -> void {
		jsval largv[2];
		largv[0] = BOOLEAN_TO_JSVAL(success);
		largv[1] = std_string_to_jsval(cx, outputFile);
		JS::RootedValue rval(cx);
		func->invoke(2, largv, &rval);
	};
	callback = lambda;

	cocos2d::utils::captureScreen(callback, arg2);

	args.rval().setUndefined();

	return true;
}


void register_jsb_captureScreen(JSContext *_cx, JS::HandleObject global)
{
	JS::RootedObject ns(_cx);
	get_or_create_js_obj(_cx, global, "jsb", &ns);
	JS_DefineFunction(_cx, ns, "captureScreen", jsb_utils_captureScreen, 3, JSPROP_READONLY | JSPROP_PERMANENT | JSPROP_ENUMERATE);
}