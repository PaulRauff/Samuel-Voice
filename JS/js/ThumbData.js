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

SVMain.ThumbData = function(id){
	var _id = id;
	var _isShortcut = false;
	var _isCommon = false;
	var _description = "";
	
	_ThumbData()
	function _ThumbData(){
		
	}
	
	var id = function(){		
		if(arguments[0])
		{
			_id = arguments[0];
		}

		return _id;
	}
	
	var isShortcut = function(){
		if(arguments[0])
		{
			_isShortcut = Boolean(Number(arguments[0]));
		}
		
		return _isShortcut;	
	}
	
	var isCommon = function(){
		if(arguments[0])
		{
			_isCommon = Boolean(Number(arguments[0]));
		}
		
		return _isCommon;
	}

	
	var description = function(){
		if(arguments[0])
		{
			_description = arguments[0];
			_description = _description.replace("`", "'");
		}
		
		return _description;
	}
	
	return {
		description:description,
		isCommon:isCommon,
		isShortcut:isShortcut,
		id:id
	}
}