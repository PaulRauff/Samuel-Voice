package  
{
	import flash.display.*;
	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.view.*;

	/**
	 * @author paulrauff
	 */
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