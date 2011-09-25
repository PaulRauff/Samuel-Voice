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
	var _timeout;

	SVMain.View.THUMB_INDEX_CLICKED = "THUMB_INDEX_CLICKED";
	SVMain.View.THUMB_CLICKED = "THUMB_CLICKED";
	SVMain.View.THUMB_TOUCH_START = "THUMB_TOUCH_START";
	SVMain.View.THUMB_TOUCH_MOVE = "THUMB_TOUCH_MOVE";
	SVMain.View.THUMB_TOUCH_END = "THUMB_TOUCH_END";
	SVMain.View.MENU_CLICKED = "MENU_CLICKED";
	SVMain.View.PAGE_UP = "PAGE_UP";
	SVMain.View.SECTION_LOAD = "SECTION_LOAD";

	_View();
	function _View(){
		//console.log("View ready");
		
		$("#section_name").html("");
	}
	
	function init(){
		_evt = this.evt;
		_isTouch = isTouch();
		_audio = document.createElement('audio');
		_audio.preload = "auto";
		
		$("#menu_holder").click(function () {
			_evt.fire(SVMain.View.MENU_CLICKED);			
	    });
	    
		$("#menu_img_fav").click(function () {
			$("#index_holder").slideUp('fast');
			_evt.fire(SVMain.View.SECTION_LOAD, 0);
	    });
	    
		$("#menu_img_home").click(function () {
			_evt.fire(SVMain.View.MENU_CLICKED);
			//$("#index_holder").slideDown('medium');
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
		//console.log(event.type);
		defaultBlocker (event);
		
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
	
	function defaultBlocker (event) {
		event.preventDefault();
		event.stopPropagation();
		event.cancelBubble = true;
		event.returnValue = false;
	}
	
	function setMenu(isDown){
		if(isDown){
			$("#index_holder").slideDown('medium');
		}
		else{
			$("#index_holder").slideUp('fast');
		}
	}
	
	function getAudioHtml(index, id){
		return "<audio id='s_"+index+"_"+id+"' src='1/sound/"+id+".mp3' preload='auto' loop='false' />";
	}
	
	function addAudio(html){		
		$("body").append(html);		
	}
	
	function setBGColour(clr){
		$("body").css("background-color", clr);
	}
	
	function setPageData(currentPage, totalPages){
		if(totalPages > 1){
			var pd = "<a href='#' id='page_link'>page "+currentPage+" of "+totalPages+"</a>";
			$("#page_data").html(pd);
			$("#page_data").click(function(e){_evt.fire(SVMain.View.PAGE_UP); return false;});
		}
		
		//if on page 1 and more pages, show right arrow
		if(currentPage === 1 && totalPages > 1){
			$("body").css("background-image", "url(img/arrow_right.png)");
			$("body").css("background-position", "right center");
		}//if on last page and more than 1 pages, show left arrow
		else if(currentPage === totalPages && totalPages > 1){
			$("body").css("background-image", "url(img/arrow_left.png)");
			$("body").css("background-position", "left center");
		}//if on any page other than first, show both arrows (prev if supercedes)
		else if(currentPage > 1){
			$("body").css("background-image", "url(img/arrow_left.png), url(img/arrow_right.png)");
			$("body").css("background-position", "left center, right center");
		}
		else{
			$("body").css("background-image", "");
			$("body").css("background-position", "");
		}
		
	}
	
	function setCurrentSectionName(name){
		
		$("#section_name").html(name);
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
		var cssID = "t_"+index+"_"+thumbID;

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

	function playSound(tid){
		_audio.pause();
		_audio.src = "1/sound/"+tid+".mp3";
		_audio.position = 0;
		
		 _audio.addEventListener('loadedmetadata', loadedAudioMetadata, false);
		  _audio.addEventListener('ended', hideLightBox, false); 

		_audio.play();
	}
	
	function loadedAudioMetadata(){
		document.getElementById("light_box").ontouchstart = function(e){return defaultBlocker(e);};
		
		$('#light_box').addClass("light_box");
		
		_timeout = setTimeout(hideLightBox, 5000);
	}
	
	
	function hideLightBox(){
		clearTimeout(_timeout);
		_timeout = null;
		$('#light_box').removeClass("light_box");
	}

	function moveThumbs(thumbX){
		$("#thumb_holder").css("left", thumbX);
	}

	function scrollVertical(scrollY){
		var top = $("#thumb_holder").scrollTop();
		$("#thumb_holder").scrollTop(top + scrollY);
	}
	
	function getCellHTML(index, id, thumbsize, fontsize, txt, hasAudio){
		var titleBoxHeight = Number(fontsize) + 6;
		
		var idPrefix = "i_";
		
		if(hasAudio){
			idPrefix = "t_";
		}
		
		var thumbHTML = "<div class='thumb' id='"+idPrefix+index+"_"+id+"' style='width:"+thumbsize+"px; height:"+thumbsize+"px'>";

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
		
		//_audio = null;
	}

	return{
		init:init,
		getAudioHtml:getAudioHtml,
		addAudio:addAudio,
		addIndex:addIndex,
		addThumbs:addThumbs,
		setThumbEvent:setThumbEvent,
		removeThumbEvent:removeThumbEvent,
		setIndexThumbEvent:setIndexThumbEvent,
		setMenu:setMenu,
		playSound:playSound,
		setBGColour:setBGColour,
		setPageData:setPageData,
		setCurrentSectionName:setCurrentSectionName,
		getCellHTML:getCellHTML,
		moveThumbs:moveThumbs,
		scrollVertical:scrollVertical,
		destroy:destroy,
		onError:onError,
		evt:SVMain.Event()
	}
}