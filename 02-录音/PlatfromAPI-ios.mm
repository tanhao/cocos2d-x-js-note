#include "PlatformAPI.h"
#include "AudioRecorder.h"

#ifdef ANDROID
#define  LOG_TAG    "PlatformAPI-ios.cpp"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#else
#define  LOGD(...) js_log(__VA_ARGS__)
#endif

using namespace cocos2d;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)


//////////////////////////////////////////////////////////////////////////
//平台API封装类

//============================================================================
// 启动录音机
//============================================================================
bool PlatformAPI::startAudioRecorder(const EventCustomCallback& cb)
{
	Director::getInstance()->getEventDispatcher()->addCustomEventListener(kAudioRecordEvent, cb);
    return [AudioRecorder startRecorder];
}

//============================================================================
// 停止录音机
//============================================================================
bool PlatformAPI::stopAudioRecorder()
{
    return [AudioRecorder stopRecorder];
}

//============================================================================
// 取消录音机
//============================================================================
bool PlatformAPI::cancelAudioRecorder()
{
    return [AudioRecorder cancelRecorder];
}


//////////////////////////////////////////////////////////////////////////
// IOS 本地回调函数
void PlatformAPI::onAudioRecordEvent(std::string path,double audioTime){
    tagAudioRecordEvent* eventParam = new tagAudioRecordEvent;
    eventParam->filePath = path;
    eventParam->audioTime = audioTime;
    Director::getInstance()->getScheduler()->performFunctionInCocosThread([=]() mutable {
        Director::getInstance()->getEventDispatcher()->dispatchCustomEvent(kAudioRecordEvent, eventParam);
    });
}
#endif //(CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

//////////////////////////////////////////////////////////////////////////
