package com.comprido.imagetool.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class SetMP3ButtonVisibiltyEvent extends Event 
	{
		public var isVisible:Boolean = false;
		
		public function SetMP3ButtonVisibiltyEvent(vis:Boolean, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			isVisible = vis;			
		} 
		
		public override function clone():Event 
		{ 
			return new SetMP3ButtonVisibiltyEvent(isVisible, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SetMP3ButtonVisibiltyEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}