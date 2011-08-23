package com.paulrauff.utils.validate 
{
	import com.carlcalderon.arthropod.Debug;
	import com.adobe.utils.*;

	import flash.display.DisplayObject;

	/**
	 * @author paulrauff
	 */
	public class Validate 
	{
		public static function element(obj:DisplayObject, msg:String = "", throwError:Boolean = true):DisplayObject
		{
			if(!obj)
			{
				const errorMesssage:String = "MISSING DISPLAY OBJECT IN IMPORTED SWF "+msg;
				
				Debug.error(errorMesssage);
				
				if(throwError)
					throw new Error(errorMesssage);
			}
			
			return obj;
		}
		
		public static function hasString(input:String):Boolean
		{
			input = input.split(" ").join("");
			input = input.split("\n").join("");
			input = input.split("\t").join("");
			
			return input.length > 0;
		}
	}
}
