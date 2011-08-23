package com.comprido.imagetool.view 
{
	import flash.display.*;
	import com.comprido.imagetool.controller.*;
	import flash.events.*;
	import com.comprido.imagetool.relay.Relay;
	import com.carlcalderon.arthropod.Debug;
	
	/**
	 * ...
	 * @author Paul
	 */

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