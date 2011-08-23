package com.comprido.imagetool.events 
{
	import flash.events.Event;
	import fl.data.DataProvider;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class CreateSectionLibraryEvent extends Event 
	{
		public var dataProvider:DataProvider;
		
		public function CreateSectionLibraryEvent(dp:DataProvider, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			dataProvider = dp;
			
		} 
		
		public override function clone():Event 
		{ 
			return new CreateSectionLibraryEvent(dataProvider, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CreateSectionLibraryEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}