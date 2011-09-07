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

SVMain.View = function(){

	var _c = null;
	var _evt;
	var _thumbHTML = "";
	var _audio;
	var _isTouch = false;
	var _moveX = 0;

	SVMain.View.THUMB_INDEX_CLICKED = "THUMB_INDEX_CLICKED";
	SVMain.View.THUMB_CLICKED = "THUMB_CLICKED";
	SVMain.View.THUMB_TOUCH_START = "THUMB_TOUCH_START";
	SVMain.View.THUMB_TOUCH_MOVE = "THUMB_TOUCH_MOVE";
	SVMain.View.THUMB_TOUCH_END = "THUMB_TOUCH_END";
	SVMain.View.MENU_CLICKED = "MENU_CLICKED";
	SVMain.View.PAGE_UP = "PAGE_UP";

	_View();
	function _View(){
		//console.log("View ready");
		
		$("#menu_holder").html("");
	}
	
	function init(){
		//console.log(screen.height);
		
		_evt = this.evt;
		_isTouch = isTouch();
		_audio = document.createElement('audio');
		
		$("#menu_holder").click(function () {
			_evt.fire(SVMain.View.MENU_CLICKED);
	    });
	    
		document.getElementById("thumb_holder").ontouchstart = function(e){return evtHandler(e);};
		document.getElementById("thumb_holder").ontouchmove = function(e){return evtHandler(e);};
		document.getElementById("thumb_holder").ontouchend = function(e){return evtHandler(e);};
	}
	
	function isTouch() {  
	  try {  
	    document.createEvent("TouchEvent");  
	    return true;  
	  } catch (e) {  
	    return false;  
	  }  
	}
	
	function evtHandler(event, thumbID)
	{
		event.preventDefault();
		event.stopPropagation();
		event.cancelBubble = true;
		event.returnValue = false;
		
		//console.log(event.type);
		
		switch(event.type)
		{
			case "touchstart":
				_evt.fire(SVMain.View.THUMB_TOUCH_START, thumbID, event.targetTouches[0].pageX, event.targetTouches[0].pageY);
				break;
			case "touchmove": 
				_evt.fire(SVMain.View.THUMB_TOUCH_MOVE, thumbID, event.targetTouches[0].pageX, event.targetTouches[0].pageY);
				break;        
			case "touchend":
				_evt.fire(SVMain.View.THUMB_TOUCH_END, thumbID);
				break;
			case "mousedown":
				_evt.fire(SVMain.View.THUMB_TOUCH_START, thumbID, event.pageX, event.pageY);
				break;
			case "mouseup":
				_evt.fire(SVMain.View.THUMB_TOUCH_END, thumbID);
				break;
			case "click":
				break;
			default: return false;
		}
		
		return false;
	}
	
	function setMenu(isDown){
		if(isDown){
			$("#index_holder").slideDown('medium');
		}
		else{
			$("#index_holder").slideUp('fast');
		}
	}
	
	function setBGColour(clr){
		$("body").css("background-color", clr);
	}
	
	function setPageData(currentPage, totalPages){
		var pd = "<a href='#'>page "+currentPage+" of "+totalPages+"</a>";
		
		$("#page_data").html(pd);
		$("#page_data").click(function(e){_evt.fire(SVMain.View.PAGE_UP); return false;});
	}
	
	function setCurrentSectionName(name){
		
		$("#menu_holder").html(name);
	}
	
	function addThumbs(html){
		$("#thumb_holder").hide();
		$("#thumb_holder").fadeIn("medium");
		$("#thumb_holder").html(html);
	}
	
	function addIndex(html){
		$("#index_holder").html(html);

	}	
	
	function addSections(html){
		$("#index_holder").html(html);
	}
	
	function setIndexThumbEvent(index, thumbID){
		var cssID = index+"_"+thumbID;
		
		$("#"+cssID).mouseup(function(){
			_evt.fire(SVMain.View.THUMB_INDEX_CLICKED, thumbID);
			_evt.fire(SVMain.View.MENU_CLICKED, false);
		});
	}
	
	function setThumbEvent(index, thumbID){
		var cssID = index+"_"+thumbID;

		if(_isTouch){
			document.getElementById(cssID).ontouchstart = function(e){return evtHandler(e, thumbID);};
			document.getElementById(cssID).ontouchmove = function(e){return evtHandler(e, thumbID);};
			document.getElementById(cssID).ontouchend = function(e){return evtHandler(e, thumbID);};
		}
		else{
			$("#"+cssID).mousedown(function(e){return evtHandler(e, thumbID);});
			$("#"+cssID).mouseup(function(e){return evtHandler(e, thumbID);});
		}
	}
	
	function removeThumbEvent(index, thumbID){
		var cssID = index+"_"+thumbID;

		if(_isTouch){
			document.getElementById(cssID).ontouchstart = null;
			document.getElementById(cssID).ontouchmove = null;
			document.getElementById(cssID).ontouchend = null;
		}
		else{
			$("#"+cssID).unbind('click');
		}
	}
	
	function initSound(tid){
		console.log("initSound");
		_audio.pause();
		_audio.position = 0;
		_audio.src = "1/sound/"+tid+".mp3";
		_audio.load();
	}

	function playSound(tid){
		_audio.pause();
		_audio.position = 0;
		_audio.play();
		console.log(_audio.src);
	}
	
	function moveThumbs(thumbX){
		$("#thumb_holder").css("left", thumbX);
	}
	
	function setThumbSpinner(html, animTime){
		$(".spinner_animation").remove();
		$("#thumb_spinner").before(html);
		$(".spinner_animation").css("-webkit-animation-duration", animTime+"s");
	}
	
	function scrollVertical(scrollY){
		var top = $("#thumb_holder").scrollTop();
		$("#thumb_holder").scrollTop(top + scrollY);
	}
	
	function getCellHTML(index, id, thumbsize, fontsize, txt){
		var titleBoxHeight = Number(fontsize) + 6;
		
		var thumbHTML = "<div class='thumb' id='"+index+"_"+id+"' style='width:"+thumbsize+"px; height:"+thumbsize+"px'>";
		thumbHTML += "<img src='1/img/"+id+".jpg' class='thumb_image' />";
		
		if(txt)
			thumbHTML += "<div style='font-size:"+fontsize+"px; height:"+titleBoxHeight+"px; margin-top:-"+titleBoxHeight+"px;' class='thumb_title'>&nbsp;"+txt+"&nbsp;</div>";
	
		thumbHTML += "</div>";
		
		return thumbHTML;
	}
	
	function onError(){
		$("body").html("<br/><br/><br/>Uh oh! An error has occured. Please refresh and try again...");
	}
	
	function destroy(){
		var ii = 0;
		
		$("#page_data").unbind('click');
		$("#page_data").html("");
		
		var len = _audio.length;
		
		for(ii = 0; ii < len; ii++){
			_audio[ii] = null;
		}
	}

	return{
		init:init,
		addIndex:addIndex,
		addThumbs:addThumbs,
		setThumbEvent:setThumbEvent,
		removeThumbEvent:removeThumbEvent,
		setIndexThumbEvent:setIndexThumbEvent,
		setMenu:setMenu,
		initSound:initSound,
		playSound:playSound,
		setBGColour:setBGColour,
		setPageData:setPageData,
		setCurrentSectionName:setCurrentSectionName,
		getCellHTML:getCellHTML,
		moveThumbs:moveThumbs,
		setThumbSpinner:setThumbSpinner,
		scrollVertical:scrollVertical,
		destroy:destroy,
		onError:onError,
		evt:SVMain.Event()
	}
}