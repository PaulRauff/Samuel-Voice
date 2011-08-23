/**
 * @author Paul
 */

SVMain.Event = function(){
	var _callbacks = new Array();
	
	_Event();
	function _Event(){
		//console.log("Event ready");	
	}
	
	function addListener(name, func){
		////console.log("addListener "+name);
		_callbacks[name] = func;
	}
	
	function removeListener(name, func){
		if(_callbacks[name]){
			_callbacks[name] = null;
		}
	}
	
	function fire(name){		
		if(typeof _callbacks[name] == "function"){
			_callbacks[name](arguments);
		}
	}
	
	return{
		fire:fire,
		addListener:addListener,
		removeListener:removeListener
	}
}
