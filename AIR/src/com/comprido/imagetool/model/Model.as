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

	 * model handles state and data logic
	 */

	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.events.*;
	import com.comprido.imagetool.relay.Relay;
	import com.paulrauff.utils.events.*;
	import com.paulrauff.utils.fileloader.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.utils.*;
	import flash.net.*;
	import fl.data.DataProvider;
	import com.paulrauff.utils.sharedObject.*;

	public class Model extends EventDispatcher
	{
		private var _relay:Relay;
		private var _thumbList:Dictionary;
		private var _sectionList:Vector.<SectionData>;
		private var _tempThumb:ThumbData;
		private var _so:Sharer;
		
		private var _currentSection:int = -1;
		private var _currentPage:int = 0;
		private var _xmlDownloadedVersion:Number = 0
			
		private var _hasSound:Boolean = false;
		private var _hasImage:Boolean = false;
		private var _hasSaved:Boolean = true;
		private var _addButtonVisibility:Boolean = false;
		
		private var _indexFontSize:int = Main.DEFAULT_FONT_SIZE;
		private var _indexThumbSize:int = Main.DEFAULT_THUMB_SIZE;
		
		private var _serverLocation:String = "";
		
		public function Model()
		{
			_relay = new Relay();
		}

		public function init(xmlFile:String = "xml/data.xml"):void
		{
			_thumbList = null;
			_sectionList = null;
			_thumbList = new Dictionary();
			_sectionList = new Vector.<SectionData>();
			_so = new Sharer(Main.SO_NAME);

			var xmlLoader:DataLoader = new DataLoader();
			xmlLoader.addEventListener(DataLoadedEvent.FILE_DATA, onXMLLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, loadCurrentSection);
			xmlLoader.load(serverLocation+"1/"+xmlFile);
		}
		
		private function loadCurrentSection(event:Event):void 
		{
			_relay.dispatchEvent(new CreateSectionEvent(_currentSection, currentPage, Relay.NEW_SECTION));
		}
			
		private function onXMLLoaded(event:DataLoadedEvent):void 
		{
			//read xml and add to thumb list. test for local files
			parseXML(XML(event.dataObject));
			
			//_relay.dispatchEvent(new CreateSectionEvent(_currentSection, currentPage, Relay.NEW_SECTION));
			
			var adl:AssetDownloader = new AssetDownloader(_thumbList, serverLocation, _relay);
			adl.addEventListener(AssetDownloader.READY, loadCurrentSection);
		}
		
		private function parseXML(xml:XML):void 
		{			
			if (xml.toString().length <= 0)
			{
				return;
			}
			
			var versionXMLList:XMLList = xml.version;
			var indexXMLList:XMLList = xml.index;
			var sectionXMLList:XMLList = xml.section;
			var thumbsXMLList:XMLList = xml.thumbs[0].thumb;
			var sectionIndex:int = 0;
			
			//get the ver
			if (versionXMLList[0])
			{
				_xmlDownloadedVersion = Number(versionXMLList[0]);
			}
			else
			{
				_xmlDownloadedVersion = 0;
			}
			
			//set the index data
			if (indexXMLList[0])
			{
				if(indexXMLList[0].attribute("thumbsize"))
					_indexThumbSize = indexXMLList[0].attribute("thumbsize");
				
				if(indexXMLList[0].attribute("fontsize"))
					_indexFontSize = indexXMLList[0].attribute("fontsize");
			}
			
			for each (var thumbElement:XML in thumbsXMLList) 
			{
				var id:Number = thumbElement.attribute("id");

				if (!_thumbList[id])
				{
					_thumbList[id] = new ThumbData(id);
					_thumbList[id].isShortcut = Boolean(int(thumbElement.attribute("scut")));
					_thumbList[id].isCommon = Boolean(int(thumbElement.attribute("com")));
					_thumbList[id].description = thumbElement;
					_thumbList[id].onServer = true;	
					_thumbList[id].soundFileLocaton = _serverLocation + "sound/" + id + ".mp3";
				}
			}

			for each (var sectionElement:XML in sectionXMLList) 
			{
				_sectionList[sectionIndex] = new SectionData(sectionElement.attribute("id"));
				_sectionList[sectionIndex].onServer = true;
				
				//check data exists to override defaults
				if(sectionElement.attribute("thumbsize"))
					_sectionList[sectionIndex].thumbSize = sectionElement.attribute("thumbsize");
				
				if(sectionElement.attribute("fontsize"))
					_sectionList[sectionIndex].fontSize = sectionElement.attribute("fontsize");
				
				if(sectionElement.attribute("bgcolour"))
					_sectionList[sectionIndex].sectionColour = uint("0x"+sectionElement.attribute("bgcolour"));
				
				if(sectionElement.attribute("name"))
					_sectionList[sectionIndex].sectionName = sectionElement.attribute("name");

				var pageList:XMLList = sectionElement.page;

				var pageCount:int = 0;

				for each (var pageElement:XML in pageList) 
				{
					var pid:int = pageElement.attribute("pid");
					var tList:XMLList = pageElement.t;
					var tmpVec:Vector.<Number> = new Vector.<Number>();

					for each (var tElement:XML in tList) 
					{
						var tid:Number = tElement.attribute("id");
						//Debug.log(tid);

						if(!isNaN(tid))
							tmpVec.push(tid);
					}

					_sectionList[sectionIndex].addThumbIDs(pageCount, tmpVec);
					pageCount++;	
				}

				sectionIndex++;
			}
		}
		
		/**
		 * Loads a section at page 0
		 * @param	id
		 */
		public function loadSection(ii:Number):void
		{
			_currentSection = ii;
			_relay.dispatchEvent(new CreateSectionEvent(ii, 0, Relay.NEW_SECTION));
		}
		
		public function loadSectionID(id:Number):void
		{
			var len:int = _sectionList.length;
			
			for (var ii:int = 0; ii < len; ii++)
			{
				if (_sectionList[ii].id == id)
				{
					loadSection(ii);
					break;
				}
			}
		}
		
		public function loadImage(url:String):void
		{
			var al:AssetLoader = new AssetLoader(url);
			
			al.addEventListener(AssetLoadedEvent.FILE_DATA, imageLoadCompleteHandler);
			al.addEventListener(IOErrorEvent.IO_ERROR, imageLoadIoErrorHandler);
			al.load();
		}
		
		private function imageLoadIoErrorHandler(e:Event):void 
		{
			_relay.dispatchEvent(new SystemMessageEvent("Error Loading Image.\nPlease try again.", 5000, true, SystemMessageEvent.MESSAGE));
		}
		
		private function imageLoadCompleteHandler(event:AssetLoadedEvent):void 
		{
			dispatchEvent(event);
		}
		
		public function launchUserURL():void
		{
			navigateToURL(new URLRequest(serverLocation))
		}
		
		/**
		 * Creates a brand new section
		 * @param	id
		 */
		public function createSection(id:Number):void
		{
			_sectionList.push(new SectionData(id));
			_currentSection = totalSections -1;
			_relay.dispatchEvent(new CreateSectionEvent(_currentSection, 0, Relay.NEW_SECTION));
		}
		
		public function deleteCurrentSection():void
		{
			_sectionList.splice(_currentSection, 1);
			loadSection(-1);
		}
		
		/**
		 * creates a new page in the current section
		 */
		public function createSectionPage():void
		{
			//check if the last page is empty
			if (getSectionThumbIDList(_currentSection, _sectionList[_currentSection].totalPages).length > 0)
			{			
				_currentPage = _sectionList[_currentSection].totalPages +1;
				_sectionList[_currentSection].addThumbIDs(_currentPage, new Vector.<Number>());
				_relay.dispatchEvent(new CreateSectionEvent(_currentSection, _currentPage, Relay.NEW_SECTION));
			}
			else
			{
				_relay.dispatchEvent(new CreateSectionEvent(_currentSection, _sectionList[_currentSection].totalPages, Relay.NEW_SECTION));
			}
		}
		
		public function createThumbLibrary():void
		{
			var dp:DataProvider = new DataProvider();
			
			for each(var td:ThumbData in _thumbList)
			{
				if(!td.isShortcut)
				{
					dp.addItem( { label:td.description, source:getFileLocation(td.id, "img"), id:td.id } );
				}
			}
			
			dp.sortOn("label");
			
			_relay.dispatchEvent(new CreateThumbLibraryEvent(dp, Relay.NEW_THUMB_LIBRARY));
		}
		
		public function createShortcutLibrary():void
		{
			var dp:DataProvider = new DataProvider();
			
			for each(var sd:SectionData in _sectionList)
			{
				dp.addItem( { label:sd.sectionName, source:getFileLocation(sd.id, "img"), id:sd.id } );
			}
			
			dp.sortOn("label");
			
			_relay.dispatchEvent(new CreateSectionLibraryEvent(dp, Relay.NEW_SECTION_LIBRARY));
		}
		
		/**
		 * destroy current section and start again		
		 */	
		public function resetCurrentSectionThumbList():void
		{			
			init();
		}

		public function getFileLocation(id:Number, type:String):String
		{
			var rtn:String;
			var ext:String;
			
			switch(type)
			{
				case "snd":
					ext = ".mp3";
					rtn = _serverLocation + "1/sound/" + id + ext;
					break;
				case "img":
					ext = ".jpg";
					rtn = _serverLocation + "1/img/" + id + ext;
					break;
				default:
					return "";
			}
			
			var imageDir:File = File.applicationStorageDirectory.resolvePath("cachedimages/");
			var cacheFile:File = new File(imageDir.nativePath +File.separator+ ""+id+ext);
            
			//cache should exist, because of sync...
			if (cacheFile.exists)
			{
                rtn = cacheFile.url;
            }
			else
			{
				Debug.warning("FILE DOES NOT EXIST :: "+cacheFile.url);
			}
			
			return rtn;
		}
		
		public function getXMLHistory():DataProvider
		{
			var dp:DataProvider = new DataProvider();
			dp.addItem( { label: "" } );			
			
			if (_xmlDownloadedVersion == Main.XML_VERSION)
			{			
				var harr:Array = _so.getSOData("h").split(",");

				var d:Date = new Date();
				var len:int = harr.length -1;
				
				if (harr && harr.length > 0)
				{
					for (var ii:int = len; ii >= 0 ; ii--)
					{
						d.setTime(Number(harr[ii]));
						dp.addItem( {id: d.toUTCString().substr(0, (harr[ii].lastIndexOf("UTC") - 2)), value:harr[ii]} );
					}
				}
			}
			else
			{
				_so.setSOData("h", "");
			}

			return dp;
		}

		public function moveSectionData(oldIndex:int, newIndex:int):void 
		{
			var v:Vector.<SectionData> = _sectionList.splice(oldIndex, 1);
			
			_sectionList.splice(newIndex, 0, SectionData(v[0]));
		}
		
		public function moveThumbData(oldIndex:int, newIndex:int):void 
		{			
			var v:Vector.<Number> = getSectionThumbIDList(_currentSection, _currentPage).splice(oldIndex, 1);

			getSectionThumbIDList(_currentSection, _currentPage).splice(newIndex, 0, Number(v[0]));
			
			hasSaved = false;
		}
		
		/**
		 * paging function
		 */
		public function pageLeft():void 
		{
			if (_currentPage > 0)
			{
				_currentPage--;
				_relay.dispatchEvent(new CreateSectionEvent(_currentSection, _currentPage, Relay.NEW_SECTION));
			}
		}
		
		/**
		 * paging function
		 */
		public function pageRight():void 
		{
			if (_currentPage < _sectionList[_currentSection].totalPages)
			{
				_currentPage++;
				_relay.dispatchEvent(new CreateSectionEvent(_currentSection, _currentPage, Relay.NEW_SECTION));
			}
		}
	
		/**
		 * opens the index page
		 */
		public function openIndex():void 
		{
			_currentSection = -1;
			_currentPage = 0;
			init();
		}

		/**
		 * gets the current millisecond time
		 * used for unique thumb and file id's
		 * @return
		 */
		public function getTime():Number 
		{
			return new Date().getTime();
		}
		
		/**
		 * starts the upload process
		 */
		public function saveAndUpload():void 
		{
			hasSaved = true;
			new AssetUploader(_serverLocation, _sectionList, _thumbList, _relay, _indexFontSize, _indexThumbSize);
		}
		
		/**
		 * Gets the name of a section, using it's index
		 * @param	sectionIndex
		 * @return
		 */
		public function getSectionName(sectionIndex:int):String
		{
			return _sectionList[sectionIndex].sectionName;
		}
		
		/**
		 * Gets the ID (time number) of a section, using it's index
		 * @param	sectionIndex
		 * @return
		 */
		public function getSectionID(sectionIndex:int):Number
		{
			return _sectionList[sectionIndex].id;
		}

		/**
		 * gets the thumb id list for a section
		 * @param	sectionID
		 * @param	pageID
		 * @return
		 */
		public function getSectionThumbIDList(sectionID:int, pageID:int):Vector.<Number> 
		{			
			return _sectionList[_currentSection].getThumbIDList(pageID);
		}
		
		/**
		 * sets the thumb id list for a section
		 * @param	sectionID
		 * @param	pageID
		 * @param	thumbIDs vector of thumb id's in this section
		 */
		public function setSectionThumbIDList(sectionID:int, pageID:int, thumbIDs:Vector.<Number>):void 
		{
			_sectionList[_currentSection].setThumbIDList(pageID, thumbIDs);
		}
		
		/**
		 * Gets/sets the thumb data for a thumb ID number
		 * @param	thumbID
		 * @return
		 */
		public function getThumbData(thumbID:Number):ThumbData
		{
			return _thumbList[thumbID];
		}
		
		public function setThumbData(thumbID:Number, thumbData:ThumbData):ThumbData
		{
			return _thumbList[thumbID] = thumbData;
		}
		
		/////////////////////////////////////////////////
		//GETTERS AND SETTERS
		public function get relay():Relay
		{
			return _relay;			
		}
		
		public function get tempThumb():ThumbData 
		{
			return _tempThumb;
		}
		
		public function set tempThumb(value:ThumbData):void 
		{
			_tempThumb = value;
		}
		
		public function get thumbList():Dictionary 
		{
			return _thumbList;
		}
		
		public function set thumbList(value:Dictionary):void 
		{
			_thumbList = value;
		}
		
		public function get currentSection():int 
		{
			return _currentSection;
		}
		
		public function set currentSection(value:int):void 
		{
			_currentSection = value;
		}
		
		public function get thumbSize():int 
		{
			var r:int = _indexThumbSize;
			
			if(_currentSection >= 0)
				r = _sectionList[_currentSection].thumbSize;
			
			return r;
		}
		
		public function set thumbSize(value:int):void 
		{
			if (_currentSection < 0)
				_indexThumbSize = value;
			else
				_sectionList[_currentSection].thumbSize = value;
		}
		
		public function get fontSize():int 
		{			
			var r:int = _indexFontSize;

			if(_currentSection >= 0)
				r = _sectionList[_currentSection].fontSize

			return r;
		}
		
		public function set fontSize(value:int):void 
		{
			if (_currentSection < 0)
				_indexFontSize = value;
			else
				_sectionList[_currentSection].fontSize = value;
		}

		public function get currentPage():int 
		{
			return _currentPage;
		}
		
		public function set currentPage(value:int):void 
		{
			_currentPage = value;
		}
		
		public function get totalPages():int 
		{
			return _sectionList[currentSection].totalPages;
		}
		
		public function get totalSections():int 
		{
			return _sectionList.length;
		}
		
		public function set sectionColour(value:uint):void
		{
			_sectionList[currentSection].sectionColour = value;
		}
		
		public function get sectionColour():uint
		{
			return uint(_sectionList[currentSection].sectionColour);
		}
		
		public function set currentSectionTitle(value:String):void 
		{
			_sectionList[_currentSection].sectionName = value;
		}
		
		public function get currentSectionTitle():String
		{		
			return _sectionList[_currentSection].sectionName;
		}

		public function get hasSound():Boolean 
		{
			return _hasSound;
		}
		
		public function set hasSound(value:Boolean):void 
		{
			_hasSound = value;
		}
		
		public function get hasImage():Boolean 
		{
			return _hasImage;
		}
		
		public function set hasImage(value:Boolean):void 
		{
			_hasImage = value;
		}
		
		public function get indexFontSize():int 
		{
			return _indexFontSize;
		}
		
		public function set indexFontSize(value:int):void 
		{
			_indexFontSize = value;
		}
		
		public function get indexThumbSize():int 
		{
			return _indexThumbSize;
		}
		
		public function set indexThumbSize(value:int):void 
		{
			_indexThumbSize = value;
		}
		
		public function get hasSaved():Boolean 
		{
			return _hasSaved;
		}
		
		public function set hasSaved(value:Boolean):void 
		{
			if (value)
				_relay.dispatchEvent(new Event(Relay.DISABLE_SAVE));
			else
				_relay.dispatchEvent(new Event(Relay.ENABLE_SAVE));
			
			_hasSaved = value;
		}
		
		public function get addButtonVisibility():Boolean 
		{
			return _addButtonVisibility;
		}
		
		public function set addButtonVisibility(value:Boolean):void 
		{
			_addButtonVisibility = value;
		}
		
		public function set serverLocation(txt:String):void
		{
			if (txt.length > 0)
			{
				_so.setSOData("srv", txt);
				_serverLocation = txt;
			}
		}
		
		public function get serverLocation():String
		{
			_serverLocation = _so.getSOData("srv");
			
			if (_serverLocation.lastIndexOf("/") != (_serverLocation.length - 1))
			{
				_serverLocation = _serverLocation +"/";
			}
			
			return _serverLocation;
		}
		
		public function get imageBrowseDirectory():String 
		{
			return _so.getSOData("imgDir");
		}
		
		public function set imageBrowseDirectory(value:String):void 
		{
			_so.setSOData("imgDir", value);
		}
	}
}
