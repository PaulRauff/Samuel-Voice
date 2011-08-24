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
	var _startTouchTime = 0;
	
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
		setSections();
		setThumbs();
	}
	
	function onSectionReady(args){
		setThumbs();		
	}
	
	function setSections(){
		var sectionList = _m.getSectionData();
		var len = sectionList.length;
		var thumbHTML = "";
		var ii = 0;
		
		for(ii = 0; ii < len; ii++){
			thumbHTML += _v.getCellHTML("i_" + ii, sectionList[ii].id(), _m.getIndexThumbSize(), _m.getIndexFontSize(), sectionList[ii].name());
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
			thumbHTML += _v.getCellHTML("t_" + ii, thumbIDList[ii], thumbsize, fontsize, _m.getThumbDescription(thumbIDList[ii]));
		}

		_v.addThumbs(thumbHTML);
		_v.moveThumbs(0);
		setMenuState();
		
		thumbReset();
		
		for(ii = 0; ii < len; ii++){
			_v.setThumbEvent("t_"+ii, thumbIDList[ii]);
		}
		
		setPageData();
	}
	
	function pageUp(){
		var p = _m.getCurrentPage() + 1;
		
		if(p >= _m.getCurrentSectionPageTotal())
			p = 0;

		loadPage(p);
	}
	
	function startSpinner(thumbID, fingerX, fingerY){
		var spinTime = 2;
		var dotCount = 15;
		var angIncr = Math.PI*2/ dotCount;
		var delayIncr = spinTime/dotCount;
		var currAng = Math.PI;
		var delay = 0;		
		var radius = 80;
		//fingerX = 200;
		//fingerY = 200;
		var html = "";
		
		while(currAng < Math.PI*3){
			var xpt = radius * Math.cos(currAng) + fingerX;
			var ypt = radius * Math.sin(currAng) + fingerY;
			
			delay += delayIncr;
			
			html += "<div class='spinner_animation' style='left:"+xpt+"px; top:"+ypt+"px; -webkit-animation-delay: "+delay+"s;'></div>";
			
			currAng += angIncr;
		}
		
		_v.setThumbSpinner(html);
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
			_v.initSound("1/sound/"+args[1]+".mp3");
			_startMoveX = args[2];
			
			console.log(args[1] +" :: "+ args[2] +" :: "+ args[3]);
			startSpinner(args[1], args[2], args[3]);
			
			_startTouchTime = new Date().getTime();
		}
	}

	function onThumbTouchMove(args){
		
		_moveX = args[2];
		var mv = _startMoveX - _moveX;
		var cp = _m.getCurrentPage() +1;
	
		if((mv > 0 && cp < _m.getCurrentSectionPageTotal()) 
		|| (mv < 0 && cp > 1)){
			if(mv < -500){
				//page right
				loadPage(_m.getCurrentPage() - 1);
			}else if(mv > 500){
				//page left
				loadPage(_m.getCurrentPage() + 1);
			}else{
				_v.moveThumbs(-mv);
			}
		}
		
		_v.setThumbSpinner("");
	}

	function onThumbTouchEnd(args){
				
		var mv = Math.abs(_startMoveX - _moveX);
		
		if(mv < 500 || _moveX === 0){
			_v.moveThumbs(0);
						
			if(_moveX === 0 && args.length >= 1){
				onThumbClicked(args);
			}
		}
		
		_startTouchTime = 0;
		_moveX = 0;
		_startMoveX = 0;
		
		_v.setThumbSpinner("");
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
		}else{
			
			if((_startTouchTime + _m.getTouchTime()) <= new Date().getTime()){}
				_v.playSound();
			}
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
		startSpinner(1601314125699681, 200, 200);
		
		if(_m.getCurrentSectionPageTotal() > 1)
			_v.setPageData(_m.getCurrentPage()+1, _m.getCurrentSectionPageTotal());
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
