/**
 * @author Paul
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
	
	SVMain.Model.XML_READY = "XML_READY";
	SVMain.Model.SECTION_READY = "SECTION_READY";
	SVMain.Model.ERROR_DEFAULT = "ERROR_DEFAULT";
		
	_Model();
	function _Model(){
		//console.log("Model ready");	
	}
	
	function loadXML()
	{
		//console.log(">loadXML "+SVMain.XML_URL);
		
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
		
		for(ii = 0; ii < len; ii++){			
			if(_sectionData[ii].id() == sid){
				_currentSection = ii;
				break;
			}
		}
		
		_evt.fire(SVMain.Model.SECTION_READY);
	}
	
	function loadPage(pid){
		//console.log("loadpage : "+_currentPage +" :: "+ pid +" :: "+ _sectionData[_currentSection].pageTotal());
		
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
		menuDown:menuDown,
		evt:SVMain.Event()
	}
}
