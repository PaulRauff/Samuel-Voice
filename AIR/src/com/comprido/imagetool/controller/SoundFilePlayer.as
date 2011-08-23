package com.comprido.imagetool.controller 
{
	/**
	 * ...
	 * @author Paul
	 */
	
	import flash.filesystem.File;
	import flash.media.Sound;    
	import flash.media.SoundChannel;
	import flash.events.*;
	import flash.net.URLRequest;
	import com.carlcalderon.arthropod.Debug;
	 
	public class SoundFilePlayer 
	{
		private var _channel:SoundChannel;
		private var _soundPosition:int = 0;

		public function SoundFilePlayer() 
		{
		}
		
		public function playSoundFile(url:String):void
		{
			var req:URLRequest = new URLRequest(url);
			
			var sound:Sound = new Sound();  
			sound.addEventListener(Event.COMPLETE, onSoundLoaded);  
			sound.addEventListener(IOErrorEvent.IO_ERROR, onSoundFileLoadError);
			sound.load(req);
		}	
		
		private function onSoundFileLoadError(event:IOErrorEvent):void 
		{
			Debug.warning("can't stream mp3 file");
		}

		private function onSoundLoaded(event:Event):void  
        {
			var s:Sound = Sound(event.target); 
			
			if (_channel)
			{
				_soundPosition = _channel.position;
			}
			else
			{
				_soundPosition = 0;
			}
			
			if (_soundPosition > 0)
			{
				stopSound();
			}
			else
			{
				_channel = s.play();	
				_channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			}
		}
		
		private function onPlaybackComplete(event:Event):void
		{
			stopSound();
		}
		
		public function stopSound():void
		{
			if (_channel)
			{
				_channel.stop();
				_channel.removeEventListener(Event.SOUND_COMPLETE, onPlaybackComplete); 
				_channel = null;
				
				_soundPosition = 0;
			}
		}
		
	}

}