package com.paulrauff.utils.sharedObject 
{
	import flash.events.NetStatusEvent;
	import com.carlcalderon.arthropod.Debug;

	import flash.net.SharedObject;

	/**
	 * @author paulrauff
	 */
	public class Sharer 
	{
		private var _so:SharedObject;
		
		public function Sharer(soName:String)
		{
			_so = SharedObject.getLocal(soName, "/");
			this.initEvents();
		}
	
		/**
		sets up the events
		**/
		private function initEvents():void
		{
			_so.addEventListener(NetStatusEvent.NET_STATUS, doMessage);
		}
		
		/**
		gets data
		**/
		public function getSOData(soDataName:String) : String
		{
			var sod:String = this._so.data[soDataName];
			
			if(!sod)
				sod = "";
			
			return sod;
		}
	
		/**
		sets data
		**/
		public function setSOData(soDataName:String, soDataValue:String) : void
		{
			Debug.log("write:"+soDataName+" - "+soDataValue);
			_so.data[soDataName] = soDataValue;
			_so.flush();
		}
		
		/**
		sets data
		**/
		public function clearSO():void
		{
			_so.clear();
			_so.flush();
		}
	
		/**
		displays output
		**/
		private function doMessage(event:NetStatusEvent):void
		{
			var msg:String = "SO Message : ";
	
			for(var s:String in event.info)
			{
				msg += "["+s+"] ";
			}
	
			Debug.error(msg);
		}
	
		
		/**
		cleans up
		**/
		public function destroy():void
		{
			_so = null;
		}
	}
}
