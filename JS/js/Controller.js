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

SVMain.Controller = function(){
	
	var _m = null;
	var _v = null;
	
	var _startMoveX = 0;
	var _startMoveY = 0;
	var _moveX = 0;
	var _moveY = 0;
	
	_Controller();
	function _Controller(){
		//console.log("Controller ready");
		
		_v = new SVMain.View();
		_v.init();
		_v.evt.addListener(SVMain.View.THUMB_CLICKED, onThumbClicked);
		_v.evt.addListener(SVMain.View.THUMB_INDEX_CLICKED, onThumbIndexClicked);
		_v.evt.addListener(SVMain.View.MENU_CLICKED, onMenuClicked);
		_v.evt.addListener(SVMain.View.THUMB_TOUCH_START, onThumbTouchStart);
		_v.evt.addListener(SVMain.View.THUMB_TOUCH_MOVE, onThumbTouchMove);
		_v.evt.addListener(SVMain.View.THUMB_TOUCH_END, onThumbTouchEnd);
		_v.evt.addListener(SVMain.View.SECTION_LOAD, quickLoadSection);
		_v.evt.addListener(SVMain.View.PAGE_UP, pageUp);

		_m = new SVMain.Model();	
			
		_m.evt.addListener(SVMain.Model.XML_READY, onXMLReady);
		_m.evt.addListener(SVMain.Model.SECTION_READY, onSectionReady);
		_m.evt.addListener(SVMain.Model.ERROR_DEFAULT, _v.onError);
		
		_m.loadXML();
		
	}
	
	function onXMLReady(args){
		//console.log("onXMLReady ");

		//loop through the thumbdata and generate the html
		setAudio();		
		setSections();
		setThumbs();
	}
	
	function onSectionReady(args){
		setThumbs();		
	}
	
	function setAudio(){
		var ta = _m.getAllThumbIDs();
		var len = ta.length;
		var h = "";
		
		for (var ii = 0; ii < len; ii++){
			h += _v.getAudioHtml(ii, ta[ii]);
		}
		
		_v.addAudio(h);
	}
	
	function setSections(){
		var sectionList = _m.getSectionData();
		var len = sectionList.length;
		var thumbHTML = "";
		var ii = 0;
		
		for(ii = 1; ii < len; ii++){
			thumbHTML += _v.getCellHTML(ii, sectionList[ii].id(), _m.getIndexThumbSize(), _m.getIndexFontSize(), sectionList[ii].name(), false);
		}
		
		_v.addIndex(thumbHTML);
		
		for(ii = 0; ii < len; ii++){
			_v.setIndexThumbEvent("i_"+ii, sectionList[ii].id());
		}
	}
	
	function setThumbs(){
		var thumbIDList = _m.getCurrentThumbIDs();
		var len = thumbIDList.length;
		var thumbHTML = "";
		var ii = 0;
		var thumbsize = _m.getCurrentThumbSize();
		var fontsize = _m.getCurrentFontSize();
				
		for(ii = 0; ii < len; ii++){			
			thumbHTML += _v.getCellHTML(ii, thumbIDList[ii], thumbsize, fontsize, _m.getThumbDescription(thumbIDList[ii]), true);
		}

		_v.addThumbs(thumbHTML);
		_v.moveThumbs(0);
		setMenuState();
		
		thumbReset();
		
		for(ii = 0; ii < len; ii++){
			_v.setThumbEvent(ii, thumbIDList[ii]);
		}
		
		setPageData();
	}
	
	function pageUp(){
		var p = _m.getCurrentPage() + 1;
		
		if(p >= _m.getCurrentSectionPageTotal())
			p = 0;

		loadPage(p);
	}

	function thumbReset(){
		var thumbIDList = _m.getCurrentThumbIDs();
		var len = thumbIDList.length;
		
		for(ii = 0; ii < len; ii++){
			_v.removeThumbEvent("t_"+ii, thumbIDList[ii]);
		}
	}

	function onThumbTouchStart(args){
		if(args.length === 4){
			_startMoveX = _moveX = args[2];
			_startMoveY = _moveY = args[3];
		}
	}

	function onThumbTouchMove(args){

		var mv = _startMoveX - _moveX;
		var cp = _m.getCurrentPage() +1;
		
		_moveX = args[2];
		_moveY = args[3];
	
		if((mv > 0 && cp < _m.getCurrentSectionPageTotal()) 
		|| (mv < 0 && cp > 1)){
			if(mv < -400){
				//page right
				loadPage(_m.getCurrentPage() - 1);
			}else if(mv > 400){
				//page left
				loadPage(_m.getCurrentPage() + 1);
			}else if(Math.abs(mv) > 20){
				_v.moveThumbs(-mv);
			}
		}

		_v.scrollVertical(_startMoveY - args[3]);
	}

	function onThumbTouchEnd(args){

		var mvx = Math.abs(_startMoveX - _moveX);
		var mvy = Math.abs(_startMoveY - _moveY);

		if(mvy < 30 && mvx < 30){
			onThumbClicked(args);
		}
			
		if(mvx < 400){
			_v.moveThumbs(0);
		}

		_moveX = 0;
		_startMoveX = 0;
		_startTouchID = 0;
	}
	
	function onMenuClicked(args){
		
		if(args[1]){
			_m.menuDown == args[1];
		}
		else{
			_m.menuDown = !_m.menuDown;
		}
		
		setMenuState();
		_v.setMenu(_m.menuDown);
	}

	function onThumbIndexClicked(args){
		var tid = args[1];
		loadSection(tid);
	}
	
	function onThumbClicked(args){

		var tid = args[1];

		if(_m.getThumbShortcut(tid)){
			loadSection(tid);
		}
		else{			
			_v.playSound(tid);
		}
	}
		
	function setMenuState(){
		if(_m.menuDown){
			_v.setCurrentSectionName("menu");
			_v.setBGColour("#cccccc");
		}
		else{
			_v.setCurrentSectionName(_m.getCurrentSectionName);
			_v.setBGColour(_m.getCurrentBGColour());
		}
	}
	
	function setPageData(){		
		_v.setPageData(_m.getCurrentPage()+1, _m.getCurrentSectionPageTotal());
	}
	
	function quickLoadSection(args){		
		_m.quickLoadSection(args[1]);
		setMenuState();
	}

	function loadSection(tid){
		_v.destroy();
		_m.loadSection(tid);
	}
	
	function loadPage(pid){
		_v.destroy();
		_m.loadPage(pid);
	}	
}
