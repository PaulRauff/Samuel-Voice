package com.comprido.imagetool.events 
{
	import flash.events.Event;
	import fl.controls.listClasses.ImageCell;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class TileSingleClickEvent extends Event 
	{
		public var imageCell:ImageCell;
		
		public function TileSingleClickEvent(imgCell:ImageCell, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			imageCell = imgCell;
			
		} 
		
		public override function clone():Event 
		{ 
			return new TileSingleClickEvent(imageCell, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TileDoubleClickEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}