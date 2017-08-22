#ifndef __WECHAT_H__
#define __WECHAT_H__

#include "cocos2d.h"

typedef std::function<void(cocos2d::EventCustom *event)> EventCustomCallback;

//static const char kWechatShareEvent[] = "WechatShareEvent";
static const char kWechatLoginEvent[] = "WechatLoginEvent";

struct tagWechatLoginEvent {
    bool success;
    std::string token;
};

class Wechat
{
public:
    //============================================================================
    // 分享网页
    //============================================================================
    static bool shareWebpage(const std::string& urlStr,const std::string& title,const std::string& description,const bool& isTimelineCb);
    
    //============================================================================
    // 分享图片
    //============================================================================
    static bool shareImage(const std::string& imagePath,const bool& isTimelineCb);

    //============================================================================
    // 登陆
    //============================================================================
    static bool login(const EventCustomCallback& cb);


    //============================================================================
    // IOS 本地回调函数
    //============================================================================
    /*
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
        static void onAudioRecordEvent(std::string path,double audioTime);
    #endif
    */
};

#endif // __sqlite_h__
