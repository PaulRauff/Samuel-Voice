package com.comprido.imagetool.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class RecordingTimerEvent extends Event 
	{
		public var microphoneActivityLevel:Number = 0;
		public var timerCycle:int = 0;
		
		public function RecordingTimerEvent(mal:Number, cycle:int, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			microphoneActivityLevel = mal;
			timerCycle = cycle;
			
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{
			return new RecordingTimerEvent(microphoneActivityLevel, timerCycle, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("RecordingTimerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}