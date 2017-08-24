//
//  Wechat.h
//  helloword
//
//  Created by administrator on 23/08/2017.
//
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "WXApi.h"

@interface Wechat : NSObject<WXApiDelegate>

+ (instancetype)sharedInstance;

//分享网页
-(BOOL) shareWebpage:(NSString *) url
               Title:(NSString *) title
         Description:(NSString *) description
        IsTimelineCb:(BOOL) isTimelineCb;

//分享图片
-(BOOL) shareImage:(NSString *)imagePath
      IsTimelineCb:(BOOL) isTimelineCb;

//微信登陆
- (BOOL) login;

//图片缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;


@end
