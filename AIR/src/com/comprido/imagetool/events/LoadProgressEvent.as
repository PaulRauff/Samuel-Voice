package com.comprido.imagetool.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class LoadProgressEvent extends Event 
	{
		public var percent:int = 0;
		
		public function LoadProgressEvent(pct:int, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			percent = pct;
			
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoadProgressEvent(percent, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoadProgressEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}