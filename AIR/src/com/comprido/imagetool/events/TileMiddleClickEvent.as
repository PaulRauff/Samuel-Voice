package com.comprido.imagetool.events 
{
	import flash.events.Event;
	import fl.controls.listClasses.ImageCell;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class TileMiddleClickEvent extends Event 
	{
		public var imageCell:ImageCell;
		
		public function TileMiddleClickEvent(imgCell:ImageCell, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			imageCell = imgCell;
			
		} 
		
		public override function clone():Event 
		{ 
			return new TileMiddleClickEvent(imageCell, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TileMiddleClickEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}