#ifndef __AUDIO_RECORDER_API_H__
#define __AUDIO_RECORDER_API_H__

#include "cocos2d.h"

typedef std::function<void(cocos2d::EventCustom *event)> EventCustomCallback;

static const char kAudioRecordEvent[] = "AudioRecordEvent";

struct tagAudioRecordEvent {
    double audioTime;
    std::string filePath;
};

//////////////////////////////////////////////////////////////////////////
//平台API封装类

class AudioRecorderAPI
{
public:
    //============================================================================
    // 启动录音机
    //============================================================================
    static bool startAudioRecorder(const EventCustomCallback& cb);
    
    //============================================================================
    // 停止录音机
    //============================================================================
    static bool stopAudioRecorder();

    //============================================================================
    // 停止录音机
    //============================================================================
    static bool cancelAudioRecorder();

    //============================================================================
    // IOS 本地回调函数
    //============================================================================
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        static void onAudioRecordEvent(std::string path,double audioTime);
    #endif
    
};

#endif // __sqlite_h__
