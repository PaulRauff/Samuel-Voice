package com.comprido.imagetool.relay
{
	/**
	 * ...
	 * @author Paul Rauff
	 * @copy Copyright (c) 2011, Paul Rauff
	 *
	 *--------------------------------------------------------------------------
	 * All rights reserved.

 	 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

	 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 *--------------------------------------------------------------------------
	 * http://en.wikipedia.org/wiki/BSD_licenses

	 * Global event switchboard
	 */

	import flash.events.*;
	import com.carlcalderon.arthropod.Debug;

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
		static public const OPEN_SAVE_ALERT_BOX:String = "OPEN_SAVE_ALERT_BOX";
		static public const OPEN_DELETE_ALERT_BOX:String = "OPEN_DELETE_ALERT_BOX";		
		static public const NEW_THUMB_LIBRARY:String = "NEW_THUMB_LIBRARY";	
		static public const MOUSE_MIDDLE_CLICK_TILE:String = "MOUSE_MIDDLE_CLICK_TILE";
		static public const NEW_SECTION_LIBRARY:String = "NEW_SECTION_LIBRARY";
		static public const SET_THUMB_DESCRIPTION:String = "SET_THUMB_DESCRIPTION";
		static public const NEW_IMAGE_BROWSER:String = "NEW_IMAGE_BROWSER";
		static public const CLOSE_IMAGE_BROWSER:String = "CLOSE_IMAGE_BROWSER";
		static public const NEW_SOUND_RECORDER:String = "NEW_SOUND_RECORDER";
		static public const CLOSE_SOUND_RECORDER:String = "CLOSE_SOUND_RECORDER";
		static public const LOAD_PROGRESS:String = "LOAD_PROGRESS";
		
		
		private var _eventList:Array;
		
		public function Relay()
		{
			_eventList = new Array();
		}
		
		/**
		 * Overridden function. Adds events to list for later cleanup.
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference Set to true by default (usually false)
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			_eventList[type] = new Array();
			_eventList[type][0] = type;
			_eventList[type][1] = listener;

			return super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Does not get added to the list of events to clean on reset, has strong reference by default
		 * @param	type
		 * @param	listener
		 * @param	useCapture
		 * @param	priority
		 * @param	useWeakReference
		 */
		public function addProtectedEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			return super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
			
		public override function dispatchEvent(event:Event):Boolean
		{
			return super.dispatchEvent(event);
		}
		
			
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (_eventList[type][0] === listener)
			{
				_eventList[type] = null;
			}
			
			return super.removeEventListener(type, listener, useCapture);
		}
		
		public function reset():void
		{
			for each(var a:Array in _eventList)
			{
				super.removeEventListener(a[0], a[1]);
			}
		}
	}
	
}