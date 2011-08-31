package com.paulrauff.utils.fileloader 
{

	/**
	 * @author paulrauff
	 */
	import com.carlcalderon.arthropod.Debug;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import com.paulrauff.utils.events.AssetLoadedEvent;

	public class AssetLoader extends EventDispatcher
	{
		private var _assetLoader:Loader;
		private var _request:URLRequest;
		
		public function AssetLoader(url:String, contentType:String = null, handleProgress:Boolean = true) 
		{
			_assetLoader = new Loader();
			
			configureListeners(_assetLoader.contentLoaderInfo, handleProgress);

			_request = new URLRequest(url);

			if (contentType != null)
			{
				var header:URLRequestHeader = new URLRequestHeader("Content-Type", contentType);
				_request.requestHeaders.push(header);
			}
		}
		
		public function load():void
		{
			_assetLoader.load(_request);
		}
		
		public function unload():void
		{
			_assetLoader.unload();
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
			Debug.log("ImageLoader.completeHandler::"+event.target.content);
			
			this.dispatchEvent(new AssetLoadedEvent(event.target.content, AssetLoadedEvent.FILE_DATA));
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void 
		{
			Debug.log("ImageLoader.httpStatusHandler: " + event);
			this.dispatchEvent(event);
		}

		private function initHandler(event:Event):void 
		{
			Debug.log("ImageLoader.initHandler: " + event);
			this.dispatchEvent(event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			Debug.error("ImageLoader.ioErrorHandler: " + event);
			this.dispatchEvent(event);
		}

		private function openHandler(event:Event):void 
		{
			Debug.log("ImageLoader.openHandler: " + event);
			this.dispatchEvent(event);
		}

		private function progressHandler(event:ProgressEvent):void 
		{
			Debug.log("ImageLoader.progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
			this.dispatchEvent(event);
		}

		private function unLoadHandler(event:Event):void 
		{
			Debug.log("ImageLoader.unLoadHandler: " + event);
			this.dispatchEvent(event);
		}
	}
}
