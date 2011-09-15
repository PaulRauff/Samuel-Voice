package com.comprido.imagetool.controller 
{
	/**
	 * ...
	 * @author Paul Rauff
	 * @copy Copyright (c) 2011, Paul Rauff
	 *
	 *--------------------------------------------------------------------------
	 * All rights reserved.

 	 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

	 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 *--------------------------------------------------------------------------
	 * http://en.wikipedia.org/wiki/BSD_licenses

	 */
	
	import flash.filesystem.File;
	import flash.media.Sound;    
	import flash.media.SoundChannel;
	import flash.events.*;
	import flash.net.URLRequest;
	import com.carlcalderon.arthropod.Debug;
	 
	public class SoundFilePlayer extends EventDispatcher
	{
		static public const SOUND_PLAY_COMPLETE:String = "SOUND_PLAY_COMPLETE";
		private var _channel:SoundChannel;
		private var _soundPosition:int = 0;

		public function SoundFilePlayer()
		{
		}
		
		public function playSoundFile(url:String):void
		{
			Debug.log(url);
			
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
				_soundPosition = _channel.position+1;
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
				
				dispatchEvent(new Event(SOUND_PLAY_COMPLETE));
				
			}
		}
		
	}

}