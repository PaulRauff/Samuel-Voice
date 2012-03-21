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

SVMain.SectionData = function(id){
	var _id = id;
	var _name = "";
	var _thumbsize =150;
	var _fontsize = 12 
	var _bgcolour = '6750207';
	var _page = new Array();
	var _totalPages = 0;

	function addThumbIDToPage(pid, thumbID, thumbIndex){
		if(pid > _totalPages)
			_totalPages = pid;

		if(!_page[pid]){
			_page[pid] = new Array();
		}
		
		console.log(pid +"::"+_page[pid]);
		
		_page[pid][thumbIndex] = thumbID;
	}
	
	function getThumbList(pid){
		return 	_page[pid];	
	}
		
	//GETTERS SETTERS
	var id = function(){
		if(arguments[0]){
			_id = arguments[0];
		}

		return _id;
	}
	
	var name = function(){
		if(arguments[0]){
			_name = arguments[0];
			_name = _name.replace("`", "'");
		}

		return _name;
	}
	
	var thumbsize = function(){
		if(arguments[0]){
			_thumbsize = arguments[0];
		}

		return _thumbsize;
	}
	
	var fontsize = function(){
		if(arguments[0]){
			_fontsize = arguments[0];
		}

		return _fontsize;
	}
	
	var bgcolour = function(){
		if(arguments[0]){
			_bgcolour = arguments[0];
		}

		return "#"+_bgcolour;
	}
	
	var pageTotal = function(){
		return _totalPages + 1;
	}
	
	return{
		id:id,
		name:name,
		thumbsize:thumbsize,
		fontsize:fontsize,
		bgcolour:bgcolour,
		pageTotal:pageTotal,
		addThumbIDToPage:addThumbIDToPage,
		getThumbList:getThumbList
	}
}