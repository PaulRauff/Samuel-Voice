package com.comprido.imagetool.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class SetAddButtonVisibiltyEvent extends Event 
	{
		public var isVisible:Boolean = false;
		
		public function SetAddButtonVisibiltyEvent(vis:Boolean, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			isVisible = vis;
		} 
		
		public override function clone():Event 
		{ 
			return new SetAddButtonVisibiltyEvent(isVisible, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SetAddButtonVisibiltyEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}