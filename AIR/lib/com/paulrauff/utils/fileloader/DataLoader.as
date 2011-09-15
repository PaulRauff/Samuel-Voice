package com.paulrauff.utils.fileloader 
{
	import flash.events.*;
	import flash.net.*;
	import com.paulrauff.utils.events.*;
	import com.carlcalderon.arthropod.Debug;
		
	/**
	 * ...
	 * @author Paul
	 */
	public class DataLoader extends EventDispatcher 
	{
		private var _urlLoader:URLLoader;
		
		//"text"
		//"binary"
		//"variables"
		public function DataLoader(handleProgress:Boolean = true, format:String = "text") 
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = format;

            configureListeners(_urlLoader, handleProgress);
		}
		
		public function load(url:String):void
		{
            Debug.log("DATA LOADING::"+url);
			
			var request:URLRequest = new URLRequest(url);

			try 
			{
                _urlLoader.load(request);
            } 
			catch (error:Error) 
			{
                Debug.error("Unable to load ["+url+"] in DataLoader");
            }			
		}

		private function configureListeners(dispatcher:IEventDispatcher, handleProgress:Boolean):void 
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);

			if (handleProgress)
			{
				dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			}			
		}

		private function completeHandler(event:Event):void 
		{
			//Debug.log("DataLoader.completeHandler::"+event.target.data);
			
			this.dispatchEvent(new DataLoadedEvent(event.target.data, DataLoadedEvent.FILE_DATA));
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			//Debug.log("DataLoader.httpStatusHandler: " + event);
			this.dispatchEvent(event);
		}

		private function initHandler(event:Event):void 
		{
			//Debug.log("DataLoader.initHandler: " + event);
			this.dispatchEvent(event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			//Debug.error("DataLoader.ioErrorHandler: \n" + event);
			dispatchEvent(event);
		}

		private function openHandler(event:Event):void 
		{
			//Debug.log("DataLoader.openHandler: " + event);
			this.dispatchEvent(event);
		}

		private function progressHandler(event:ProgressEvent):void 
		{
			//Debug.log("DataLoader.progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			this.dispatchEvent(event);
		}

		private function unLoadHandler(event:Event):void 
		{
			//Debug.log("DataLoader.unLoadHandler: " + event);
			this.dispatchEvent(event);
		}
	}

}