package com.comprido.imagetool.events 
{
	import flash.events.Event;
	import flash.display.*;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class TileAddEvent extends Event 
	{
		public var description:String = "";
		public var src:Object;
		public var index:int = 0;
		
		public function TileAddEvent(descr:String, o:Object, idx:int, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
			description = descr;
			src = o;
			index = idx;
		} 
		
		public override function clone():Event 
		{ 
			return new TileAddEvent(description, src, index, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TileAddEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}