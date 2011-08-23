package com.comprido.imagetool.events 
{
	/**
	 * ...
	 * @author Paul Rauff
	 */
	
	import flash.events.Event;
	import flash.display.Bitmap;
	import com.carlcalderon.arthropod.Debug;
	 
	public class NewBitmapDataEvent extends Event 
	{
		public static const BITMAP_DATA:String = "bmData";
		public var bm:Bitmap;
		
		public function NewBitmapDataEvent(bm:Bitmap, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.bm = bm;

			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new NewBitmapDataEvent(bm, type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString(BITMAP_DATA, "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}