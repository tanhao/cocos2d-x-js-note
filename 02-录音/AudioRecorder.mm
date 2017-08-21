//
//  AudioRecorder.m
//  liargame
//
//  Created by admin on 2017/7/28.
//  Copyright © 2017年 tanhao. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AudioRecorder.h"
#import "PlatformAPI.h"
#import "lame.h"

static AVAudioRecorder *_audioRecorder;
static NSString *_audioFilePath;
static NSTimer* _timer;
static AVAudioSession *_audioSession;

@implementation AudioRecorder
//开始录音
+(BOOL) startRecorder
{
    double time1=CACurrentMediaTime();
    //如果还在录音中先关闭
    if (_audioRecorder&&[_audioRecorder isRecording]) {
        [_audioRecorder stop];
    }
    double time2=CACurrentMediaTime();
    NSLog(@"如果还在录音中先关闭:%lf",time2-time1);
    //如果录音文件存在就删除
    if(_audioFilePath){
        [self deleteFileAtPath:_audioFilePath];
    }
    double time3=CACurrentMediaTime();
    NSLog(@"如果录音文件存在就删除:%lf",time3-time2);
    //录音没有初始化就初始化
    if(!_audioRecorder){
        //存放路径
        _audioFilePath=[[NSString alloc] initWithFormat:@"%@/%@.caf", [self getRecordPathUrl],[self getTimestamp]];
        NSURL *url = [NSURL fileURLWithPath:_audioFilePath];
        
        //录音配置
        NSDictionary *settings=[self getAudioSetting];
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:settings error:NULL];
        
    }
    double time4=CACurrentMediaTime();
    NSLog(@"录音配置:%lf",time4-time3);
    if(!_audioSession){
        _audioSession=[AVAudioSession sharedInstance];
    }
    //设置类别,表示该应用同时支持播放和录音
    [_audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    //启动音频会话管理,此时会阻断后台音乐的播放.
    [_audioSession setActive:YES error:nil];
    double time5=CACurrentMediaTime();
    NSLog(@"AVAudioSession设置时间:%lf",time5-time4);
    //创建录音文件，准备录音
    [_audioRecorder prepareToRecord];
    //是否启用录音测量，如果启用录音测量可以获得录音分贝等数据信息
    [_audioRecorder setMeteringEnabled:YES];
    //开始录音
    [_audioRecorder record];
    
    //设置定时检测
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
    
    double time6=CACurrentMediaTime();
    NSLog(@"开始录音:%lf",time6-time5);
    NSLog(@"开始录音总时间:%lf",time6-time1);
    
    return YES;
}
//音量检测
+ (void)detectionVoice
{
    [_audioRecorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];  音量范围0-1
    double volume = pow(10, (0.05 * [_audioRecorder peakPowerForChannel:0]));
    NSLog(@"录音实时音量：%lf  %lf",volume,[_audioRecorder peakPowerForChannel:0]);
}
//停止录音
+(BOOL) stopRecorder
{
    
    double time1=CACurrentMediaTime();
    
    [_timer invalidate];
    //取录音时间
    double audioTime = _audioRecorder.currentTime;
    //录音停止
    [_audioRecorder stop];
    //一定要在录音停止以后再关闭音频会话管理（否则会报错），此时会延续后台音乐播放
    [_audioSession setActive:NO error:nil];
    //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    double time2=CACurrentMediaTime();
    NSLog(@"AVAudioSession设置用时：%lf",time2-time1);
    NSString *audioFileName=[_audioFilePath substringToIndex:[_audioFilePath rangeOfString:@"/"].location];
    NSLog(@"FileName:%@",audioFileName);
    NSLog(@"===>>caf:%@  wq :%@  time:%f",_audioFilePath,[self fileSizeAtPath:_audioFilePath],audioTime);
    
    //压缩转成MP3
    NSString *mp3Path=[self audioCAFtoMP3:_audioFilePath];
    NSLog(@"===>>mp3:%@  size:%@",mp3Path,[self fileSizeAtPath:mp3Path]);
    double time3=CACurrentMediaTime();
    NSLog(@"压缩用时:%lf",time3-time2);
    /*
     [[AVAudioSession sharedInstance]  setActive:YES error:nil];
     AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:mp3Path] error:nil];
     [audioPlayer prepareToPlay];
     audioPlayer.volume = 1;
     [audioPlayer play];
     */
    PlatformAPI::onAudioRecordEvent([mp3Path UTF8String],audioTime);
    NSLog(@"停止录音总时间:%lf",time3-time1);
    return YES;
}
//取消录音
+(BOOL) cancelRecorder{
    [_timer invalidate];
    //录音停止
    [_audioRecorder stop];
    //删除录音文件
    [_audioRecorder deleteRecording];
    //一定要在录音停止以后再关闭音频会话管理（否则会报错），此时会延续后台音乐播放
    [_audioSession setActive:NO error:nil];
    //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小
    [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    return YES;
}
//取得录音文件设置
+(NSDictionary *)getAudioSetting{
    //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    return recordSetting;
}
//根据路径取文件大小
+(NSString *) fileSizeAtPath:(NSString*)filePath{
    NSString *sizeText=nil;
    NSFileManager* manager =[NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        long size= [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
        if (size >= pow(10, 9)) { // size >= 1GB
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        } else { // 1KB > size
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
        
    }
    return sizeText;
}
//根据路删除文件
+(void)deleteFileAtPath:(NSString*)filePath{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //判断录音后本地是否生成录音文件
    BOOL blHave=  [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (blHave) {
        [fileManager removeItemAtPath:filePath error:nil];
        //BOOL isDelete=[fileManager removeItemAtPath:filePath error:nil];
        //NSLog(@"delete:%@||%@",isDelete?@"true":@"false",filePath);
    }
}
//获取转换文件所在文件夹
+(NSString *)getRecordPathUrl{
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSString *recordDir=[str stringByAppendingPathComponent:@"RecordCourse"];
    return str;
}
//获取时间戳用于文件的命名
+(NSString *)getTimestamp{
    NSDate *nowDate=[NSDate date];
    double timestamp=(double)[nowDate timeIntervalSince1970]*1000;
    long nowTimestamp=[[NSNumber numberWithDouble:timestamp] longValue];
    NSString *timestampStr=[NSString stringWithFormat:@"%ld",nowTimestamp];
    return timestampStr;
}
//CAF转换MP3的lame方法
+ (NSString *)audioCAFtoMP3:(NSString *)wavPath {
    
    NSString *cafFilePath = wavPath;
    
    //NSString *mp3FilePath = [NSString stringWithFormat:@"%@.mp3",[NSString stringWithFormat:@"%@",[cafFilePath substringToIndex:cafFilePath.length - 4]]];
    NSString *mp3FilePath = [NSString stringWithFormat:@"%@/%@.mp3",[self getRecordPathUrl],[self getTimestamp]];
    //如果存在就删除
    [self deleteFileAtPath:mp3FilePath];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_set_num_channels(lame,2);//默认为2双通道
        
        lame_set_brate(lame,8);
        lame_set_mode(lame,MONO);
        lame_set_quality(lame,2);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        return mp3FilePath;
    }
}


@end
