package com.paulrauff.utils.events 
{
	import flash.events.*;	
	/**
	 * ...
	 * @author Paul
	 */
	public class DataLoadedEvent extends Event 
	{
		public static const FILE_DATA:String = "FILE_DATA";
		public var dataObject:Object;

		public function DataLoadedEvent(dataObj:Object, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			dataObject = dataObj;

			super(type, bubbles, cancelable);
		} 

		public override function clone():Event 
		{ 
			return new DataLoadedEvent(dataObject, type, bubbles, cancelable);
		} 

		public override function toString():String 
		{ 
			return formatToString("DataLoadedEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
	
}