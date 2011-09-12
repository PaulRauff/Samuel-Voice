package com.paulrauff.utils.greyscale
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class Greyscale
	{
		
		public function Greyscale()
		{
		
		}
		
		public static function apply(dispObj:DisplayObject, enabled:Boolean = true):void
		{
			var rc:Number = 1 / 3;
			var gc:Number = 1 / 3;
			var bc:Number = 1 / 3;
			var cmf:ColorMatrixFilter = new ColorMatrixFilter([rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, rc, gc, bc, 0, 0, 0, 0, 0, 1, 0]);
			
			if (enabled)
			{
				dispObj.filters = [cmf];
			}
			else
			{
				dispObj.filters = [];
			}
		}
	}

}