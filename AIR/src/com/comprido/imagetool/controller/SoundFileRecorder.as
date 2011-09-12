package com.comprido.imagetool.controller 
{
	import com.adobe.audio.format.WAVWriter;
	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.events.LoadProgressEvent;
	import com.comprido.imagetool.events.RecordingTimerEvent;
	import com.comprido.imagetool.relay.Relay;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.*;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.filesystem.*;
	import flash.net.*;
	import fr.kikko.lab.ShineMP3Encoder;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class SoundFileRecorder extends EventDispatcher
	{
		static public const HAS_SOUND_DATA:String = "HAS_SOUND_DATA";
		static public const MICROPHONE_LEVEL:String = "MICROPHONE_LEVEL";
		public const FPS:int = 50;
		
		private var _isRecording:Boolean = false;
		private var _microphone:Microphone;
		private var _soundBytes:ByteArray;
		private var _timer:Timer;
		private var _timerCount:int = 0;
		private var _soundPlayer:SoundFilePlayer;
		
		private var _mp3Encoder:ShineMP3Encoder;

		private var _c:Controller;
		private var _soundURL:String = "";

		public function SoundFileRecorder(c:Controller) 
		{
			_c = c;
			_soundPlayer = new SoundFilePlayer();
		}
		
		public function startRecord(event:MouseEvent):void
		{
			_timerCount = 0;
			startTimer();
			
			_soundBytes = null;
			_soundBytes = new ByteArray();
			
			_microphone = Microphone.getMicrophone(0);
			_microphone.rate = 44;
			
			_isRecording = true;
			_microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicrophoneData);
		}
		
		private function startTimer():void
		{
			_timer = new Timer(1000/FPS, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();			
		}
		
		private function onTimerComplete(event:TimerEvent):void 
		{
			if (_isRecording)
			{
				_timerCount++;
				startTimer();				
				dispatchEvent(new RecordingTimerEvent(_microphone.activityLevel, _timerCount, MICROPHONE_LEVEL));
			}
		}
		
		public function stopRecord(event:MouseEvent):void
		{
			_isRecording = false;
			_microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, onMicrophoneData);
			
			if (_soundBytes.length > 0)
			{
				dispatchEvent(new Event(HAS_SOUND_DATA));
			}
			
			saveFile();
		}
		
		private function onMicrophoneData(event:SampleDataEvent):void
		{
			while (event.data.bytesAvailable)
			{
				var sample:Number = event.data.readFloat();
				_soundBytes.writeFloat(sample);
			}
		}
		
		/**
		 * MP3 Encode
		 */
		protected function saveFile():void
		{
			_c.relay.dispatchEvent(new LoadProgressEvent(0, Relay.LOAD_PROGRESS));
			
			var wavWrite:WAVWriter = new WAVWriter();
			wavWrite.numOfChannels = 1;
			wavWrite.sampleBitRate = 16;
			wavWrite.samplingRate = 44100;

			_soundBytes.position = 0;

			var wav:ByteArray = new ByteArray();
			wavWrite.processSamples(wav, _soundBytes, 44100, 1);

			wav.position = 0;
			_mp3Encoder = new ShineMP3Encoder(wav);
			_mp3Encoder.addEventListener(Event.COMPLETE, mp3EncodeComplete);
			_mp3Encoder.addEventListener(ProgressEvent.PROGRESS, mp3EncodeProgress);
			_mp3Encoder.addEventListener(ErrorEvent.ERROR, mp3EncodeError);

			_mp3Encoder.start();
		}

		private function mp3EncodeProgress(event:ProgressEvent) : void {
			var pct:int = Math.ceil(event.bytesLoaded / event.bytesTotal * 100);
			Debug.log(pct+" = "+event.bytesLoaded +"::"+ event.bytesTotal);
		
			_c.relay.dispatchEvent(new LoadProgressEvent(pct, Relay.LOAD_PROGRESS));
		}

		private function mp3EncodeError(event:ErrorEvent) : void {
			Debug.error(event.text);
		}

		private function mp3EncodeComplete(event : Event) : void {
			_c.relay.dispatchEvent(new LoadProgressEvent(100, Relay.LOAD_PROGRESS));
			
			var sba:ByteArray = _mp3Encoder.mp3Data;

			var sndDir:File = File.applicationStorageDirectory.resolvePath("cachedimages/");
			var cacheFile:File =  new File(sndDir.nativePath +File.separator + "tmp.mp3");

			var stream:FileStream = new FileStream();
			stream.open(cacheFile, FileMode.WRITE);
			stream.writeBytes(sba);
			stream.close();

			_soundURL = cacheFile.url;
		}
		
		public function playSound(event:MouseEvent):void
		{
			if (_soundPlayer)
			{
				_soundPlayer.playSoundFile(_soundURL);
				_soundPlayer.addEventListener(SoundFilePlayer.SOUND_PLAY_COMPLETE, onSoundComplete);
				
				_timerCount = 0;
				startPlaybackTimer();
			}
		}
		
		private function onSoundComplete(event:Event):void 
		{
			_timer.stop();
			_timer.reset();
		}
		
		private function startPlaybackTimer():void
		{
			_timer = new Timer(1000/FPS, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onPlaybackTimerComplete);
			_timer.start();	
		}
		
		private function onPlaybackTimerComplete(event:TimerEvent):void 
		{
			_timerCount++;
			startPlaybackTimer();				
			dispatchEvent(new RecordingTimerEvent(0, _timerCount, MICROPHONE_LEVEL));
		}
	}

}