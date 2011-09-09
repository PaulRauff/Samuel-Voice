package com.comprido.imagetool.controller
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

	 * Controller acts as relay between view and model, handles non-core logic
	 */
	
	import com.adobe.images.JPGEncoder;
	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.events.*;
	import com.comprido.imagetool.model.Model;
	import com.comprido.imagetool.model.ThumbData;
	import com.comprido.imagetool.relay.Relay;
	import fl.controls.*;
	import fl.controls.listClasses.ImageCell;
	import fl.data.DataProvider;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.net.URLRequest;
	import flash.utils.*;
	import com.paulrauff.utils.events.*;
	 
	public class Controller
	{
		private var _relay:Relay;
		private var _m:Model;
		private var _dnd:DragAndDrop;
		private var _timer:Timer;
		private var _selectedImageCell:ImageCell;
		private var _lastDownPoint:Point = new Point();
		
		private var _soundFilePlayer:SoundFilePlayer = new SoundFilePlayer();
		
		public function Controller()
		{
			_m = new Model();
			_relay = _m.relay;
		}
		
		public function init():void
		{
			_m.init();

			relay.addEventListener(NewSoundEvent.SOUND_DATA, onSoundDropped);
			relay.addEventListener(SystemMessageEvent.MESSAGE, SystemMessageEventReceived);
		}
		
		public function initDragAndDrop():void
		{
			if (_dnd)
			{
				_dnd.removeEventListener(FileDroppedEvent.FILE_READY, onFileReady);
				_dnd = null;
			}
			
			_dnd = new DragAndDrop();
			_dnd.addEventListener(FileDroppedEvent.FILE_READY, onFileReady);
		}
		
		public function initSection():void
		{
			var hs:Boolean = _m.hasSaved;	
			_m.hasSaved = hs;
			
			hasImage = false;
			hasSound = false;
			
			if (currentSection < 0)
			{
				tempThumb = null;
			}			
			else if (tempThumb)
			{
				if(tempThumb.bitmapFileLocaton.length > 0)
				{
					//load the current img file in to the place holder
					_m.addEventListener(AssetLoadedEvent.FILE_DATA, imageLoadCompleteHandler);
					_m.loadImage(tempThumb.bitmapFileLocaton);
					hasImage = true;
				}
				
				if (tempThumb.soundFileLocaton.length > 0)
				{
					//set the mp3 play to visible
					_relay.dispatchEvent(new SetMP3ButtonVisibiltyEvent(true, Relay.MP3_BUTTON_VISIBILITY_CHANGE));
					hasSound = true;
				}
				
				if (tempThumb.description.length > 0)
				{
					_relay.dispatchEvent(new SetThumbDescriptionEvent(tempThumb.description, Relay.SET_THUMB_DESCRIPTION));	
				}
			}
			
			checkAddVisiblity();
		}

		//view events		
		public function onPlaySoundClicked(event:MouseEvent):void
		{
			if(tempThumb.soundFile)
			{
				playSound(tempThumb.id);
			}
			else
			{
				hasSound = false;
			}
		}
		
		public function onKeyPressedDown(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;

			if (_selectedImageCell)
			{
				switch (key) 
				{
					case 46:
						_m.hasSaved = false;
						currentSectionThumbIDList.splice(_selectedImageCell.listData.index, 1);
						_relay.dispatchEvent(new TileMiddleClickEvent(null, Relay.MOUSE_MIDDLE_CLICK_TILE));
						break;
				}
			}
		}
		
		public function onTileListRightClick(event:MouseEvent):void
		{
			onTileListMiddleClick(event);
		}
		
		public function onTileListMiddleClick(event:MouseEvent):void
		{
			if (event.target is ImageCell)
			{
				deleteCell(ImageCell(event.target));
			}
		}

		public function onTileListMouseDown(event:MouseEvent):void
		{
			if (event.target is ImageCell)
			{
				_selectedImageCell = ImageCell(event.target);
				_lastDownPoint.x = _selectedImageCell.mouseX;
				_lastDownPoint.y = _selectedImageCell.mouseY;

				_relay.dispatchEvent(new TileMouseDownEvent(_selectedImageCell, Relay.MOUSE_DOWN_TILE));
			}
		}
		
		public function onTileListMouseUp(event:MouseEvent):void
		{
			if (event.target is ImageCell)
			{
				_selectedImageCell = ImageCell(event.target);
				
				//start 500ms timer if timer obj is null
				if (!_timer)
				{					
					//if it hasn't moved, start the timer for the double click check
					if (_lastDownPoint.x == _selectedImageCell.mouseX && _lastDownPoint.y == _selectedImageCell.mouseY)
					{
						_timer = new Timer(200, 1);
						_timer.addEventListener(TimerEvent.TIMER_COMPLETE, clickTimerCompleteHandler);
						_timer.start();						
					}
					else
					{
						_relay.dispatchEvent(new TileSingleClickEvent(_selectedImageCell, Relay.SINGLE_CLICK_TILE));	
					}
				}
				else //if timer not null, fire dbl click
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, clickTimerCompleteHandler);
					_timer = null;
					
					if (_m.currentSection >= 0 && event.target is ImageCell)
					{
						getThumbData(currentSectionThumbIDList[_selectedImageCell.listData.index]).onServer = false;
						_m.hasSaved = false;

						//if we're in add to page state, add at the click index
						if (_m.addButtonVisibility)
						{
							addThumbToPage(null, _selectedImageCell.listData.index);
						}
						else //edit the thumb
						{
							var tid:Number = getThumbData(currentSectionThumbIDList[_selectedImageCell.listData.index]).id;
							
							startThumbEdit(tid);
							
							_relay.dispatchEvent(new TileDoubleClickEvent(_selectedImageCell, Relay.DOUBLE_CLICK_TILE));
						}
					}
				}
			}
		}
		
		private function startThumbEdit(tid:Number):void 
		{
			//clear and clone the clicked thumb into tmp
			tempThumb = null;
			var id:Number = 0;
			
			if (_m.getThumbData(tid).isShortcut)
			{
				id = _m.getThumbData(tid).id;
			}
			else
			{
				id = getTime();
			}
			
			tempThumb = _m.getThumbData(tid).clone(id);

			hasImage = true;
			hasSound = true;
			
			tempThumb.bitmapFileLocaton = _m.getFileLocation(tid, "img");
			
			//load the current img file in to the place holder
			_m.addEventListener(AssetLoadedEvent.FILE_DATA, imageLoadCompleteHandler);
			_m.loadImage(tempThumb.bitmapFileLocaton);

			//set the mp3 play to visible
			_relay.dispatchEvent(new SetMP3ButtonVisibiltyEvent(true, Relay.MP3_BUTTON_VISIBILITY_CHANGE));	
			
			_relay.dispatchEvent(new SetThumbDescriptionEvent(tempThumb.description, Relay.SET_THUMB_DESCRIPTION));	
			
			deleteCell(_selectedImageCell);
		}
		
		private function SystemMessageEventReceived(event:SystemMessageEvent):void
		{
			if (_timer)
			{
				_timer.stop();
				_timer = null;
			}
			
			if (event.duration >= 0)
			{
				_timer = new Timer(event.duration, 1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, hideLightbox);
				_timer.start();	
			}
			
			if (event.isError)
			{
				_m.hasSaved = false;
			}
		}
		
		private function deleteCell(imgCell:ImageCell):void
		{
			currentSectionThumbIDList.splice(imgCell.listData.index, 1);
			_relay.dispatchEvent(new TileMiddleClickEvent(imgCell, Relay.MOUSE_MIDDLE_CLICK_TILE));
			_m.hasSaved = false;			
		}
		
		private function hideLightbox(event:TimerEvent):void 
		{
			_relay.dispatchEvent(new SystemMessageEvent("ok", -1, false, SystemMessageEvent.MESSAGE));
		}
		
		private function clickTimerCompleteHandler(event:TimerEvent):void 
		{
			_timer = null;

			if (_m.currentSection < 0)
			{
				loadSection(_selectedImageCell.listData.index);
			}
			else
			{
				if (getThumbData(currentSectionThumbIDList[_selectedImageCell.listData.index]).isShortcut)
				{
					loadSectionID(getThumbData(currentSectionThumbIDList[_selectedImageCell.listData.index]).id);
				}
				else
				{				
					_relay.dispatchEvent(new TileSingleClickEvent(_selectedImageCell, Relay.SINGLE_CLICK_TILE));
				}
			}
		}

		public function openThumbLibrary(event:MouseEvent):void
		{
			_m.createThumbLibrary();
		}
		
		public function openShortcutLibrary(event:MouseEvent):void
		{
			_m.createShortcutLibrary();
		}

		public function addThumbToPage(event:MouseEvent, ii:int = 0):void
		{
			var td:ThumbData = tempThumb.clone(tempThumb.id);
			td.page = currentPage;

			writeBitmapToLocalCache(tempThumb.bitmap, td.id);

			td.description = tempThumb.description;
			td.onServer = false;

			currentSectionThumbIDList.splice(ii, 0, td.id);
			setThumbData(td.id, td);
			
			_relay.dispatchEvent(new TileAddEvent(td.description, tempThumb.bitmap, ii, Relay.ADD_TILE));
			
			tempThumb = null;
			hasImage = false;
			hasSound = false;
			
			_m.addButtonVisibility = false;			
			_m.hasSaved = false;
		}
		
		public function addLibraryThumbToPage(event:MouseEvent):void
		{
			if (event.target is ImageCell)
			{
				var imgCell:ImageCell = ImageCell(event.target);
				var tid:Number = Number(imgCell.data.id);
				
				currentSectionThumbIDList.unshift(tid);
				
				_relay.dispatchEvent(new TileAddEvent(getThumbData(tid).description, getFileLocation(tid, "img"), 0, Relay.ADD_TILE));
				
				_m.hasSaved = false;
			}
		}
		
		public function addSectionThumbToPage(event:MouseEvent):void
		{
			if (event.target is ImageCell)
			{
				var imgCell:ImageCell = ImageCell(event.target);
				var tid:Number = Number(imgCell.data.id);

				var td:ThumbData = new ThumbData(tid);
				td.page = currentPage;

				td.description = imgCell.data.label;
				td.onServer = true;
				td.isShortcut = true;

				currentSectionThumbIDList.unshift(tid);
				setThumbData(tid, td);
				
				_relay.dispatchEvent(new TileAddEvent(imgCell.data.label, getFileLocation(tid, "img"), 0, Relay.ADD_TILE));
				_m.hasSaved = false;
			}
		}

		public function thumbnailResize(event:Event):void
		{
			thumbSize = event.target.value;
			_relay.dispatchEvent(new Event(Relay.THUMB_SIZE_CHANGE));
			_m.hasSaved = false;
		}
		
		public function fontResize(event:Event):void
		{
			fontSize = event.target.value;
			_relay.dispatchEvent(new Event(Relay.FONT_SIZE_CHANGE));
			_m.hasSaved = false;
		}
		
		public function changeBGColour(event:Event = null):void 
		{
			sectionColour = event.target.selectedColor;
			_relay.dispatchEvent(new Event(Relay.BG_COLOUR_CHANGE));
			_m.hasSaved = false;
		}
		
		public function setDescription(event:Event = null):void
		{
			newTempThumb();
			tempThumb.description = event.target.text;
			checkAddVisiblity();
			_m.hasSaved = false;
		}
		
		public function setTitleText(event:Event):void
		{		
			currentSectionTitle = event.target.text;
			_m.hasSaved = false;
		}
		
		public function newTempThumb():void
		{
			if (!tempThumb)
			{
				tempThumb = new ThumbData(getTime());
			}
		}

		public function checkAddVisiblity():void
		{
			_m.addButtonVisibility = (hasSound && hasImage);

			_relay.dispatchEvent(new SetAddButtonVisibiltyEvent(_m.addButtonVisibility, Relay.ADD_BUTTON_VISIBILITY_CHANGE));		
		}
		
		public function playSound(id:Number):void
		{
			_soundFilePlayer.playSoundFile(getFileLocation(id, "snd"));
		}

		//once a file has dropped
		private function onFileReady(event:FileDroppedEvent):void
		{			
			switch(event.file.extension.toLowerCase())
			{
				case "png" :
				case "jpg" :
				case "jpeg" :
				case "gif" :
					_m.addEventListener(AssetLoadedEvent.FILE_DATA, imageLoadCompleteHandler);
					_m.loadImage(event.file.url);
					break;
				case "mp3" :
				case "wav" :
					_relay.dispatchEvent(new NewSoundEvent(event.file, NewSoundEvent.SOUND_DATA));
					break;
				default:
					//nothing
			}
		}
		
		private function imageLoadCompleteHandler(event:AssetLoadedEvent):void 
		{
			_m.removeEventListener(AssetLoadedEvent.FILE_DATA, imageLoadCompleteHandler);

			if (event.fileData is Bitmap) 
			{
				newTempThumb();
				var bmp:Bitmap = resizeBitmap(Bitmap(event.fileData));
				tempThumb.bitmap = bmp;
				hasImage = true;
				checkAddVisiblity();

				_relay.dispatchEvent(new NewBitmapDataEvent(bmp, NewBitmapDataEvent.BITMAP_DATA));
			}
		}

		private function resizeBitmap(bm:Bitmap):Bitmap
		{
			bm.smoothing = true;
			
			var rat:Number = getScaleRatio(bm, Main.MAX_IMAGE_FILE_WIDTH);
			
			bm.width = bm.width * rat;
			bm.height = bm.height * rat;

			return bm;
		}
		
		private function onSoundDropped(event:NewSoundEvent):void
		{
			if (event.soundFile)
			{
				newTempThumb();
				_soundFilePlayer.stopSound();
				hasSound = true;				
				tempThumb.soundFile = event.soundFile;
				checkAddVisiblity();
			
				_relay.dispatchEvent(new SetMP3ButtonVisibiltyEvent(true, Relay.MP3_BUTTON_VISIBILITY_CHANGE));					
			}
			else
			{
				Debug.warning("NO SOUND FILE");
			}
		}
		
		public function getScaleRatio(dispObj:DisplayObject, compareSize:Number):Number
		{
			var rat:Number = 1;
			var rat1:Number = 1;
			var rat2:Number = 1;

			if (dispObj.width > compareSize)
			{
				rat1 = compareSize / dispObj.width;
			}
			
			if (dispObj.height > compareSize)
			{
				rat2 = compareSize / dispObj.height;
			}
			
			rat = rat2;
			
			if (rat1 < rat2)
				rat = rat1;

			return rat;
		}
		
		public function getTileIndexFromXY(x:int, y:int):int
		{
			//prevent divide by zero errors
			if (x <= 0)
			{
				x = 1;
			}
			
			if (y <= 0)
			{
				y = 1;
			}
			
			var cols:int = Math.floor(Main.TILE_LIST_WIDTH / thumbSize);
			var heightOffSet:int = Math.floor(y / thumbSize) * cols;
			var index:int = Math.floor(x / thumbSize) + heightOffSet;
			
			return index;
		}
		
		public function writeBitmapToLocalCache(bm:Bitmap, id:Number):Bitmap
		{
			//write to cache
			if (bm.bitmapData.width > Main.MAX_IMAGE_FILE_WIDTH || bm.bitmapData.height > Main.MAX_IMAGE_FILE_WIDTH)
			{
				var scale:Number = getScaleRatio(bm, Main.MAX_IMAGE_FILE_WIDTH);

				var matrix:Matrix = new Matrix();
				matrix.scale(scale, scale);

				var smallBMD:BitmapData = new BitmapData(bm.bitmapData.width * scale, bm.bitmapData.height * scale, true, 0xffffff);
				smallBMD.draw(bm.bitmapData, matrix, null, null, new Rectangle(0,0,Main.MAX_IMAGE_FILE_WIDTH, Main.MAX_IMAGE_FILE_WIDTH), true);

				bm = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
			}

			//move to model
			var jpgEncoder:JPGEncoder = new JPGEncoder(100);
			var jpgStream:ByteArray = jpgEncoder.encode(bm.bitmapData);

			var imageDir:File = File.applicationStorageDirectory.resolvePath("cachedimages/");
			var cacheFile:File = new File(imageDir.nativePath +File.separator+ ""+id+".jpg");

			var stream:FileStream = new FileStream();
			stream.open(cacheFile, FileMode.WRITE);
			stream.writeBytes(jpgStream);
			stream.close();	

			return bm;
		}
		
		public function getFileLocation(id:Number, type:String):String
		{
			return _m.getFileLocation(id, type);
		}
		
		public function getXMLHistory():DataProvider
		{
			return _m.getXMLHistory();
		}
		
		public function moveSectionData(oldIndex:int, newIndex:int):void 
		{
			_m.hasSaved = false;
			_m.moveSectionData(oldIndex, newIndex);
		}
		
		public function launchUserURL(event:MouseEvent):void 
		{
			_m.launchUserURL();
		}
		
		public function pageRight(event:MouseEvent):void 
		{
			_m.pageRight();
		}
		
		public function pageLeft(event:MouseEvent):void 
		{
			_m.pageLeft();
		}
		
		public function numCols(tileSize:int):int
		{
			var cols:int = Math.floor(Main.TILE_LIST_WIDTH / tileSize);
			
			return cols;
		}
		
		public function closeSectionPage(event:MouseEvent):void 
		{
			if (_m.hasSaved)
			{
				openIndex();
			}
			else
			{
				_relay.dispatchEvent(new Event(Relay.OPEN_ALERT_BOX));
			}
		}
		
		public function openIndex(event:Event = null):void 
		{
			_m.hasSaved = true;
			_relay.dispatchEvent(new Event(Relay.CLOSE_ALERT_BOX));
			_m.openIndex();
		}

		public function resetCurrentSectionThumbList(event:MouseEvent):void
		{
			_m.hasSaved = true;
			_m.resetCurrentSectionThumbList();			
		}
		
		public function loadHistoryFile(event:Event):void
		{
			var id:Number = Number(event.target.getItemAt(event.target.selectedIndex).value);
			
			Debug.log("LOAD::"+id);
			
			if (!isNaN(id))
			{
				_m.hasSaved = false;
				_m.init("xml/"+id+".xml");
			}
		}
		
		public function getTime():Number
		{
			return _m.getTime();
		}
		
		public function saveAndUpload(event:Event = null):void 
		{
			_m.saveAndUpload();
			_relay.dispatchEvent(new Event(Relay.CLOSE_ALERT_BOX));
		}
		
		private function loadSectionID(id:Number):void
		{
			_m.loadSectionID(id);
		}
		
		public function loadSection(ii:Number):void
		{
			_m.loadSection(ii);
		}
		
		public function createSectionPage(event:MouseEvent):void
		{
			_m.createSectionPage();
		}
		
		public function getThumbData(thumbID:Number):ThumbData
		{
			return _m.thumbList[thumbID];
		}
		
		public function setThumbData(thumbID:Number, thumbData:ThumbData):ThumbData
		{
			return _m.thumbList[thumbID] = thumbData;
		}
		
		public function moveThumbData(oldIndex:int, newIndex:int):void 
		{
			_m.moveThumbData(oldIndex, newIndex);
		}
		
		public function set currentSectionTitle(value:String):void 
		{
			_m.currentSectionTitle = value;
		}
		
		public function get currentSectionTitle():String
		{
			var myPattern:RegExp = /`/g;  
			
			return _m.currentSectionTitle.replace(myPattern, "'");
		}
		
		public function get relay():Relay
		{
			return _relay;
		}		
		
		public function get tempThumb():ThumbData 
		{
			return _m.tempThumb;
		}
		
		public function set tempThumb(value:ThumbData):void 
		{
			_m.tempThumb = value;
		}

		public function get currentSectionThumbIDList():Vector.<Number> 
		{
			return _m.getSectionThumbIDList(_m.currentSection, _m.currentPage);
		}
		
		public function set currentSectionThumbIDList(value:Vector.<Number>):void 
		{
			_m.setSectionThumbIDList(_m.currentSection, _m.currentPage, value);
		}
		
		public function get currentSection():int 
		{
			return _m.currentSection;
		}
		
		public function set currentSection(value:int):void 
		{
			_m.currentSection = value;
		}
		
		public function get currentPage():int 
		{
			return _m.currentPage;
		}

		public function set currentPage(value:int):void 
		{
			_m.currentPage = value;
		}
		
		public function get totalPages():int 
		{
			return _m.totalPages;
		}
		
		public function get totalSections():int 
		{
			return _m.totalSections;
		}
		
		public function get thumbSize():int 
		{
			return _m.thumbSize;
		}
		
		public function set thumbSize(value:int):void 
		{
			_m.thumbSize = value;
		}
		
		public function get fontSize():int 
		{
			return _m.fontSize;
		}
		
		public function set fontSize(value:int):void 
		{
			_m.fontSize = value;
		}

		public function set sectionColour(value:uint):void
		{
			_m.sectionColour = value;
		}
		
		public function get sectionColour():uint
		{
			return _m.sectionColour;
		}
		
		public function getSectionName(sectionIndex:int):String
		{
			var myPattern:RegExp = /`/g;  
			
			return _m.getSectionName(sectionIndex).replace(myPattern, "'");
		}
		
		public function getSectionID(sectionIndex:int):Number
		{
			return _m.getSectionID(sectionIndex);
		}

		public function createSection(id:Number):void
		{
			_m.createSection(id);
		}
		
		public function setServer(event:Event):void
		{
			_m.serverLocation = event.target.text;
		}
		
		public function getServer():String
		{
			return _m.serverLocation;
		}		
		
		public function get hasSound():Boolean 
		{
			return _m.hasSound;
		}
		
		public function set hasSound(value:Boolean):void 
		{
			_m.hasSound = value;
		}
		
		public function get hasImage():Boolean 
		{
			return _m.hasImage;
		}
		
		public function set hasImage(value:Boolean):void 
		{
			_m.hasImage = value;
		}
	}
}
