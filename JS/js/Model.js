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

SVMain.Model = function(){
	var _xmlData;
	var _evt;
	var _currentPage = 0;
	var _currentSection = 0;
	var _indexFontSize = 14;
	var _indexThumbSize = 150;
	var _thumbData = new Array();
	var _sectionData = new Array();
	var _menuDown = true;
	var _touchTime = 300;
	
	SVMain.Model.XML_READY = "XML_READY";
	SVMain.Model.SECTION_READY = "SECTION_READY";
	SVMain.Model.ERROR_DEFAULT = "ERROR_DEFAULT";
		
	_Model();
	function _Model(){
		//console.log("Model ready");	
	}
	
	function loadXML()
	{		
		$.ajax({
			type: "GET",
			url: SVMain.XML_URL,
			cache:false,
			dataType:"xml",
			success: dataReceived,
			error: throwError

		});
			
		_evt = this.evt;
	}
	
	function dataReceived(data){
		//console.log("dataReceived");
		_xmlData = data;
		
		var thumbs = _xmlData.getElementsByTagName("thumb");
		var sections = _xmlData.getElementsByTagName("section");
		
		var indexNode = _xmlData.getElementsByTagName("index");
		_indexFontSize = indexNode[0].attributes.getNamedItem("fontsize").value;
		_indexThumbSize = indexNode[0].attributes.getNamedItem("thumbsize").value;
		
		var pages = null;
		var pageLen = 0;
		var pageThumbs = null;
		var pageThumbLen = 0;
		
		var len = thumbs.length;
		var ii = 0;
		var jj = 0;
		var kk = 0;
		var tid = 0;
		
		for(ii = 0; ii < len; ii++){

			if(thumbs[ii].attributes.getNamedItem("id").value){
				tid = thumbs[ii].attributes.getNamedItem("id").value;
				_thumbData[tid] = new SVMain.ThumbData(tid);
			}
			else{
				tid = 0;
				continue;
			}
			
			if(thumbs[ii].attributes.getNamedItem("com").value)
				_thumbData[tid].isCommon(thumbs[ii].attributes.getNamedItem("com").value);
			
			if(thumbs[ii].attributes.getNamedItem("scut").value)
				_thumbData[tid].isShortcut(thumbs[ii].attributes.getNamedItem("scut").value);

			if(thumbs[ii].childNodes.length > 0){
				_thumbData[tid].description(thumbs[ii].childNodes[0].nodeValue);
			}
		}
		
		len = sections.length;
		
		for(ii = 0; ii < len; ii++){
			
			if(sections[ii].attributes.getNamedItem("id").value){
				_sectionData[ii] = new SVMain.SectionData(sections[ii].attributes.getNamedItem("id").value);
			}
			else{			
				continue;
			}
			
			if(sections[ii].attributes.getNamedItem("name").value)
				_sectionData[ii].name(sections[ii].attributes.getNamedItem("name").value);
				
			if(sections[ii].attributes.getNamedItem("thumbsize").value)
				_sectionData[ii].thumbsize(sections[ii].attributes.getNamedItem("thumbsize").value);
				
			if(sections[ii].attributes.getNamedItem("fontsize").value)
				_sectionData[ii].fontsize(sections[ii].attributes.getNamedItem("fontsize").value);
				
			if(sections[ii].attributes.getNamedItem("bgcolour").value)
				_sectionData[ii].bgcolour(sections[ii].attributes.getNamedItem("bgcolour").value);
				
			pages = sections[ii].getElementsByTagName("page");
			pageLen = pages.length;
			
			for(jj = 0; jj < pageLen; jj++){
				//addThumbIDToPage(pid, thumbID, thumbIndex)
				
				pageThumbs = pages[jj].getElementsByTagName("t");
				pageThumbLen = pageThumbs.length;

				for(kk = 0; kk < pageThumbLen; kk++){
					_sectionData[ii].addThumbIDToPage(jj, pageThumbs[kk].attributes.getNamedItem("id").value, kk);
				}
			}
		}

		thumbs = null;
		sections = null;
		len = 0;
		pages = null;
		pageLen = 0;
		ii = 0;
		jj = 0;
		kk = 0;

		_evt.fire(SVMain.Model.XML_READY);
	}
	
	function loadSection(sid){
		var len = _sectionData.length;
		var ii = 0;
		
		for(ii = 0; ii < len; ii++){			
			if(_sectionData[ii].id() == sid){
				_currentSection = ii;
				break;
			}
		}
		
		_evt.fire(SVMain.Model.SECTION_READY);
	}
	
	function loadPage(pid){
		if(pid >= 0 && pid < _sectionData[_currentSection].pageTotal()){
			_currentPage = pid;
			_evt.fire(SVMain.Model.SECTION_READY);
		}
	}
	
	function getCurrentThumbIDs(){
		return _sectionData[_currentSection].getThumbList(_currentPage);		
	}
	
	function getSectionData(){
		return _sectionData;
	}
	
	function currentSectionData(){
		
		if(!_sectionData[_currentSection]){
			throwError();
		}
		
		return _sectionData[_currentSection];
	}
	
	function getThumbDescription(tid){
		return _thumbData[tid].description();		
	}
	
	function getIndexThumbSize(){
		return _indexThumbSize;
	}
	
	function getIndexFontSize(){
		return _indexFontSize;
	}
		
	function getCurrentFontSize(){
		return currentSectionData().fontsize();
	}
	
	function getCurrentThumbSize(){
		return currentSectionData().thumbsize();
	}
	
	function getCurrentBGColour(){
		return currentSectionData().bgcolour();
	}
	
	function getCurrentSectionName(){
		return currentSectionData().name();
	}
	
	function getCurrentPage(){
		return _currentPage;
	}
	
	function getCurrentSectionPageTotal(){
		return currentSectionData().pageTotal();
	}

	var getThumbShortcut = function(tid){
		return _thumbData[tid].isShortcut();
	}
	
	var getTouchTime = function(){
		return _touchTime;
	}
	
	var menuDown = function(){
		if(arguments[0])
		{
			_menuDown = arguments[0];
		}
		
		return _menuDown;
	}
	
	function throwError(){
		_evt.fire(SVMain.Model.ERROR_DEFAULT);
	}
	
	return{
		loadXML:loadXML,
		thumbData:_thumbData,
		sectionData:_sectionData,
		getCurrentPage:getCurrentPage,
		currentSection:_currentSection,
		getSectionData:getSectionData,
		loadSection:loadSection,
		loadPage:loadPage,
		getCurrentThumbIDs:getCurrentThumbIDs,
		getThumbDescription:getThumbDescription,
		getCurrentThumbSize:getCurrentThumbSize,
		getCurrentFontSize:getCurrentFontSize,
		getCurrentBGColour:getCurrentBGColour,
		getCurrentSectionName:getCurrentSectionName,
		getCurrentSectionPageTotal:getCurrentSectionPageTotal,
		getThumbShortcut:getThumbShortcut,
		getIndexThumbSize:getIndexThumbSize,
		getIndexFontSize:getIndexFontSize,
		getTouchTime:getTouchTime,
		menuDown:menuDown,
		evt:SVMain.Event()
	}
}
