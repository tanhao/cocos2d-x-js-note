//
//  Wechat.m
//  helloword
//
//  Created by administrator on 23/08/2017.
//
//

#import <UIKit/UIKit.h>
#import "AudioRecorder.h"
#import "WechatAPI.h"
#import "Wechat.h"


static NSString *_wechatStateLogin=@"wechat_login";

@implementation Wechat

//返回Wechat实例，单例模式
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static Wechat *instance;
    dispatch_once(&onceToken, ^{
        instance = [[Wechat alloc] init];
    });
    return instance;
}

//分享网页
-(BOOL) shareWebpage:(NSString *) url
               Title:(NSString *) title
         Description:(NSString *) description
        IsTimelineCb:(BOOL) isTimelineCb{
    
    NSLog(@"Wechat.shareWebpage====>url: %@ , title: %@ , description: %@",url,title,description);
    
    if (![WXApi isWXAppInstalled]||![WXApi isWXAppSupportApi]) {
        return false;
    }
    WXMediaMessage * message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"Icon-40.png"]];
    
    WXWebpageObject * webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq * req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    
    req.message = message;
    req.scene = isTimelineCb?WXSceneTimeline:WXSceneSession;
    
    [WXApi sendReq:req];
    return true;
}
//分享图片
-(BOOL) shareImage:(NSString *)imagePath
      IsTimelineCb:(BOOL) isTimelineCb{
    
    NSLog(@"Wechat.shareImage====>imagePath: %@",imagePath);
    
    if (![WXApi isWXAppInstalled]||![WXApi isWXAppSupportApi]) {
        return false;
    }
    UIImage *shareImg = [UIImage imageWithContentsOfFile:imagePath];
    UIImage *scaleImg=[self imageCompressForWidth:shareImg targetWidth:120.0];
    WXMediaMessage *message = [WXMediaMessage message];
    //缩略图ipsicyh
    [message setThumbImage:scaleImg];
    
    WXImageObject *imageObject=[WXImageObject object];
    imageObject.imageData=UIImagePNGRepresentation(shareImg);
    message.mediaObject=imageObject;
    SendMessageToWXReq * req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    
    req.message = message;
    req.scene = isTimelineCb?WXSceneTimeline:WXSceneSession;
    [WXApi sendReq:req];

    return true;
}
//微信登陆
-(BOOL) login{
    
    NSLog(@"Wechat.login====>");
    
    if (![WXApi isWXAppInstalled]||![WXApi isWXAppSupportApi]) {
        return false;
    }
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = _wechatStateLogin;
    [WXApi sendReq:req];
    return true;

}
//图片缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(size,NO,2.0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)onResp:(BaseResp *)resp {
    NSLog(@"onResp=====>>");
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if([_wechatStateLogin isEqualToString:[authResp state]]){
            NSLog(@"login , state: %@  code: %@",authResp.state,authResp.code);
            WechatAPI::onLoginEvent(true, [[authResp code] UTF8String]);
        }
    }
}
@end
