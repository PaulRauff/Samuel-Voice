package com.comprido.imagetool.model
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
	
	import flash.events.*;
	import flash.display.*;
	import flash.filesystem.*;
	import com.carlcalderon.arthropod.Debug;

	public class ThumbData
	{
		private var _description:String = "";
		private var _onServer:Boolean = false;

		private var _bitmap:Bitmap;
		
		private var _soundFileLocaton:String = "";
		private var _soundFile:File;
		
		private var _page:int = 0;
		private var _id:Number = 0;
		private var _isShortcut:Boolean = false;
		private var _isCommon:Boolean = false;
		
		public function ThumbData(id:Number)
		{			
			_id = id;
		}
		
		public function get description():String
		{
			return _description;
		}
		
		public function set description(value:String):void
		{
			_description = value;
		}

		public function get soundFileLocaton():String
		{
			return _soundFileLocaton;
		}
		
		public function set soundFileLocaton(value:String):void
		{
			_soundFileLocaton = value;
		}
		
		public function get soundFile():File
		{
			if (!_soundFile)
			{
				var cacheFile:File = getCacheFile("cachedimages/", ".mp3");
				
				if (cacheFile.exists)
				{
					_soundFile = cacheFile;
				}
			}
			
			return _soundFile;
		}
		

		
		public function set soundFile(f:File):void
		{
			f.addEventListener(Event.COMPLETE, onSoundFileLoaded);
			f.addEventListener(IOErrorEvent.IO_ERROR, onSoundFileLoadError);
			f.load();
			
			_soundFile = f;
		}
		
		private function onSoundFileLoaded(event:Event):void 
		{
			var cacheFile:File = getCacheFile("cachedimages/", ".mp3");
			
			var stream:FileStream = new FileStream();
			stream.open(cacheFile, FileMode.WRITE);
			stream.writeBytes(event.target.data);
			stream.close();
		}
		
		private function onSoundFileLoadError(event:IOErrorEvent):void 
		{
			Debug.warning("fail to load "+id+".mp3");
		}
		
		public function get page():int
		{
			return _page;
		}
		
		public function set page(value:int):void
		{
			_page = value;
		}

		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function set bitmap(bm:Bitmap):void 
		{
			_bitmap = bm;
		}
		
		public function get onServer():Boolean 
		{
			return _onServer;
		}
		
		public function set onServer(value:Boolean):void 
		{
			_onServer = value;
		}
		
		public function get id():Number 
		{
			return _id;
		}
		
		public function get isShortcut():Boolean 
		{
			return _isShortcut;
		}
		
		public function set isShortcut(value:Boolean):void 
		{
			_isShortcut = value;
		}
		
		public function get isCommon():Boolean 
		{
			return _isCommon;
		}
		
		public function set isCommon(value:Boolean):void 
		{
			_isCommon = value;
		}
		
		private function getCacheFile(cachePath:String, ext:String):File
		{
			var imageDir:File = File.applicationStorageDirectory.resolvePath(cachePath);
			
			return new File(imageDir.nativePath +File.separator + "" + id + ext);
		}
	}

}