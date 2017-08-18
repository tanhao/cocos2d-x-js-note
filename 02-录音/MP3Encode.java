package org.cocos2dx.javascript;


public class MP3Encode {
    //初始化编码库
    public static native void init(int channel, int sampleRate, int brate);
    //反初始化
    public static native void destroy();
    //编码处理
    public static native byte[] encode(short[] buffer, int len);
}