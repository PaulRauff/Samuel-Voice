package com.comprido.imagetool.events 
{
	/**
	 * ...
	 * @author Paul Rauff
	 */
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class FileDroppedEvent extends Event 
	{
		public static const FILE_READY:String = "FILE_READY";
		public var file:File;
		
		public function FileDroppedEvent(file:File, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.file = file;

			super(type, bubbles, cancelable);
		} 

		public override function clone():Event 
		{ 
			return new FileDroppedEvent(file, type, bubbles, cancelable);
		} 

		public override function toString():String 
		{ 
			return formatToString(FILE_READY, "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
	
}