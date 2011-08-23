package com.comprido.imagetool.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class SystemMessageEvent extends Event 
	{
		public static const MESSAGE:String  = "MESSAGE";
		public var message:String = "";
		public var duration:int = -1;
		
		public function SystemMessageEvent(msg:String, dur:int, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			message = msg;
			duration = dur;
			
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new SystemMessageEvent(message, duration, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SystemMessageEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}