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
	import com.comprido.imagetool.relay.Relay;
	import com.comprido.imagetool.events.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import com.paulrauff.utils.events.*;
	import flash.filesystem.File;
	import com.paulrauff.utils.sharedObject.*;
	
	public class AssetUploader 
	{
		private var _sectionList:Vector.<SectionData>;
		private var _uploadList:Vector.<Number>;
		private var _thumbList:Dictionary;
		private var _uploadListCurrent:int = 0;
		private var _relay:Relay;
		private var _serverLocation:String;
		
		private var _indexFontSize:int = Main.DEFAULT_FONT_SIZE;
		private var _indexThumbSize:int = Main.DEFAULT_THUMB_SIZE;
		
		public function AssetUploader(serverLocation:String, sectionList:Vector.<SectionData>, thumbList:Dictionary, relay:Relay, indexFontSize:int, indexThumbSize:int) 
		{
			_serverLocation = serverLocation;
			_sectionList = sectionList;
			_thumbList = thumbList;
			_relay = relay;
			
			_indexFontSize = indexFontSize;
			_indexThumbSize = indexThumbSize;
			
			makeXML();
		}
		
		private function makeXML():void 
		{
			//create a list of id's to upload 
			_uploadList = null;
			_uploadList = new Vector.<Number>();
			
			var len:int = _thumbList.length;
			
			//make a string to hold the sections per loop
			var _sectionXML:String = "";
			
			var xmlStr:String = "<?xml version='1.0'?>\n<data>";
			
			xmlStr += "\n\t<version>"+Main.XML_VERSION+"</version>";
			xmlStr += "\n\t<index thumbsize='"+_indexThumbSize+"' fontsize='"+_indexFontSize+"' />";

			xmlStr += "\n\t<thumbs>";
			
			var thumbStr:String = "";
			
			//loop through the thumbs
			for each(var td:ThumbData in _thumbList)
			{
				thumbStr += "\n\t\t<thumb id='" + td.id + "' com='"+int(td.isCommon)+"' scut='"+int(td.isShortcut)+"'>";

				if(td.description.length > 0)
					thumbStr += "<![CDATA[" + td.description + "]]>";

				thumbStr += "</thumb>";
				
				//if the current thumb isn't on the server, add it to the list of thumbs to upload
				if (!td.onServer)
				{
					if(_uploadList.indexOf(td.id) < 0)
						_uploadList.push(td.id);
				}
			}
			
			xmlStr += thumbStr;
			
			xmlStr += "\n\t</thumbs>";
			thumbStr = "";
			
			len = _sectionList.length;
			
			//loop through the sections
			for (var ii:int = 0; ii < len; ii++)
			{
				if (_sectionList[ii])
				{				
					_sectionXML = "\n\t<section id='" + _sectionList[ii].id +"' name='"+escape(_sectionList[ii].sectionName)+"' thumbsize='" +_sectionList[ii].thumbSize + "' fontsize='" +_sectionList[ii].fontSize + "' bgcolour='"+_sectionList[ii].getSectionColourHex()+"' >";

					var pageLength:int = _sectionList[ii].totalPages + 1;
					var pageStr:String = "";

					//loop through each page
					for (var jj:int = 0; jj < pageLength; jj++)
					{
						pageStr = "";
						
						if (_sectionList[ii].getThumbIDList(jj).length > 0)
						{
							pageStr += "\n\t\t<page pid='" + jj + "'>";
						
							//loop through the thumbs
							for each(var tid:Number in _sectionList[ii].getThumbIDList(jj))
							{
								pageStr += "\n\t\t\t<t id='" + tid + "' />";
							}
							
							pageStr += "\n\t\t</page>";
						}
					
						_sectionXML += pageStr;
					}
					
					_sectionXML += "\n\t</section>";
					
					xmlStr += _sectionXML;
					_sectionXML = "";
					
					if (!_sectionList[ii].onServer)
					{
						_uploadList.push(_sectionList[ii].id);
					}				
				}
			}

			xmlStr += "\n</data>";

			var bak:String = "" + (new Date().getTime());
			setHistory(bak);
			
			var variables = new URLVariables("xmldata=" + xmlStr + "&bakxml="+bak);
			var request = new URLRequest(); 
			request.url = _serverLocation+"xmlsave.php"; 
			request.method = URLRequestMethod.POST; 
			request.data = variables; 

			var loader = new URLLoader(); 
			loader.dataFormat = URLLoaderDataFormat.TEXT; 

			_uploadListCurrent = 0;
			loader.addEventListener(Event.COMPLETE, postImageData); 
			
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadXMLError); 
			loader.addEventListener(IOErrorEvent.IO_ERROR, uploadXMLError); 

			try 
			{ 
				loader.load(request); 
			} 
			catch (error) 
			{ 
				Debug.warning("Unable to load URL"); 
			} 
		}
		
		private function postImageData(event:Event = null):void
		{
			if (_uploadList.length > 0)
			{
				_relay.dispatchEvent(new SystemMessageEvent("loading image "+ (_uploadListCurrent + 1) +" of "+_uploadList.length, -1, SystemMessageEvent.MESSAGE));

				var imageDir:File = File.applicationStorageDirectory.resolvePath("cachedimages/");
				var cacheFile:File = new File(imageDir.nativePath +File.separator+ ""+_uploadList[_uploadListCurrent]+".jpg");

				//cache should exist, since this is the creator tool...
				if (cacheFile.exists)
				{
					var urlRequest = new URLRequest(_serverLocation+"jpgsave.php?img="+_uploadList[_uploadListCurrent]+".jpg"); 
					urlRequest.method = URLRequestMethod.POST; 
					//cacheFile.addEventListener(ProgressEvent.PROGRESS, uploadProgress); 
					cacheFile.addEventListener(Event.COMPLETE, uploadImageComplete); 
					cacheFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadImageError); 
					cacheFile.addEventListener(IOErrorEvent.IO_ERROR, uploadImageError); 
					cacheFile.upload(urlRequest, "uploadfile");
				}
				else
				{
					uploadSoundComplete();
				}
			}
			else
			{
				uploadSoundComplete();
			}
		}

		private function uploadImageComplete(event:Event = null):void 
		{
			_uploadListCurrent++;
			
			if (_uploadListCurrent < _uploadList.length)
			{
				postImageData();
			}
			else
			{
				_uploadListCurrent = 0;
				postSoundData();
			}
		}
		
		private function postSoundData(event:Event = null):void
		{
			if (_uploadList.length > 0)
			{
				_relay.dispatchEvent(new SystemMessageEvent("loading sound "+ (_uploadListCurrent + 1) +" of "+_uploadList.length, -1, SystemMessageEvent.MESSAGE));
				
				var soundDir:File = File.applicationStorageDirectory.resolvePath("cachedimages/");
				var cacheFile:File = new File(soundDir.nativePath +File.separator+ ""+_uploadList[_uploadListCurrent]+".mp3");
						
				//cache should exist, since this is the creator tool...
				if (cacheFile.exists)
				{
					var urlRequest = new URLRequest(_serverLocation+"soundsave.php?snd="+_uploadList[_uploadListCurrent]+".mp3"); 
					urlRequest.method = URLRequestMethod.POST; 
					//cacheFile.addEventListener(ProgressEvent.PROGRESS, uploadProgress); 
					cacheFile.addEventListener(Event.COMPLETE, uploadSoundComplete); 
					cacheFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSoundError); 
					cacheFile.addEventListener(IOErrorEvent.IO_ERROR, uploadSoundError); 
					cacheFile.upload(urlRequest, "uploadfile");
				}
				else
				{
					uploadSoundComplete();
				}
			}
			else
			{
				uploadSoundComplete();
			}
		}
		
		private function uploadSoundComplete(event:Event = null):void 
		{
			_uploadListCurrent++;
			
			if (_uploadListCurrent < _uploadList.length)
			{
				postSoundData();
			}
			else
			{
				for each(var s:SectionData in _sectionList)
				{
					s.onServer = true;
				}
				
				for each(var t:ThumbData in _thumbList)
				{
					t.onServer = true;
				}
				
				_relay.dispatchEvent(new SystemMessageEvent("ok", -1, SystemMessageEvent.MESSAGE));
			}
		}
		
		private function uploadXMLError(event:Event):void
		{
			_relay.dispatchEvent(new SystemMessageEvent("Error Uploading XML.\nPlease check the save server location", 5000, SystemMessageEvent.MESSAGE));
		}
		
		private function uploadSoundError(event:Event):void 
		{
			Debug.warning("error uploading " + _uploadList[_uploadListCurrent] + ".mp3");
			_relay.dispatchEvent(new SystemMessageEvent("Error Uploading Sounds.\nPlease check the save server location", 5000, SystemMessageEvent.MESSAGE));
			
			uploadSoundComplete();
		}
		
		private function uploadImageError(event:Event):void 
		{
			Debug.warning("error uploading " + _uploadList[_uploadListCurrent] + ".jpg");
			_relay.dispatchEvent(new SystemMessageEvent("Error Uploading Images.\nPlease check the save server location", 5000, SystemMessageEvent.MESSAGE));

			uploadImageComplete();
		}
		
		private function setHistory(hx:String):void
		{
			if (hx.length > 6)
			{
				var so:Sharer = new Sharer(Main.SO_NAME);
				var historyData:String  = so.getSOData("h");

				if(historyData && historyData.length > 0)
					historyData += "," + hx;
				else
					historyData = hx;

				so.setSOData("h", historyData);
			}
		}
	}

}