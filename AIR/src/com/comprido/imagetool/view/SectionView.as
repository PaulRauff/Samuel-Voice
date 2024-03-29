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
	import com.comprido.imagetool.model.ThumbData;
	import com.comprido.imagetool.relay.Relay;
	import com.comprido.imagetool.view.interfaces.ISection;
	import com.paulrauff.utils.validate.*;
	import fl.controls.*;
	import fl.controls.listClasses.ImageCell;
	import fl.containers.*;
	import fl.controls.TileList;
	import fl.data.DataProvider;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import com.greensock.*;
	
	public class SectionView extends BaseView implements ISection
	{
		private var _tilelist:TileList;
		private var _libraryTilelist:TileList;
		
		private var _reset_btn:SimpleButton;
		private var _new_page_btn:SimpleButton;
		private var _close_btn:SimpleButton;
		private var _play_mp3_btn:SimpleButton;
		private var _record_btn:SimpleButton;
		private var _add_btn:SimpleButton;
		private var _page_left_btn:SimpleButton;
		private var _page_right_btn:SimpleButton;
		private var _open_folder_btn:SimpleButton;
		private var _library_close_btn:SimpleButton;
		private var _open_shortcut_btn:SimpleButton;
		private var _image_load_btn:SimpleButton;		
		private var _mp3_btn:SimpleButton;
		protected var _section_delete_btn:SimpleButton;
		
		protected var _section_thumb_holder_uil:UILoader;

		private var _bgColour:Sprite;
		private var _imageHolder:Sprite;

		protected var _title_txt:TextField;
		private var _description_txt:TextField;
		
		private var _lightbox_mc:MovieClip;
		private var _lightbox_txt:TextField;

		private var _size_cmp:NumericStepper;
		private var _font_cmp:NumericStepper;

		private var _colour_cmp:ColorPicker;

		private var _descriptionDefaultText:String = "";
		
		private var _alertBox:AlertBox;
		
		private var _imageHolderCoords:Point;
		
		private var _imageBrowser:ImageBrowserView;
		private var _soundRecorder:SoundRecorderView;
		
		[Embed(source="..//..//..//..//..//bin//skin.swf",symbol="SectionViewLib")]
		private var SectionViewSWF:Class;

		public function SectionView(section:int, page:int, c:Controller) 
		{
			super.setC(c, section, page);
			init();
		}
		
		protected function init():void
		{			
			_c.initDragAndDrop();
			
			super.base = new SectionViewSWF();
			addChild(super.base);

			//register components in fla
			////////////////////////////
			_save_btn = SimpleButton(Validate.element(super.base["save_btn"], "save_btn missing"));
			_reset_btn = SimpleButton(Validate.element(super.base["reset_btn"], "reset_btn missing"));
			_new_page_btn = SimpleButton(Validate.element(super.base["new_page_btn"], "new_page_btn missing"));
			_close_btn = SimpleButton(Validate.element(super.base["close_btn"], "close_btn missing"));
			_play_mp3_btn = SimpleButton(Validate.element(super.base["play_mp3_btn"], "play_mp3_btn missing"));
			_record_btn = SimpleButton(Validate.element(super.base["record_btn"], "record_btn missing"));
			_add_btn = SimpleButton(Validate.element(super.base["add_btn"], "add_btn missing"));
			_page_left_btn = SimpleButton(Validate.element(super.base["page_left_btn"], "page_left_btn missing"));
			_page_right_btn = SimpleButton(Validate.element(super.base["page_right_btn"], "page_right_btn missing"));
			_open_folder_btn = SimpleButton(Validate.element(super.base["open_folder_btn"], "open_folder_btn missing"));
			_library_close_btn = SimpleButton(Validate.element(super.base["library_close_btn"], "library_close_btn missing"));
			_open_shortcut_btn = SimpleButton(Validate.element(super.base["open_shortcut_btn"], "open_shortcut_btn missing"));
			_image_load_btn = SimpleButton(Validate.element(super.base["image_load_btn"], "image_load_btn missing"));
			_mp3_btn = SimpleButton(Validate.element(super.base["mp3_btn"], "mp3_btn missing"));
			
			_section_delete_btn = SimpleButton(Validate.element(super.base["section_delete_btn"], "section_delete_btn missing"));

			_section_thumb_holder_uil = UILoader(Validate.element(super.base["section_thumb_holder_uil"], "section_thumb_holder_uil missing"));
		
			_lightbox_mc = MovieClip(Validate.element(super.base["lightbox_mc"], "lightbox_mc missing"));
		
			_lightbox_txt = TextField(Validate.element(_lightbox_mc["lightbox_txt"], "lightbox_txt missing"));
			_title_txt = TextField(Validate.element(super.base["title_txt"], "title_txt missing"));
			_description_txt = TextField(Validate.element(super.base["description_txt"], "description_txt missing"));

			_size_cmp = super.fixNumericStepper(super.base, "size_cmp", 1000, 10, 10);
			_font_cmp = super.fixNumericStepper(super.base, "font_cmp", 48, 8, 1);
			_colour_cmp = super.fixColorPicker(super.base, "colour_cmp");

			//init states etc
			/////////////////

			setSectionImg();			
			
			_description_txt.text = Main.DESCRIPTION_DEFAULT_TEXT;

			_lightbox_txt.text = "working...";

			_play_mp3_btn.visible = false;
			_record_btn.visible = false;
			_mp3_btn.visible = !_play_mp3_btn.visible;
			_add_btn.visible = false;

			_imageHolder = new Sprite();
			super.base.addChild(_imageHolder);
			_imageHolder.x = _image_load_btn.x;
			_imageHolder.y = _image_load_btn.y;

			_imageHolderCoords = new Point(_imageHolder.x, _imageHolder.y);

			if(_c.currentSectionTitle && _c.currentSectionTitle != "")
				_title_txt.text = _c.currentSectionTitle;
			
			_colour_cmp.selectedColor = _c.sectionColour;
			_colour_cmp.showTextField = false;
			_bgColour = new Sprite();
			super.base.addChild(_bgColour);
			changeBGColour();

			super.base.swapChildren(_page_left_btn, _bgColour);
			
			_library_close_btn.visible = false;
			
			resetTileList();
		}
		
		protected function setSectionImg():void 
		{
			_section_thumb_holder_uil.source = _c.getFileLocation(_c.getSectionID(_c.currentSection), "img");
		}

		private function resetTileList(event:MouseEvent = null):void
		{			
			resetTop();

			if (_tilelist)
			{
				super.base.removeChild(_tilelist);	
				_tilelist = null;
			}
			
			_tilelist = new TileList();
			_tilelist.name = "TileHolder";
			
			_tilelist.doubleClickEnabled = true;
			_tilelist.mouseEnabled = true;

			_tilelist.move(62,92); 
			_tilelist.rowCount = 999; 
			_tilelist.width = Main.TILE_LIST_WIDTH; 
			_tilelist.height = Main.TILE_LIST_HEIGHT;

			_tilelist.setRendererStyle("imagePadding", 0);
			
			_tilelist.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tilelist.verticalScrollPolicy = ScrollPolicy.ON;
			_tilelist.scrollPolicy = ScrollPolicy.ON;
			_tilelist.direction = ScrollBarDirection.VERTICAL;
			
			var len:int = _c.currentSectionThumbIDList.length;

			for (var ii:int = 0; ii < len; ii++ )
			{
				var tid:Number = _c.currentSectionThumbIDList[ii];
				var td:ThumbData = _c.getThumbData(tid);
				
				try
				{
					_tilelist.addItem( { label:td.description, source:_c.getFileLocation(td.id, "img")});
				}
				catch (error:Error)
				{
					Debug.error(error);
				}
			}

			super.base.addChild(_tilelist);

			_lightbox_mc.visible = false;
			super.base.setChildIndex(_lightbox_mc, super.base.numChildren - 1);
			super.base.swapChildren(_imageHolder, _tilelist);

			resizeThumbNails();
			resizeFont();
			resetPageArrows();
			initEvents();
		}

		protected override function initEvents():void 
		{
			//register events
			/////////////////
			_play_mp3_btn.addEventListener(MouseEvent.CLICK, _c.onPlaySoundClicked);
			_add_btn.addEventListener(MouseEvent.CLICK, _c.addThumbToPage);
			_reset_btn.addEventListener(MouseEvent.CLICK, _c.resetCurrentSectionThumbList);
			_new_page_btn.addEventListener(MouseEvent.CLICK, _c.createSectionPage);
			_close_btn.addEventListener(MouseEvent.CLICK, _c.closeSectionPage);
			_open_folder_btn.addEventListener(MouseEvent.CLICK, _c.openThumbLibrary);
			_open_shortcut_btn.addEventListener(MouseEvent.CLICK, _c.openShortcutLibrary);
			
			_imageHolder.addEventListener(MouseEvent.CLICK, _c.openImageBrowser);
			_image_load_btn.addEventListener(MouseEvent.CLICK, _c.openImageBrowser);
			_mp3_btn.addEventListener(MouseEvent.CLICK, _c.openSoundRecorder);
			_record_btn.addEventListener(MouseEvent.CLICK, _c.openSoundRecorder);			
			
			_page_right_btn.addEventListener(MouseEvent.CLICK, _c.pageRight);
			_page_left_btn.addEventListener(MouseEvent.CLICK, _c.pageLeft);
			
			_section_delete_btn.addEventListener(MouseEvent.CLICK, _c.promptDeleteCurrentSection);
			
			_size_cmp.addEventListener(Event.CHANGE, _c.thumbnailResize);
			_font_cmp.addEventListener(Event.CHANGE, _c.fontResize);
			_colour_cmp.addEventListener(Event.CHANGE, _c.changeBGColour);

			_description_txt.addEventListener(MouseEvent.MOUSE_DOWN, clearDescriptionText);
			_description_txt.addEventListener(Event.CHANGE, _c.setDescription);

			_title_txt.addEventListener(MouseEvent.MOUSE_DOWN, clearTitleText);
			_title_txt.addEventListener(Event.CHANGE, _c.setTitleText);

			_tilelist.addEventListener(MouseEvent.MOUSE_DOWN, _c.onTileListMouseDown);			
			_tilelist.addEventListener(MouseEvent.MOUSE_UP, _c.onTileListMouseUp);
			_tilelist.addEventListener(MouseEvent.MIDDLE_CLICK, _c.onTileListMiddleClick);
			_tilelist.addEventListener(MouseEvent.RIGHT_CLICK, _c.onTileListRightClick);

			addEventListener(MouseEvent.MOUSE_OVER, numericStepperRefresh);

			_c.relay.addEventListener(Relay.NEW_SECTION_LIBRARY, createSectionLibrary);
			_c.relay.addEventListener(Relay.NEW_THUMB_LIBRARY, createThumbLibrary);
			_c.relay.addEventListener(NewBitmapDataEvent.BITMAP_DATA, onImageDropped);
			_c.relay.addEventListener(SystemMessageEvent.MESSAGE, SystemMessageEventReceived);
			_c.relay.addEventListener(Relay.THUMB_SIZE_CHANGE, resizeThumbNails);
			_c.relay.addEventListener(Relay.FONT_SIZE_CHANGE, resizeFont);
			_c.relay.addEventListener(Relay.BG_COLOUR_CHANGE, changeBGColour);
			_c.relay.addEventListener(Relay.ADD_BUTTON_VISIBILITY_CHANGE, changeAddButtonVisibility);
			_c.relay.addEventListener(Relay.MP3_BUTTON_VISIBILITY_CHANGE, changeMP3ButtonVisibility);
			_c.relay.addEventListener(Relay.SINGLE_CLICK_TILE, onTileListSingleClick);	
			_c.relay.addEventListener(Relay.DOUBLE_CLICK_TILE, onTileListDoubleClick);
			_c.relay.addEventListener(Relay.MOUSE_MIDDLE_CLICK_TILE, onTileListMiddleClick);	
			_c.relay.addEventListener(Relay.MOUSE_DOWN_TILE, onTileListMouseDown);
			_c.relay.addEventListener(Relay.ADD_TILE, addThumbToPage);			
			_c.relay.addEventListener(Relay.OPEN_SAVE_ALERT_BOX, openSaveAlertBox);
			_c.relay.addEventListener(Relay.OPEN_DELETE_ALERT_BOX, openDeleteAlertBox);			
			_c.relay.addEventListener(Relay.CLOSE_ALERT_BOX, closeAlertBox);
			_c.relay.addEventListener(Relay.SET_THUMB_DESCRIPTION, setDescription);
			_c.relay.addEventListener(Relay.NEW_IMAGE_BROWSER, openImageBrowser);
			_c.relay.addEventListener(Relay.CLOSE_IMAGE_BROWSER, closeImageBrowser);
			_c.relay.addEventListener(Relay.NEW_SOUND_RECORDER, openSoundRecorder);
			_c.relay.addEventListener(Relay.CLOSE_SOUND_RECORDER, closeSoundRecorder);			
			
			_tilelist.addEventListener(KeyboardEvent.KEY_DOWN, _c.onKeyPressedDown);

			super.initEvents();
			
			_c.initSection();
		}

		private function setDescription(event:SetThumbDescriptionEvent):void 
		{
			_c.setDescription(null, event.description);
			_description_txt.text = event.description;
		}
		
		
		private function createSectionLibrary(event:CreateSectionLibraryEvent):void 
		{
			createLibrary(event.dataProvider);
			_libraryTilelist.addEventListener(MouseEvent.CLICK, _c.addSectionThumbToPage);
		}
		
		private function createThumbLibrary(event:CreateThumbLibraryEvent):void 
		{
			createLibrary(event.dataProvider);
			_libraryTilelist.addEventListener(MouseEvent.CLICK, _c.addLibraryThumbToPage);
		}
		
		private function createLibrary(dp:DataProvider):void
		{
			if (_libraryTilelist)
			{
				super.base.removeChild(_libraryTilelist);	
				_libraryTilelist = null;
			}
			
			_libraryTilelist = new TileList();
			_libraryTilelist.name = "LibraryHolder";
			
			_libraryTilelist.mouseEnabled = true;

			_libraryTilelist.move(0,600); 
			_libraryTilelist.rowCount = 1; 
			_libraryTilelist.columnCount = 9999;
			_libraryTilelist.width = 1024; 
			_libraryTilelist.height = 150;

			_libraryTilelist.setRendererStyle("imagePadding", 0);
			
			_libraryTilelist.horizontalScrollPolicy = ScrollPolicy.ON;
			_libraryTilelist.verticalScrollPolicy = ScrollPolicy.OFF;
			_libraryTilelist.direction = ScrollBarDirection.HORIZONTAL;
			_libraryTilelist.dataProvider = dp;

			_libraryTilelist.rowHeight = _libraryTilelist.columnWidth = 130; 

			_library_close_btn.visible = true;
			_library_close_btn.y = _libraryTilelist.y - (_library_close_btn.height * 0.7);
			_library_close_btn.addEventListener(MouseEvent.CLICK, closeThumbLibrary);

			super.base.addChild(_libraryTilelist);
			super.base.setChildIndex(_library_close_btn, super.base.numChildren - 1);
		}
		
		private function closeThumbLibrary(event:MouseEvent):void 
		{
			_library_close_btn.removeEventListener(MouseEvent.CLICK, closeThumbLibrary);
			_library_close_btn.visible = false;
			
			if (_libraryTilelist)
			{
				super.base.removeChild(_libraryTilelist);	
				_libraryTilelist = null;
			}
		}

		private function changeAddButtonVisibility(event:SetAddButtonVisibiltyEvent):void 
		{
			_add_btn.visible = event.isVisible;
		}

		private function changeBGColour(event:Event = null):void 
		{
			while (_bgColour.numChildren > 0)
			{
				_bgColour.removeChildAt(0);
			}
			
			_colour_cmp.selectedColor = _c.sectionColour;
			
			var square:Sprite = new Sprite();
			_bgColour.addChild(square);

			square.graphics.lineStyle(0,_c.sectionColour);
			square.graphics.beginFill(_c.sectionColour);
			square.graphics.drawRect(0, 92, 1024, Main.TILE_LIST_HEIGHT);
			square.graphics.endFill();
		}
		
		private function changeMP3ButtonVisibility(event:SetMP3ButtonVisibiltyEvent):void
		{			
			_play_mp3_btn.visible = event.isVisible;
			_record_btn.visible = event.isVisible;
			_mp3_btn.visible = !_play_mp3_btn.visible;	
		}
		
		protected function openSaveAlertBox(event:Event):void
		{
			var btnLabels:Vector.<String> = new < String > ["save and close", "close without saving", "cancel"];
			_alertBox = new AlertBox("you haven't saved!", btnLabels);
			super.base.addChild(_alertBox);
			_alertBox.x = 512 -(_alertBox.width/2);
			_alertBox.y = 384 - (_alertBox.height / 2);
			
			_lightbox_mc.visible = true;
			
			_alertBox.addEventListener(btnLabels[0], saveAndClose, false, 0, true);
			_alertBox.addEventListener(btnLabels[1], _c.openIndex, false, 0, true);
			_alertBox.addEventListener(btnLabels[2], closeAlertBox, false, 0, true);
		}
		
		protected function openDeleteAlertBox(event:Event):void
		{
			var btnLabels:Vector.<String> = new < String > ["WIPE IT!", "cancel"];
			_alertBox = new AlertBox("THIS WILL DELETE THE ENTIRE SECTION.\nAre you sure?", btnLabels);
			super.base.addChild(_alertBox);
			_alertBox.x = 512 -(_alertBox.width/2);
			_alertBox.y = 384 - (_alertBox.height / 2);
			
			_lightbox_mc.visible = true;
			
			_alertBox.addEventListener(btnLabels[0], _c.deleteCurrentSection, false, 0, true);
			_alertBox.addEventListener(btnLabels[1], closeAlertBox, false, 0, true);
		}
		
		protected function closeAlertBox(event:Event = null):void 
		{
			_lightbox_mc.visible = false;
			
			if (_alertBox)
			{
				super.base.removeChild(_alertBox);
				_alertBox = null;
			}
		}
		
		private function saveAndClose(event:Event):void
		{
			_lightbox_mc.visible = true;
			
			_c.relay.removeEventListener(SystemMessageEvent.MESSAGE, SystemMessageEventReceived);
			_c.relay.addEventListener(SystemMessageEvent.MESSAGE, _c.openIndex);
			
			saveAndUpload();
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

		private function resetPageArrows():void 
		{
			_page_left_btn.visible = (_c.currentPage > 0);
			_page_right_btn.visible = (_c.currentPage < _c.totalPages);
		}

		private function resetTop():void 
		{
			_add_btn.visible = false;
			
			_description_txt.text = _descriptionDefaultText;

			_play_mp3_btn.visible = false;
			_record_btn.visible = false;
			_mp3_btn.visible = !_play_mp3_btn.visible;

			_image_load_btn.visible = true;

			_font_cmp.value = Number(_c.fontSize);
			_size_cmp.value = Number(_c.thumbSize);
			
			_imageHolder.x = _imageHolderCoords.x;
			_imageHolder.y = _imageHolderCoords.y;
		}

		protected override function saveAndUpload(event:Event = null):void 
		{
			_lightbox_mc.visible = true;
			super.saveAndUpload();
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
		
		private function clearDescriptionText(event:MouseEvent):void
		{
			if (_description_txt.text == _descriptionDefaultText)
			{
				_description_txt.text = "";
			}
		}
		
		private function clearTitleText(event:MouseEvent):void
		{
			if (_title_txt.text == Main.TITLE_DEFAULT_TEXT)
			{
				_title_txt.text = "";
			}
		}

		private function onImageDropped(event:NewBitmapDataEvent):void
		{			
			var rat:Number = _c.getScaleRatio(event.bm, _image_load_btn.width);

			event.bm.width = (event.bm.width * rat) - 2;
			event.bm.height = event.bm.height * rat;
		
			_image_load_btn.visible = false;

			_imageHolder.addChild(event.bm);
			
			_imageHolder.x = mouseX;
			_imageHolder.y = mouseY;
			
			TweenLite.to(_imageHolder, 0.3, {x:_imageHolderCoords.x, y:_imageHolderCoords.y});

			event.bm.y = 0;
			
			event.bm.x -= 5;
		}
		
		private function addThumbToPage(event:TileAddEvent):void
		{
			var toPt:Point = new Point();
			
			if (event.index > 0)
			{
				toPt.x = mouseX;
				toPt.y = mouseY;
			}
			else
			{
				toPt.x = _tilelist.x;
				toPt.y = _tilelist.y;
			}
			
			TweenLite.to(_imageHolder, 0.7, {x:toPt.x, y:toPt.y, onComplete:onFinishAddThumbTween, onCompleteParams:[event.description, event.src, event.index]});
		}
		
		private function onFinishAddThumbTween(descr:String, src:Object, ii:int):void 
		{			
			while (_imageHolder.numChildren > 0)
			{
				_imageHolder.removeChildAt(0);
			}
			
			_tilelist.addItemAt( { label:descr, source:src}, ii);
			resetTop();				
		}

		private function onTileListSingleClick(event:TileSingleClickEvent):void
		{
			var imgCell:ImageCell = event.imageCell;
			imgCell.stopDrag();

			var newIndex:int = _c.getTileIndexFromXY(_tilelist.mouseX, _tilelist.mouseY);

			if (newIndex >= _tilelist.length)
			{
				newIndex = _tilelist.length - 1;
			}

			//if it has been dragged out of position, reposition
			if(newIndex != imgCell.listData.index)
			{
				//shift the tiles
				_tilelist.removeItemAt(imgCell.listData.index);
				_tilelist.addItemAt( { label:imgCell.label, source:imgCell.source }, newIndex);				

				_c.moveThumbData(imgCell.listData.index, newIndex);
			}
			else // normal click action
			{
				_tilelist.drawNow();
				_c.onTileListClickComplete(imgCell.listData.index);
			}
		}

		private function onTileListMiddleClick(event:TileMiddleClickEvent):void
		{
			var delIndex:int = -1;
			
			if (event.imageCell && event.imageCell is ImageCell)
			{				
				var imgCell:ImageCell = ImageCell(event.imageCell);
			
				delIndex = imgCell.listData.index;
			}
			else
			{
				delIndex = _tilelist.selectedIndex;
			}
			
			if(!isNaN(delIndex) && delIndex >= 0)
				_tilelist.removeItemAt(delIndex);				
		}

		private function onTileListMouseDown(event:TileMouseDownEvent):void
		{
			if (event.imageCell is ImageCell)
			{
				var imgCell:ImageCell = ImageCell(event.imageCell);
				
				//set the depth so that the currently selected cell is on top
				imgCell.parent.setChildIndex(imgCell, (imgCell.parent.numChildren - 1));	

				imgCell.startDrag();
			}
		}

		private function onTileListDoubleClick(event:TileDoubleClickEvent):void 
		{
			event.imageCell.stopDrag();
		}

		private function SystemMessageEventReceived(event:SystemMessageEvent):void 
		{			
			_lightbox_mc.visible = (event.message != "ok");
			_lightbox_txt.text = event.message;
		}
		
		private function openImageBrowser(event:Event):void
		{
			closeSoundRecorder();
			_lightbox_mc.visible = true;
			_imageBrowser = new ImageBrowserView(_c);
			super.base.addChild(_imageBrowser);
		}
		
		private function closeImageBrowser(event:Event = null):void
		{
			if (_imageBrowser)
			{
				_lightbox_mc.visible = false;			
				super.base.removeChild(_imageBrowser);
				_imageBrowser.destroy();
				_imageBrowser = null;
			}
		}
		
		private function openSoundRecorder(event:Event):void
		{
			closeImageBrowser();
			_lightbox_mc.visible = true;
			_soundRecorder = new SoundRecorderView(_c);
			super.base.addChild(_soundRecorder);
		}
		
		private function closeSoundRecorder(event:Event = null):void
		{
			if (_soundRecorder)
			{
				_lightbox_mc.visible = false;			
				super.base.removeChild(_soundRecorder);
				_soundRecorder.destroy();
				_soundRecorder = null;
			}
		}

		public override function destroy():void
		{
			_play_mp3_btn.removeEventListener(MouseEvent.CLICK, _c.onPlaySoundClicked);
			_add_btn.removeEventListener(MouseEvent.CLICK, _c.addThumbToPage);
			_reset_btn.removeEventListener(MouseEvent.CLICK, _c.resetCurrentSectionThumbList);
			_new_page_btn.removeEventListener(MouseEvent.CLICK, _c.createSectionPage);
			_close_btn.removeEventListener(MouseEvent.CLICK, _c.closeSectionPage);
			_open_folder_btn.removeEventListener(MouseEvent.CLICK, _c.openThumbLibrary);
			
			_page_right_btn.removeEventListener(MouseEvent.CLICK, _c.pageRight);
			_page_left_btn.removeEventListener(MouseEvent.CLICK, _c.pageLeft);
			
			_size_cmp.removeEventListener(Event.CHANGE, _c.thumbnailResize);
			_font_cmp.removeEventListener(Event.CHANGE, _c.fontResize);
			_colour_cmp.removeEventListener(Event.CHANGE, _c.changeBGColour);

			_description_txt.removeEventListener(MouseEvent.MOUSE_DOWN, clearDescriptionText);
			_description_txt.removeEventListener(Event.CHANGE, _c.setDescription);

			_title_txt.removeEventListener(MouseEvent.MOUSE_DOWN, clearTitleText);
			_title_txt.removeEventListener(Event.CHANGE, _c.setTitleText);

			_tilelist.removeEventListener(MouseEvent.MOUSE_DOWN, _c.onTileListMouseDown);			
			_tilelist.removeEventListener(MouseEvent.MOUSE_UP, _c.onTileListMouseUp);
			_tilelist.removeEventListener(MouseEvent.MIDDLE_CLICK, _c.onTileListMiddleClick);
			removeEventListener(MouseEvent.MOUSE_OVER, numericStepperRefresh);
			
			_image_load_btn.removeEventListener(MouseEvent.CLICK, _c.openImageBrowser);

			_c.relay.reset();
			//reset doesn't clear this event properly. weird...
			_c.relay.removeEventListener(NewBitmapDataEvent.BITMAP_DATA, onImageDropped);
			
			if (_tilelist)
			{
				while (_tilelist.length > 0)
				{
					_tilelist.removeItemAt(0);
				}
				
				super.base.removeChild(_tilelist);	
				_tilelist = null;
			}
			
			_save_btn = null;
			_reset_btn = null;
			_new_page_btn = null;
			_close_btn = null;
			_play_mp3_btn = null;
			_add_btn = null;
			
			_image_load_btn = null;
			_mp3_btn = null;
			_lightbox_mc = null;
			
			_title_txt = null;
			_description_txt = null;
			_lightbox_txt = null;
			
			_size_cmp = null;
			_font_cmp = null;
			
			_c.hasSound = false;
			_c.hasImage = false;
			
			if (_imageHolder)
			{
				while (_imageHolder.numChildren > 0)
				{
					_imageHolder.removeChildAt(0);
				}
				
				super.base.removeChild(_imageHolder);
				_imageHolder = null;
			}
			
			removeChild(super.base);
			
			super.destroy();
		}
	}
}