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

	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.controller.*;
	import com.comprido.imagetool.events.*;
	import com.comprido.imagetool.relay.Relay;
	import com.comprido.imagetool.view.interfaces.ISection;
	import com.paulrauff.utils.*;
	import fl.controls.*;
	import fl.controls.listClasses.ImageCell;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.*;
	import com.paulrauff.utils.sharedObject.*;
	import fl.data.DataProvider;

	public class IndexView extends BaseView implements ISection
	{		
		private var _tilelist:TileList;
		
		private var _reset_btn:SimpleButton;
		
		private var _size_cmp:NumericStepper;
		private var _font_cmp:NumericStepper;
		private var _history_cmp:ComboBox;
		private var _test_url_btn:Button;
		
		private var _lightbox_mc:MovieClip;
		private var _lightbox_txt:TextField;
		private var _server_txt:TextField;
		
		public function IndexView(c:Controller) 
		{
			super.setC(c, -1, 0);
	
			init();	
		}
		
		private function init():void 
		{
			_save_btn = SimpleButton(Validate.element(save_btn, "save_btn missing"));
			_reset_btn = SimpleButton(Validate.element(reset_btn, "reset_btn missing"));
			
			_size_cmp = NumericStepper(Validate.element(size_cmp, "size_cmp missing"));
			_font_cmp = NumericStepper(Validate.element(font_cmp, "font_cmp missing"));
			
			_history_cmp = ComboBox(Validate.element(history_cmp, "history_cmp missing"));
			_test_url_btn = Button(Validate.element(test_url_btn, "test_url_btn missing"));

			_lightbox_mc = MovieClip(Validate.element(lightbox_mc, "lightbox_mc missing"));
			_lightbox_txt = TextField(Validate.element(_lightbox_mc["lightbox_txt"], "lightbox_txt missing"));
			_server_txt = TextField(Validate.element(server_txt, "_server_txt missing"));
			
			_server_txt.text = _c.getServer();
			
			_c.initDragAndDrop();
			
			if (_tilelist)
			{
				removeChild(_tilelist);	
				_tilelist = null;
			}
			
			
			
			
			
			//http://stackoverflow.com/questions/427971/flash-tilelist-component
			//cell.setStyle('upSkin',BlueBg);
			
			
			
			
			
			
			
			
			
			
			_history_cmp.dataProvider = _c.getXMLHistory();
			_history_cmp.labelField = "id";
			
			_tilelist = new TileList();
			_tilelist.name = "TileHolder";
		
			_tilelist.move(62,62); 
			_tilelist.rowCount = 999; 
			_tilelist.width = Main.TILE_LIST_WIDTH; 
			_tilelist.height = Main.TILE_LIST_HEIGHT;

			_tilelist.setRendererStyle("imagePadding", 0);
			
			_tilelist.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tilelist.verticalScrollPolicy = ScrollPolicy.ON;
			_tilelist.direction = ScrollBarDirection.VERTICAL;
			
			_tilelist.rowHeight = _tilelist.columnWidth = _c.thumbSize; 
			_tilelist.columnCount = _c.numCols(_c.thumbSize);

			addChild(_tilelist);
			
			setChildIndex(_lightbox_mc, numChildren - 1);			
			_lightbox_mc.visible = false;
			
			var len:int = _c.totalSections;
			for (var ii:int = 0; ii < len; ii++ )
			{
				try
				{
					_tilelist.addItem( { label:_c.getSectionName(ii), source:_c.getFileLocation(_c.getSectionID(ii), "img") } );
				}
				catch (error:Error)
				{
					
				}
			}
			
			_tilelist.setRendererStyle("imagePadding", 5);
			
			resizeFont();
			resizeThumbNails();
			initEvents();
			
			_c.initSection();
		}
		
		protected override function initEvents():void
		{
			_tilelist.addEventListener(MouseEvent.MOUSE_DOWN, _c.onTileListMouseDown);
			_tilelist.addEventListener(MouseEvent.MOUSE_UP, _c.onTileListMouseUp);
			
			_test_url_btn.addEventListener(MouseEvent.CLICK, _c.launchUserURL);
			
			_reset_btn.addEventListener(MouseEvent.CLICK, _c.resetCurrentSectionThumbList);
			
			_history_cmp.addEventListener(Event.CHANGE, _c.loadHistoryFile);
			
			_server_txt.addEventListener(Event.CHANGE, _c.setServer);

			_c.relay.addEventListener(Relay.SINGLE_CLICK_TILE, onTileListSingleClick);	
			_c.relay.addEventListener(Relay.DOUBLE_CLICK_TILE, onTileListDoubleClick);	
			_c.relay.addEventListener(Relay.MOUSE_DOWN_TILE, onTileListMouseDown);
			_c.relay.addEventListener(NewBitmapDataEvent.BITMAP_DATA, onImageDropped);	
			_c.relay.addEventListener(Relay.THUMB_SIZE_CHANGE, resizeThumbNails);
			_c.relay.addEventListener(Relay.FONT_SIZE_CHANGE, resizeFont);
			_c.relay.addEventListener(Relay.DISABLE_SAVE, super.disableSave);
			_c.relay.addEventListener(Relay.ENABLE_SAVE, super.enableSave);
			_c.relay.addEventListener(SystemMessageEvent.MESSAGE, SystemMessageEventReceived);

			_size_cmp.addEventListener(Event.CHANGE, _c.thumbnailResize);
			_font_cmp.addEventListener(Event.CHANGE, _c.fontResize);
			addEventListener(MouseEvent.MOUSE_OVER, numericStepperRefresh);
			
			super.initEvents();
		}

		private function resizeFont(event:Event = null):void 
		{
			if (_font_cmp)
			{
				_font_cmp.value = _c.fontSize;
				_font_cmp.textField.text = _c.fontSize.toString();

				var tf:TextFormat = new TextFormat(); 
				tf.font = "Arial"; 
				tf.color = 0x000000; 
				tf.size =  _c.fontSize;
				tf.italic = false; 
				tf.bold = true; 
				tf.underline = false; 
				tf.align = "center"; 
				_tilelist.setRendererStyle("textFormat", tf);
			}
		}
		
		private function resizeThumbNails(event:Event = null):void 
		{
			if (_size_cmp)
			{			
				_size_cmp.value = _c.thumbSize;
				_size_cmp.textField.text = _c.thumbSize.toString();
				
				_tilelist.rowHeight = _tilelist.columnWidth = _c.thumbSize; 
				_tilelist.columnCount = _c.numCols(_c.thumbSize);
			}
		}
		
		/**
		 * Hack to make the numeric values change
		 * @param	event
		 */
		private function numericStepperRefresh(event:Event):void 
		{
			removeEventListener(MouseEvent.MOUSE_OVER, numericStepperRefresh);
			_font_cmp.value = _c.fontSize;
			_size_cmp.value = _c.thumbSize;
		}
		
		protected override function saveAndUpload(event:Event = null):void 
		{
			_lightbox_mc.visible = true;			
			super.saveAndUpload();
			_history_cmp.dataProvider = _c.getXMLHistory();
		}
		
		private function SystemMessageEventReceived(event:SystemMessageEvent):void 
		{			
			_lightbox_mc.visible = (event.message != "ok");
			_lightbox_txt.text = event.message;
		}

		private function onTileListMouseDown(event:TileMouseDownEvent):void 
		{
			var imgCell:ImageCell = event.imageCell;
			imgCell.startDrag();
			
			var id:int = imgCell.listData.index;

		}
		
		private function onTileListSingleClick(event:TileSingleClickEvent):void 
		{
			var imgCell:ImageCell = event.imageCell;
			imgCell.stopDrag();
			var id:int = imgCell.listData.index;

			var tmx:int = _tilelist.mouseX;
			var tmy:int = _tilelist.mouseY;
			
			var newIndex:int = _c.getTileIndexFromXY(tmx, tmy);

			if (newIndex >= _tilelist.length)
			{
				newIndex = _tilelist.length - 1;
			}

			if(newIndex != imgCell.listData.index)
			{				
				//shift the tiles
				_tilelist.removeItemAt(imgCell.listData.index);
				_tilelist.addItemAt( { label:imgCell.label, source:imgCell.source }, newIndex);	
				
				_c.moveSectionData(imgCell.listData.index, newIndex);
			}
		}

		private function onTileListDoubleClick(event:TileDoubleClickEvent):void 
		{
			event.imageCell.stopDrag();
		}
		
		private function onImageDropped(event:NewBitmapDataEvent):void
		{			
			_tilelist.addItem({label:"", source:event.bm});

			var id:Number = _c.getTime();

			_c.writeBitmapToLocalCache(event.bm, id);
			_c.createSection(id);
		}

		public override function destroy():void
		{
			_tilelist.removeEventListener(MouseEvent.MOUSE_DOWN, _c.onTileListMouseDown);
			_tilelist.removeEventListener(MouseEvent.MOUSE_UP, _c.onTileListMouseUp);
			
			_reset_btn.removeEventListener(MouseEvent.CLICK, _c.resetCurrentSectionThumbList);
			
			_c.relay.removeEventListener(Relay.SINGLE_CLICK_TILE, onTileListSingleClick);	
			_c.relay.removeEventListener(Relay.DOUBLE_CLICK_TILE, onTileListDoubleClick);	
			_c.relay.removeEventListener(Relay.MOUSE_DOWN_TILE, onTileListMouseDown);
			_c.relay.removeEventListener(NewBitmapDataEvent.BITMAP_DATA, onImageDropped);	
			_c.relay.removeEventListener(Relay.THUMB_SIZE_CHANGE, resizeThumbNails);
			_c.relay.removeEventListener(Relay.FONT_SIZE_CHANGE, resizeFont);
			_c.relay.removeEventListener(Relay.DISABLE_SAVE, super.disableSave);
			_c.relay.removeEventListener(Relay.ENABLE_SAVE, super.enableSave);
			_c.relay.removeEventListener(SystemMessageEvent.MESSAGE, SystemMessageEventReceived);

			_size_cmp.removeEventListener(Event.CHANGE, _c.thumbnailResize);
			_font_cmp.removeEventListener(Event.CHANGE, _c.fontResize);
			removeEventListener(MouseEvent.MOUSE_OVER, numericStepperRefresh);
			
			if (_tilelist)
			{
				removeChild(_tilelist);	
				_tilelist = null;
			}
			
			super.destroy();
		}
	}

}