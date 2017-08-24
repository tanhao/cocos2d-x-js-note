#include "AudioRecorderAPI.h"


#ifdef ANDROID
#define  LOG_TAG    "PlatformAPI-android.cpp"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#else
#define  LOGD(...) js_log(__VA_ARGS__)
#endif

using namespace cocos2d;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

//const char kJavaAppActivityClass[] = "org/cocos2dx/helloword/AppActivity";
const char kJavaAudioRecorderClass[] = "org/cocos2dx/helloword/AudioRecorder";

//////////////////////////////////////////////////////////////////////////
//平台API封装类

//============================================================================
// 启动录音机
//============================================================================
bool AudioRecorderAPI::startAudioRecorder(const EventCustomCallback& cb)
{
	Director::getInstance()->getEventDispatcher()->addCustomEventListener(kAudioRecordEvent, cb);
    
    JniMethodInfo info;
    bool ret = JniHelper::getStaticMethodInfo(info, kJavaAudioRecorderClass, "startRecorder", "()Z");
    if (ret) {
        return info.env->CallStaticBooleanMethod(info.classID, info.methodID);
    }
    return false;
}

//============================================================================
// 停止录音机
//============================================================================
bool AudioRecorderAPI::stopAudioRecorder()
{
    JniMethodInfo info;
    bool ret = JniHelper::getStaticMethodInfo(info, kJavaAudioRecorderClass, "stopRecorder", "()Z");
    if (ret) {
        return info.env->CallStaticBooleanMethod(info.classID, info.methodID);
    }
    return false;
}

//============================================================================
// 取消录音机
//============================================================================
bool AudioRecorderAPI::cancelAudioRecorder()
{
    JniMethodInfo info;
    bool ret = JniHelper::getStaticMethodInfo(info, kJavaAudioRecorderClass, "cancelRecorder", "()Z");
    if (ret) {
        return info.env->CallStaticBooleanMethod(info.classID, info.methodID);
    }
    return false;
}

//////////////////////////////////////////////////////////////////////////
// java 本地回调函数

extern "C"
{   

    //录音回调函数
	JNIEXPORT void JNICALL Java_org_cocos2dx_helloword_AudioRecorder_onAudioRecordEvent(
                                                                             JNIEnv*  env, 
                                                                             jclass thiz, 
                                                                             jstring path, 
                                                                             jdouble audioTime
                                                                             )
    {
		tagAudioRecordEvent* eventParam = new tagAudioRecordEvent;
		eventParam->filePath = JniHelper::jstring2string(path);
		eventParam->audioTime = audioTime;
        Director::getInstance()->getScheduler()->performFunctionInCocosThread([=]() mutable {
			Director::getInstance()->getEventDispatcher()->dispatchCustomEvent(kAudioRecordEvent, eventParam);
        });
    }
}

#endif //(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)

//////////////////////////////////////////////////////////////////////////
