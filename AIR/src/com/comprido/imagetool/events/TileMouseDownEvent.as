package com.comprido.imagetool.events 
{
	import flash.events.Event;
	import fl.controls.listClasses.ImageCell;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class TileMouseDownEvent extends Event 
	{
		public var imageCell:ImageCell;
		
		public function TileMouseDownEvent(imgCell:ImageCell, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			imageCell = imgCell;
			
		} 
		
		public override function clone():Event 
		{ 
			return new TileMouseDownEvent(imageCell, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TileMouseDownEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}