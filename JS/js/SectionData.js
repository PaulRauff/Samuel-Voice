SVMain.SectionData = function(id){
	var _id = id;
	var _name = "";
	var _thumbsize =150;
	var _fontsize = 12 
	var _bgcolour = '6750207';
	var _page = [new Array(), new Array()];
	var _totalPages = 0;

	function addThumbIDToPage(pid, thumbID, thumbIndex){
		if(pid > _totalPages)
			_totalPages = pid;

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