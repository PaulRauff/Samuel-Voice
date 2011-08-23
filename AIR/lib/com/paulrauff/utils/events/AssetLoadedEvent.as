package com.paulrauff.utils.events
{
	import com.carlcalderon.arthropod.Debug;

	import flash.display.DisplayObject;
	import flash.events.*;

	public class AssetLoadedEvent extends Event
	{
		public static const FILE_DATA:String = "fileData";

		private var _fileData:DisplayObject;

		public function AssetLoadedEvent(fileData:DisplayObject, type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			Debug.log("onFileLoaded");
			
			super(type,bubbles,cancelable);
			_fileData = fileData;
        }

		public function get fileData():DisplayObject
		{
			return _fileData;
		}

		override public function clone():Event
		{
			return new AssetLoadedEvent(fileData,type,bubbles,cancelable);
		}
	}
}