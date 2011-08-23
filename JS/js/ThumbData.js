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