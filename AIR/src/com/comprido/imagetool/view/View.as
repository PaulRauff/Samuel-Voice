package com.comprido.imagetool.view
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

	 * View handles display and positioning
	 */

	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.controller.*;
	import com.comprido.imagetool.events.*;
	import com.comprido.imagetool.events.*;
	import com.comprido.imagetool.relay.Relay;
	import fl.controls.ScrollBarDirection;
	import fl.controls.TileList;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;	 
	 
	public class View extends Sprite
	{
		private var _c:Controller;
		private var _currentSection:BaseView;

		public function View()
		{
			//create the controller
			_c = new Controller();
			init();
		}

		private function init():void
		{
			_c.relay.addProtectedEventListener(CreateSectionEvent.NEW_SECTION, createNewSection);
			_c.init();
		}
		
		private function createNewSection(event:CreateSectionEvent):void 
		{
			if (_currentSection)
			{				
				_currentSection.destroy();
				
				Main.getInstance().removeChild(_currentSection);
			}
			
			_currentSection = null;
			
			if(event.section >= 0)
			{				
				_currentSection = new SectionView(event.section, event.page, _c);
			}
			else
			{
				_currentSection = new IndexView(_c);
			}
			
			Main.getInstance().addChild(_currentSection);
		}
	}
}
