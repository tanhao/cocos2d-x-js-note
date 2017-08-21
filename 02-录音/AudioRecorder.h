//
//  AudioRecorder.h
//  liargame
//
//  Created by admin on 2017/7/28.
//  Copyright © 2017年 tanhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorder : NSObject

+(BOOL) startRecorder; //开始录音
+(BOOL) stopRecorder;  //结束录音
+(BOOL) cancelRecorder;//取消录音

@end
