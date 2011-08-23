package com.comprido.imagetool.view
{
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

	/**
	 * @author paul.rauff
	 * View handles display and positioning
	 */
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
			_c.relay.addEventListener(CreateSectionEvent.NEW_SECTION, createNewSection);
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
