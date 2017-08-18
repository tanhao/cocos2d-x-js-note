#include "cocos2d.h"
#include "org_cocos2dx_javascript_MP3Encode.h"

#ifdef ANDROID
#include <android/log.h>
#include <libmp3lame/include/lame.h>
#endif

#ifdef ANDROID
#define  LOG_TAG    "org_cocos2dx_javascript_MP3Encode.cpp"
#define  LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#else
#define  LOGD(...) js_log(__VA_ARGS__)
#endif

#ifdef ANDROID
lame_t lame = nullptr;
#define BUFFER_SIZE 4096


/*
* Class:     com_xqlgame_qssz_MP3Encode
* Method:    init
* Signature: (III)V
*/
JNIEXPORT void JNICALL Java_org_cocos2dx_javascript_MP3Encode_init
(JNIEnv * env, jclass, jint channel, jint sampleRate, jint brate)
{
	lame = lame_init();
	lame_set_num_channels(lame, channel);
	lame_set_in_samplerate(lame, sampleRate);
	lame_set_brate(lame, brate);
	lame_set_mode(lame, MONO);
	lame_set_quality(lame, 2);
	lame_init_params(lame);
}

/*
* Class:     com_xqlgame_qssz_MP3Encode
* Method:    destroy
* Signature: ()V
*/
JNIEXPORT void JNICALL Java_org_cocos2dx_javascript_MP3Encode_destroy
(JNIEnv *, jclass)
{
	if (lame) {
		lame_close(lame);
		lame = nullptr;
	}
}
/*
* Class:     com_xqlgame_qssz_MP3Encode
* Method:    encode
* Signature: ([SI)[B
*/
JNIEXPORT jbyteArray JNICALL Java_org_cocos2dx_javascript_MP3Encode_encode
(JNIEnv * env, jclass, jshortArray buffer, jint len)
{
	if (lame == nullptr) {
		return NULL;
	}

	int nb_write = 0;
	uint8_t output[BUFFER_SIZE];

	// 转换为本地数组
	jshort *input = env->GetShortArrayElements(buffer, 0);

	// 压缩mp3
	nb_write = lame_encode_buffer(lame, input, input, len, output, BUFFER_SIZE);

	// 局部引用，创建一个byte数组
	jbyteArray result = env->NewByteArray(nb_write);

	// 给byte数组设置值
	env->SetByteArrayRegion(result, 0, nb_write, (jbyte *)output);

	// 释放本地数组(避免内存泄露)
	env->ReleaseShortArrayElements(buffer, input, 0);

	return result;
}

#endif //ANDROID