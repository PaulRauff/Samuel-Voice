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