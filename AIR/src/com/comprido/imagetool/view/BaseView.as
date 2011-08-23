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

	 */

	import flash.display.*;
	import com.comprido.imagetool.controller.*;
	import flash.events.*;
	import com.comprido.imagetool.relay.Relay;
	import com.carlcalderon.arthropod.Debug;

	public class BaseView extends Sprite 
	{
		protected var _save_btn:SimpleButton;
		protected var _c:Controller;
		
		public function BaseView() 
		{
			
		}
		
		protected function setC(c:Controller, section:int, page:int):void
		{
			_c = c;
			_c.currentSection = section;
			_c.currentPage = page;
		}
		
		protected function initEvents():void
		{
			_c.relay.addEventListener(Relay.DISABLE_SAVE, disableSave);
			_c.relay.addEventListener(Relay.ENABLE_SAVE, enableSave);
		}
		
		protected function disableSave(event:Event = null):void
		{			
			if (_save_btn)
			{
				_save_btn.enabled = false;
				_save_btn.alpha = 0.5;
				_save_btn.removeEventListener(MouseEvent.CLICK, saveAndUpload);
			}
		}

		protected function enableSave(event:Event = null):void
		{			
			if (_save_btn)
			{
				_save_btn.enabled = true;
				_save_btn.alpha = 1;
				_save_btn.addEventListener(MouseEvent.CLICK, saveAndUpload);
			}
		}
		
		protected function saveAndUpload(event:Event = null):void 
		{
			_c.saveAndUpload();			
		}

		public function destroy():void
		{
			if(_save_btn)
				_save_btn.removeEventListener(MouseEvent.CLICK, saveAndUpload);
			
			_save_btn = null;
		}
		
	}

}