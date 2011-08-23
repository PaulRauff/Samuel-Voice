package com.comprido.imagetool.events 
{
	import flash.events.Event;
	import fl.data.DataProvider;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class CreateThumbLibraryEvent extends Event 
	{
		public var dataProvider:DataProvider;
		
		public function CreateThumbLibraryEvent(dp:DataProvider, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			dataProvider = dp;
			
		} 
		
		public override function clone():Event 
		{ 
			return new CreateThumbLibraryEvent(dataProvider, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CreateThumbLibraryEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}