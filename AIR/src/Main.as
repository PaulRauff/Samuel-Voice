package  
{
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

	import flash.display.*;
	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.view.*;	 
	 
	public class Main extends Sprite
	{
		private static var _main:Main;
		
		public static const XML_VERSION:Number = 0.2;
		public static const TILE_LIST_WIDTH:int = 900;
		public static const TILE_LIST_HEIGHT:int = 675;
		public static const MAX_IMAGE_FILE_WIDTH:int = 500;
		public static const DEFAULT_THUMB_SIZE:int = 150;
		public static const DEFAULT_FONT_SIZE:int = 14;
		public static const DESCRIPTION_DEFAULT_TEXT:String = "add a description here";
		public static const TITLE_DEFAULT_TEXT:String = "add a section name here";
		public static const SO_NAME:String = "history";

		/**
		**Singleton entry point
		**/
		public static function getInstance() : Main 
		{
			if(Main._main == null)
				Main._main = new Main();
			
			return Main._main;
        }
		
		/**
		**Set up Main
		**/
		public function Main():void
		{
			if(Main._main == null)
			{
				Main._main = this;

				//uses: http://arthropod.stopp.se/
				Debug.password = "comprido";
				Debug.clear();	
				Debug.log("DEBUG READY");

				const view:View = new View();
			}
			else
			{
				Debug.warning("Main is singleton, already exists");
			}
		}
	}
}