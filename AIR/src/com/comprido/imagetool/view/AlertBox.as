package com.comprido.imagetool.view 
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

	import com.carlcalderon.arthropod.Debug;
	import flash.display.*;
	import fl.controls.Button;
	import fl.controls.listClasses.ImageCell;
	import flash.events.*;
	import flash.text.*;

	public class AlertBox extends Sprite 
	{
		private var _message_txt:TextField;
		private var _buttons:Vector.<Button>;
		private var _width:int = 200;
		private var _height:int = 200;
		
		public function AlertBox(message:String, btns:Vector.<String>) 
		{
			createButtons(btns);
			createMessage(message);
			createBox();
		}
		
		private function createBox():void 
		{
			var square:Sprite = new Sprite();
			var btnY:int = _message_txt.y + _message_txt.height + 10;
			var h:int = btnY + 30;

			addChild(square);
			
			square.addChild(_message_txt);

			for each(var btn:Button in _buttons)
			{				
				square.addChild(btn);
				
				btn.y = btnY;
				
				btn.addEventListener(MouseEvent.CLICK, onBtnClick);
			}
			
			square.graphics.lineStyle(1,0x000000);
			square.graphics.beginFill(0xefefcc);
			square.graphics.drawRect(0, 0, boxWidth, h);
			square.graphics.endFill();			
		}
		
		private function onBtnClick(event:MouseEvent):void 
		{
			dispatchEvent(new Event(event.target.name));
		}
		
		private function createMessage(message:String):void
		{
			_message_txt = new TextField();
			_message_txt.width = boxWidth;
			_message_txt.height = 30;
			_message_txt.x = 0;
			_message_txt.y = 10;
			_message_txt.selectable = false;
			_message_txt.text = message;
			
			var tf:TextFormat = new TextFormat(); 
			tf.font = "Arial"; 
			tf.color = 0x000000; 
			tf.size =  20;
			tf.italic = false; 
			tf.bold = true; 
			tf.underline = false; 
			tf.align = "center"; 
			_message_txt.setTextFormat(tf);
			_message_txt.autoSize = TextFieldAutoSize.CENTER;
		}
		
		private function createButtons(btns:Vector.<String>):void
		{
			_buttons = new Vector.<Button>();
			var pos:int = 5;
			
			for each(var txt:String in btns)
			{
				var tmpbtn:Button = new Button();				
				tmpbtn.label = txt;		
				tmpbtn.name = txt;
				tmpbtn.textField.autoSize = TextFieldAutoSize.CENTER;
				tmpbtn.width = tmpbtn.textField.width + 20;
				
				_buttons.push(tmpbtn);

				tmpbtn.x  = pos;

				pos = 5 + tmpbtn.width + tmpbtn.x;
			}
		}
		
		public function get boxWidth():int 
		{
			var r:int = _width;
			var ii:int = _buttons.length - 1;
			
			if (ii >= 0)
			{
				var w:int = _buttons[ii].x + _buttons[ii].width + 5;

				if (w > _message_txt.textWidth)
				{
					r = w;
				}
				else
				{
					r = _message_txt.textWidth + 18;
					_message_txt.x = 7;
					
					var shift:int = (r - w) / 2;
					
					for each(var b:Button in _buttons)
					{
						b.x += shift;
					}
				}
			}
			
			return r;
		}
		
	}

}