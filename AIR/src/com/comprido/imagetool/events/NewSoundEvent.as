package com.comprido.imagetool.events 
{
	/**
	 * ...
	 * @author Paul Rauff
	 */
	
	import flash.events.Event;
	import flash.filesystem.*;

	public class NewSoundEvent extends Event 
	{
		public static const SOUND_DATA:String = "SOUND_DATA";
		public var soundFile:File;
		
		public function NewSoundEvent(f:File, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			soundFile = f;

			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new NewSoundEvent(soundFile, type, bubbles, cancelable);
		}
		
		public override function toString():String 
		{ 
			return formatToString(SOUND_DATA, "type", "bubbles", "cancelable", "eventPhase"); 
		}		
	}	
}