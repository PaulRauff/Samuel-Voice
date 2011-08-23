package com.comprido.imagetool.relay
{
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author paul.rauff
	 * Global event switchboard
	 */
	public class Relay extends EventDispatcher
	{
		public static const HELLO_WORLD:String = "HELLO_WORLD";
		static public const NEW_SECTION:String = "NEW_SECTION";
		static public const THUMB_SIZE_CHANGE:String = "THUMB_SIZE_CHANGE";
		static public const FONT_SIZE_CHANGE:String = "FONT_SIZE_CHANGE";
		static public const BG_COLOUR_CHANGE:String = "BG_COLOUR_CHANGE";
		static public const ADD_BUTTON_VISIBILITY_CHANGE:String = "ADD_BUTTON_VISIBILITY_CHANGE";
		static public const SINGLE_CLICK_TILE:String = "SINGLE_CLICK_TILE";
		static public const DOUBLE_CLICK_TILE:String = "DOUBLE_CLICK_TILE";
		static public const ADD_TILE:String = "ADD_TILE";
		static public const MP3_BUTTON_VISIBILITY_CHANGE:String = "MP3_BUTTON_VISIBILITY_CHANGE";
		static public const MOUSE_DOWN_TILE:String = "MOUSE_DOWN_TILE";
		static public const ENABLE_SAVE:String = "ENABLE_SAVE";
		static public const DISABLE_SAVE:String = "DISABLE_SAVE";
		static public const CLOSE_ALERT_BOX:String = "CLOSE_ALERT_BOX";	
		static public const OPEN_ALERT_BOX:String = "OPEN_ALERT_BOX";	
		static public const NEW_THUMB_LIBRARY:String = "NEW_THUMB_LIBRARY";	
		static public const MOUSE_MIDDLE_CLICK_TILE:String = "MOUSE_MIDDLE_CLICK_TILE";
		static public const NEW_SECTION_LIBRARY:String = "NEW_SECTION_LIBRARY";
	}
	
}