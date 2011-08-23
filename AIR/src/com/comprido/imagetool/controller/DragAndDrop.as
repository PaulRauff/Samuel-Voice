package com.comprido.imagetool.controller
{
	
	/**
	 * ...
	 * @author ...
	 */

	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.events.FileDroppedEvent;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class DragAndDrop extends EventDispatcher
	{
        public function DragAndDrop()
		{
			init();
		}
			
		//called when app has initialized and is about to display
		private function init():void
		{
			//register for the drag enter event
			Main.getInstance().addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);

			//register for the drag drop event
			Main.getInstance().addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
		}

		//called when the user drags an item into the component area
		private function onDragIn(e:NativeDragEvent):void
		{
			Debug.log("onDragIn");
			
			//check and see if files are being drug in
			if(e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				//get the array of files
				var files:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;

				//make sure only one file is dragged in (i.e. this app doesn't
				//support dragging in multiple files)
				if(files.length <= 2)
				{
					//accept the drag action
					NativeDragManager.acceptDragDrop(Main.getInstance());
				}
			}
		}

		//called when the user drops an item over the component
		private function onDragDrop(e:NativeDragEvent):void
		{
			//get the array of files being dragged into the app
			var arr:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;

			//grab the files file
			if (arr[0])
			{
				dispatchEvent(new FileDroppedEvent(File(arr[0]), FileDroppedEvent.FILE_READY));
			}
			
			if (arr[1])
			{
				dispatchEvent(new FileDroppedEvent(File(arr[1]), FileDroppedEvent.FILE_READY));
			}

			//imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, currentImageLoadError);
		}
	}
	
}