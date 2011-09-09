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
	import fl.controls.NumericStepper;
	import fl.controls.ComboBox;
	import fl.controls.ColorPicker;

	public class BaseView extends Sprite 
	{
		protected var _save_btn:SimpleButton;
		protected var _c:Controller;
		protected var _base:Sprite;
		
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
		
		protected function fixNumericStepper(base:Sprite, childName:String, max:int, min:int, step:int):NumericStepper
		{
			var rns:NumericStepper = new NumericStepper();
			var m:MovieClip = base[childName];
			
			rns.width = m.width;
			rns.height = m.height;
			rns.x = m.x;
			rns.y = m.y;
			
			rns.maximum = max;
			rns.minimum = min;
			rns.stepSize = step;
			
			base.removeChild(m);
			base.addChild(rns);
			
			return rns;
		}
		
		protected function fixComboBox(base:Sprite, childName:String):ComboBox
		{
			var rcb:ComboBox = new ComboBox();
			var m:MovieClip = base[childName];
			
			rcb.width = m.width;
			rcb.height = m.height;
			rcb.x = m.x;
			rcb.y = m.y;
			
			base.removeChild(m);
			base.addChild(rcb);
			
			return rcb;
		}
		
		protected function fixColorPicker(base:Sprite, childName:String):ColorPicker
		{
			var rcp:ColorPicker = new ColorPicker();
			var m:MovieClip = base[childName];
			
			rcp.width = m.width;
			rcp.height = m.height;
			rcp.x = m.x;
			rcp.y = m.y;
			
			base.removeChild(m);
			base.addChild(rcp);
			
			return rcp;
		}

		public function destroy():void
		{
			if(_save_btn)
				_save_btn.removeEventListener(MouseEvent.CLICK, saveAndUpload);
			
			_save_btn = null;
		}
		
	}

}