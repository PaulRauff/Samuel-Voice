package com.comprido.imagetool.model 
{
	/**
	 * ...
	 * @author Paul
	 */
	
	
	import com.carlcalderon.arthropod.Debug;
	import com.paulrauff.utils.events.*;
	import com.paulrauff.utils.fileloader.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.filesystem.File;
	import flash.net.*;
	import flash.utils.*;
	import flash.utils.Dictionary;
	import com.comprido.imagetool.events.*;
	import com.comprido.imagetool.relay.Relay;

	public class AssetDownloader extends EventDispatcher
	{
		static public const READY:String = "READY";
		private var _thumbList:Dictionary;
		private var _fileDir:File;
		private var _missingThumbs:Vector.<String>;
		private var _loadingIndex:int = 0;
		private var _serverLocation:String = "";
		private var _relay:Relay;

		public function AssetDownloader(tl:Dictionary, serverLocation:String, relay:Relay) 
		{
			_thumbList = tl;
			_serverLocation = serverLocation;
			_relay = relay;
			init();
		}
		
		private function init():void
		{
			_fileDir = File.applicationStorageDirectory.resolvePath("cachedimages/");
			cleanup();
			_missingThumbs = getMissingFiles();
			downloadCurrentThumb();
		}
		
		private function downloadCurrentThumb():void 
		{
			var pct:Number = Math.floor(_loadingIndex / _missingThumbs.length * 100);
			_relay.dispatchEvent(new LoadProgressEvent(pct, Relay.LOAD_PROGRESS));
			
			var dl:DataLoader = new DataLoader(true, URLLoaderDataFormat.BINARY);
			dl.addEventListener(DataLoadedEvent.FILE_DATA, imageLoadCompleteHandler);
			dl.addEventListener(IOErrorEvent.IO_ERROR, imageLoadIoErrorHandler);
			
			if (_missingThumbs[_loadingIndex].indexOf(".jpg") > 0)
			{
				dl.load(_serverLocation + "1/img/" + _missingThumbs[_loadingIndex]);
			}
			else
			{
				dl.load(_serverLocation + "1/sound/" + _missingThumbs[_loadingIndex]);
			}
		}
		
		private function imageLoadIoErrorHandler(e:Event):void 
		{
			Debug.warning("cannot load "+_missingThumbs[_loadingIndex] +" from server");
			doNextThumb();
		}
		
		private function imageLoadCompleteHandler(event:DataLoadedEvent):void 
		{
			var stream:FileStream = new FileStream();
			
			var filePath:String = _fileDir.nativePath +File.separator + _missingThumbs[_loadingIndex];
			var loadFile:File = new File(filePath);
			
			stream.open(loadFile, FileMode.WRITE);
			stream.writeBytes(ByteArray(event.dataObject));
			stream.close();
			
			doNextThumb();
		}
		
		private function doNextThumb():void
		{
			_loadingIndex++;
			
			if (_loadingIndex < _missingThumbs.length)
			{
				downloadCurrentThumb();
			}
			else
			{
				_relay.dispatchEvent(new LoadProgressEvent(100, Relay.LOAD_PROGRESS));
				dispatchEvent(new Event(AssetDownloader.READY));
			}			
		}
		
		public function getMissingFiles():Vector.<String>
		{
			//get a list of the missing local files
			var missingList:Vector.<String> = new Vector.<String>();

			for each(var td:ThumbData in _thumbList)
			{
				var imgPath:String = _fileDir.nativePath +File.separator + td.id + ".jpg";
				var mp3Path:String = _fileDir.nativePath +File.separator + td.id + ".mp3";
				
				if (!testFile(imgPath))
				{
					missingList.push(td.id + ".jpg");
				}			

				if (!testFile(mp3Path))
				{
					missingList.push(td.id + ".mp3");					
				}
			}
			
			return missingList;
		}
		
		private function cleanup():void
		{
			deleteSpareFiles("jpg");
			deleteSpareFiles("mp3");
		}
		
		private function deleteSpareFiles(ext:String):void
		{	
			var deleteList:Vector.<String>;
			var fileList:Array = _fileDir.getDirectoryListing();
			
			//loop through the contents of the dir
			for each(var f:File in fileList)
			{				
				if (f.extension != ext)
				{
					continue;
				}
				
				var isSpare:Boolean = true;
				
				//loop through the files listed in the xml
				for each(var td:ThumbData in _thumbList)
				{
					var filePath:String = _fileDir.nativePath +File.separator + td.id + "." + ext;
					var testFile:File = new File(filePath);
					
					//if the files are the same name
					if ((td.id + "." + ext) == f.name)
					{
						isSpare = false;
						break;
					}
				}
				
				if (isSpare)
				{
					Debug.log("deleting :: "+f.name);
					f.deleteFile();
				}				
			}
		}
		
		private function testFile(filePath:String):Boolean
		{
			var testFile:File = new File(filePath);
			return testFile.exists;
		}
	}

}