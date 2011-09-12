package com.comprido.imagetool.view 
{
	import com.comprido.imagetool.controller.Controller;
	import com.comprido.imagetool.events.NewBitmapDataEvent;
	import fl.controls.listClasses.ImageCell;
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.controls.TileList;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import com.paulrauff.utils.validate.*;
	import com.carlcalderon.arthropod.Debug;
	
	/**
	 * ...
	 * @author Paul
	 */
	public class ImageBrowserView extends Sprite 
	{		
		private var _base:Sprite;
		private var _browse_btn:SimpleButton;
		private var _close_btn:SimpleButton;
		private var _input_txt:TextField;
		private var _no_folder_images_mc:MovieClip;
		private var _tilelist:fl.controls.TileList;
		private var _directory:File;
		private var _c:Controller;
		
		[Embed(source="..//..//..//..//..//bin//skin.swf",symbol="ImageBrowseLib")]
		private var ImageBrowseSWF:Class;
		
		
		public function ImageBrowserView(c:Controller) 
		{
			_c = c;
			init();
		}
		
		private function init():void 
		{
			_base = new ImageBrowseSWF();
			addChild(_base);
			
			_browse_btn = SimpleButton(Validate.element(_base["browse_btn"], "browse_btn missing"));
			_close_btn = SimpleButton(Validate.element(_base["close_btn"], "close_btn missing"));
			_input_txt = TextField(Validate.element(_base["input_txt"], "input_txt missing"));
			_no_folder_images_mc = MovieClip(Validate.element(_base["no_folder_images_mc"], "no_folder_images_mc missing"));

			_tilelist = new fl.controls.TileList();
			_tilelist.name = "FileImagesHolder";
			
			_tilelist.doubleClickEnabled = true;
			_tilelist.mouseEnabled = true;

			_tilelist.move(126,120); 
			_tilelist.rowCount = 999; 
			_tilelist.columnCount = 6;
			_tilelist.columnWidth = 120;
			_tilelist.rowHeight = 120;
			_tilelist.width = 775; 
			_tilelist.height = 550;

			_tilelist.setRendererStyle("imagePadding", 0);
			
			_tilelist.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tilelist.verticalScrollPolicy = ScrollPolicy.ON;
			_tilelist.scrollPolicy = ScrollPolicy.ON;
			_tilelist.direction = ScrollBarDirection.VERTICAL;
			
			_tilelist.addEventListener(MouseEvent.DOUBLE_CLICK, _c.onImageBrowserDoubleClick);
			_browse_btn.addEventListener(MouseEvent.CLICK, directoryOpen);
			_close_btn.addEventListener(MouseEvent.CLICK, _c.closeImageBrowser);
		
			_c.relay.addEventListener(NewBitmapDataEvent.BITMAP_DATA, _c.closeImageBrowser);
			
			_base.addChild(_tilelist);
			
			initDirectory();
		}
		
		private function initDirectory():void 
		{
			_directory = new File();
			
			var durl:String = _c.imageBrowseDirectory;

			if(!durl)
				_directory = File.documentsDirectory;
			else
				_directory.url = durl;	

			displayDirectory();
		}
		
		private function directoryOpen(event:MouseEvent):void
		{
			Main.getInstance().stage.focus = _input_txt;
            _directory.browseForDirectory("Please select an image directory...");
			_directory.addEventListener(Event.SELECT, directorySelected);			
		}
		
		private function directorySelected(event:Event):void 
		{
			_directory = event.target as File;
			displayDirectory();
		}
		
		private function displayDirectory():void
		{
			_input_txt.text = _directory.nativePath;
			_c.imageBrowseDirectory = _directory.url;
			
			var files:Array = _directory.getDirectoryListing();
			var filesAdded:int = 0;
			
			_tilelist.removeAll();
			
			for(var ii:int = 0; ii < files.length; ii++)
			{
				if (files[ii].extension && (files[ii].extension.toLowerCase() == "jpg" || files[ii].extension.toLowerCase() == "gif" || files[ii].extension.toLowerCase() == "png"))
				{
					try
					{
						_tilelist.addItem( { label:files[ii].name, source:files[ii].url } );
						filesAdded++;
					}
					catch (error:Error)
					{
						Debug.error("ImageBrowserView.directorySelected :: "+error);
					}
				}
			}

			_no_folder_images_mc.visible = !(filesAdded > 0);
		}
		
		public function destroy():void
		{
			_tilelist.removeEventListener(MouseEvent.DOUBLE_CLICK, _c.onImageBrowserDoubleClick);
			_browse_btn.removeEventListener(MouseEvent.CLICK, directoryOpen);
			_close_btn.removeEventListener(MouseEvent.CLICK, _c.closeImageBrowser);		
			_c.relay.removeEventListener(NewBitmapDataEvent.BITMAP_DATA, _c.closeImageBrowser);
			_directory.removeEventListener(Event.SELECT, directorySelected);
			
			_base = null;
			_browse_btn = null;
			_close_btn = null;
			_input_txt = null;
			_no_folder_images_mc = null;
			_tilelist = null;
			_directory = null;
		}		
	}

}