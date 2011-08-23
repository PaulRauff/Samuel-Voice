package com.comprido.imagetool.model
{
	/**
	 * ...
	 * @author Paul
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