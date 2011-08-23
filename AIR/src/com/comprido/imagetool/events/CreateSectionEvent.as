package com.comprido.imagetool.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class CreateSectionEvent extends Event 
	{
		public static const NEW_SECTION:String = "NEW_SECTION";
		
		public var section:int = 0;
		public var page:int = 0;
		
		public function CreateSectionEvent(ii:int, pid:int, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			section = ii;
			page = pid;
			
			super(type, bubbles, cancelable);			
		} 
		
		public override function clone():Event 
		{ 
			return new CreateSectionEvent(section, page, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CreateSectionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}		
	}	
}