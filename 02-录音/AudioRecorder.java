package org.cocos2dx.javascript;

import java.io.File;
import java.io.FileOutputStream;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.AsyncTask;
import android.os.Environment;
import android.util.Log;
import android.widget.AutoCompleteTextView.Validator;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.javascript.MP3Encode;

///////////////////////////////////////////////////////////////////////////

public class AudioRecorder {
	private final static String TAG = AudioRecorder.class.getSimpleName();
	
	private static boolean mIsCancel= false;    //是否取消
    private static boolean mIsRecording = false;    //是否正在录音中
    private static String fileName="";    //录音文件目录
    private static long SPACE = 1000;// 间隔取样时间  
    private static long LAST_TIME=0;
    private static native void onAudioRecordEvent(String path, double audioTime);
    
    //开始录音
    static public boolean startRecorder() {
        if (mIsRecording) return true;

        mIsRecording = true;
        AudioReocrdTask recorder = new AudioReocrdTask();
        recorder.execute("");

        return true;
    }
     
    //停止录音
    static public boolean stopRecorder() {
        mIsRecording = false;
        return true;
    }
    
    //取消录音
    static public boolean cancelRecorder() {
        mIsRecording = false;
        mIsCancel = true;
        return true;
    }
    
    //获取缓存目录
    static private String getCacheDir() {
    	String cachePath = null;
    	if (Environment.MEDIA_MOUNTED.equals(Environment.getExternalStorageState())  
                || !Environment.isExternalStorageRemovable()) {  
            cachePath = Cocos2dxActivity.getContext().getExternalCacheDir().getPath();  
        } else {  
            cachePath = Cocos2dxActivity.getContext().getCacheDir().getPath();  
        }  
        return cachePath;  
    }
    
    // AudioReocrdTask class begin
    public static class AudioReocrdTask extends AsyncTask<String, Void, String> {
        private double mAudioTimeMillis = 0;
        
        //编码配置
        private final int frequency = 11025;
        private final int channelConfiguration = AudioFormat.CHANNEL_IN_MONO;
        private final int audioEncoding = AudioFormat.ENCODING_PCM_16BIT;
        
        //在execute(Params... params)被调用后立即执行，一般用来在执行后台任务前对UI做一些标记。
        @Override
        protected void onPreExecute() {
            mIsRecording = true;
            mIsCancel=false;
            super.onPreExecute();
        }

        //当后台操作结束时，此方法将会被调用，计算结果将做为参数传递到此方法中，直接将结果显示到UI组件上
        @Override
        protected void onPostExecute(String fileName) {
        	mIsRecording = false;
        	if(mIsCancel){
        		//取消删除录音文件
        		File file = new File(fileName);
                if (file.exists()) {
                    file.delete();
                }
        	}else{
        		//没取消回调到C++
        		onAudioRecordEvent(fileName, this.mAudioTimeMillis);
        	}
            super.onPostExecute(fileName);
        }

        @Override
        protected String doInBackground(String... arg0) {
            
            try {
            	//String fileName = Cocos2dxActivity.getContext().getExternalCacheDir().getAbsolutePath();
            	fileName = getCacheDir()+"/"+ System.currentTimeMillis()+".mp3";
                
                File file = new File(fileName);
                if (file.exists()) {
                    file.delete();
                }
                file.createNewFile();

     
                FileOutputStream fos = new FileOutputStream(file);
                int bufferSize = AudioRecord.getMinBufferSize(frequency, channelConfiguration, audioEncoding);
                AudioRecord record = new AudioRecord(MediaRecorder.AudioSource.MIC, frequency, channelConfiguration, audioEncoding, bufferSize);

                short[] buffer = new short[bufferSize];
                record.startRecording();
                
                //初始化编码库audioEncoding参数是双字节，因此brate参数是16位
                MP3Encode.init(channelConfiguration, frequency, audioEncoding * 8);
                
                double beginTime = System.currentTimeMillis();
                
                //进行编码
                while(mIsRecording) {
                    int readSize = record.read(buffer, 0, bufferSize);
                    //计算音量 不需要就注释
                    //detectionVoice(buffer, readSize);
                    byte[] encodeBytes = MP3Encode.encode(buffer, readSize);
                    fos.write(encodeBytes);
                }
               
                //停止录音
                record.stop();
                record.release();
                fos.close();
                MP3Encode.destroy();
               

                this.mAudioTimeMillis = System.currentTimeMillis() - beginTime;

                return fileName;
            }
            catch(Exception e) {
                mIsRecording = false;
                Log.d(TAG, e.getMessage());
            }

            return "";
        }
    }
    // AudioReocrdTask class end
    //计算音量
    protected static void detectionVoice(short[] buffer,int readSize ){
    	//回调间隔space
    	long now=System.currentTimeMillis();
    	if(now-LAST_TIME<SPACE){
    		return;
    	}
    	LAST_TIME=now;
    	
    	
    	//readSize是实际读取的数据长度，一般而言readSize会小于bufferSzie  
    	double sum = 0;
    	//将 buffer 内容取出，进行平方和运算  
        for (int i = 0; i < buffer.length; i++) {
          sum += buffer[i] * buffer[i];
        }
        if (readSize > 0) {
          double amplitude = sum / readSize;
          // 音量范围0-1
          double volume =   Math.log10(amplitude*0.05)/10;  
          Log.i("cocos2d-x debug info","Volume:"+volume);
        }
    }
	
}