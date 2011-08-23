package com.comprido.imagetool.model
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
	*/
	
	import com.carlcalderon.arthropod.Debug;
	import flash.filesystem.File;
	import flash.utils.*;
	
	public class SectionData 
	{
		private var _sectionName:String = "";
		private var _id:Number = 0;
		
		private var _thumbSize:int = Main.DEFAULT_THUMB_SIZE;
		private var _fontSize:int = Main.DEFAULT_FONT_SIZE;
		private var _currentPage:int = 0;
		
		private var _sectionColour:uint = 0xffffff;
		
		private var _thumbIDList:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
		
		private var _onServer:Boolean = false;

		public function SectionData(id:Number) 
		{
			_id = id;
		}
		
		public function addThumbIDs(pid:int, thumbList:Vector.<Number>):void
		{
			if (_thumbIDList.length < (pid + 1))
			{
				_thumbIDList[pid] = new Vector.<Number>;
			}
			
			for each(var id:Number in thumbList)
			{
				_thumbIDList[pid].push(id);
			}
		}
		
		public function getThumbIDList(pid:int):Vector.<Number>
		{
			if (_thumbIDList.length < (pid + 1))
			{
				_thumbIDList[pid] = new Vector.<Number>;
			}
			
			return _thumbIDList[pid];
		}
		
		public function setThumbIDList(pid:int, thumbIDList:Vector.<Number>):void
		{
			if (_thumbIDList.length < (pid + 1))
			{
				_thumbIDList.length = (pid + 1);
			}
			
			_thumbIDList[pid] = thumbIDList;
		}
		
		public function get sectionName(): String
		{
			return _sectionName;
		}
		
		public function set sectionName(value:String):void 
		{
			var myPattern:RegExp = /'/g;  
			value = value.replace(myPattern, "`");  
			
			_sectionName = value;
		}
		
		public function get thumbSize():int 
		{
			return _thumbSize;
		}
		
		public function set thumbSize(value:int):void 
		{
			_thumbSize = value;
		}
		
		public function get fontSize():int 
		{
			return _fontSize;
		}
		
		public function set fontSize(value:int):void 
		{
			_fontSize = value;
		}
		
		public function get totalPages():int 
		{
			return _thumbIDList.length - 1;
		}
		
		public function getSectionColourHex():String {
			var hex:String = _sectionColour.toString(16);
			
			while (hex.length < 6)
			{
				hex = "0" + hex;
			}
			
			return hex.toUpperCase();
		}

		public function get sectionColour():uint 
		{
			return _sectionColour;
		}
		
		public function set sectionColour(value:uint):void 
		{			
			_sectionColour = value;
		}
		
		public function get currentPage():int 
		{
			return _currentPage;
		}
		
		public function set currentPage(value:int):void 
		{
			_currentPage = value;
		}
		
		public function get id():Number 
		{
			return _id;
		}
		
		public function set id(value:Number):void 
		{
			_id = value;
		}
		
		public function get onServer():Boolean 
		{
			return _onServer;
		}
		
		public function set onServer(value:Boolean):void 
		{
			_onServer = value;
		}
		
		public function destroy():void
		{
			_sectionName = null;
			_id = 0;
			
			_thumbSize = Main.DEFAULT_THUMB_SIZE;
			_fontSize = Main.DEFAULT_FONT_SIZE;
			_currentPage = 0;
			
			_sectionColour = 0xffffff;
			
			_thumbIDList = null;
			
			_onServer = false;	
		}
		
	}

}