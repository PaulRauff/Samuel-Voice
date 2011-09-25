package com.comprido.imagetool.view 
{
	/**
	 * ...
	 * @author Paul
	 */
	
	import com.comprido.imagetool.controller.*;
	import flash.display.*;
	import flash.text.*;
	 
	public class ShortcutsView extends SectionView
	{
		[Embed(source="..//..//..//..//..//bin//skin.swf",symbol="BMPStar")]
		private var StarSWF:Class;
		
		public function ShortcutsView(section:int, page:int, c:Controller) 
		{
			super(section, page, c);
		}

		protected override function init():void 
		{
			super.init();
			
			_section_delete_btn.visible = false;
			_title_txt.type = TextFieldType.DYNAMIC;
		}
		
		protected override function setSectionImg():void 
		{
			var favIcon:Bitmap = new StarSWF();
			_section_thumb_holder_uil.source = favIcon;
		}
	}

}