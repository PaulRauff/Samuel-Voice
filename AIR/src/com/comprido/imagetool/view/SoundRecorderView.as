package com.comprido.imagetool.view 
{
	/**
	 * ...
	 * @author Paul
	 */
	
	import com.carlcalderon.arthropod.Debug;
	import com.comprido.imagetool.controller.Controller;
	import com.comprido.imagetool.controller.SoundFileRecorder;
	import com.comprido.imagetool.events.LoadProgressEvent;
	import com.comprido.imagetool.events.RecordingTimerEvent;
	import com.paulrauff.utils.greyscale.*;
	import com.paulrauff.utils.timeFormatter.TimeFormat;
	import com.paulrauff.utils.validate.*;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import flash.events.MouseEvent;

	public class SoundRecorderView extends Sprite 
	{
		private var _c:Controller;
		private var _recordController:SoundFileRecorder;
		
		private var _base:Sprite;
		private var _timer_bg_mc:MovieClip;
		private var _timer_mc:MovieClip;
		
		private var _close_btn:SimpleButton;
		private var _record_btn:SimpleButton;
		private var _play_btn:SimpleButton;
		private var _ok_btn:SimpleButton;
		
		private var _time_txt:TextField;
		
		private var _baseTimerSize:Point;
		
		[Embed(source="..//..//..//..//..//bin//skin.swf", symbol="SoundRecorderLib")]
		private var SoundRecorderSWF:Class;	

		public function SoundRecorderView(c:Controller)
		{
			_c = c;
			init();
		}
		
		private function init():void 
		{
			_base = new SoundRecorderSWF();
			addChild(_base);
			
			_timer_bg_mc = MovieClip(Validate.element(_base["timer_bg_mc"], "timer_bg_mc missing"));

			_close_btn = SimpleButton(Validate.element(_base["close_btn"], "close_btn missing"));
			_record_btn = SimpleButton(Validate.element(_base["record_btn"], "record_btn missing"));
			_play_btn = SimpleButton(Validate.element(_base["play_btn"], "play_btn missing"));
			_ok_btn = SimpleButton(Validate.element(_base["ok_btn"], "ok_btn missing"));
			
			_time_txt = TextField(Validate.element(_base["time_txt"], "time_txt missing"));
			
			_play_btn.enabled = false;
			_play_btn.alpha = 0.6;
			Greyscale.apply(_play_btn);
			
			_ok_btn.enabled = false;
			_ok_btn.alpha = 0.6;			
			Greyscale.apply(_ok_btn);
			
			_baseTimerSize = new Point(_timer_bg_mc.width, _timer_bg_mc.height);

			_recordController = new SoundFileRecorder(_c);
			_recordController.addEventListener(SoundFileRecorder.HAS_SOUND_DATA, hasSoundData);
			_recordController.addEventListener(SoundFileRecorder.MICROPHONE_LEVEL, onMicrophoneData);

			_record_btn.addEventListener(MouseEvent.MOUSE_DOWN, _recordController.startRecord);
			_record_btn.addEventListener(MouseEvent.MOUSE_UP, _recordController.stopRecord);			
			_record_btn.addEventListener(MouseEvent.MOUSE_DOWN, onRecordingStarted);
			_record_btn.addEventListener(MouseEvent.MOUSE_UP, onRecordingStopped);

			_close_btn.addEventListener(MouseEvent.CLICK, _c.closeSoundRecorder);
			_play_btn.addEventListener(MouseEvent.CLICK, _recordController.playSound);
			_ok_btn.addEventListener(MouseEvent.CLICK, _recordController.addSoundToMain);
		}
		
		private function onRecordingStarted(event:Event):void 
		{
			_record_btn.addEventListener(MouseEvent.MOUSE_OUT, onRecordingStopped);
			_record_btn.addEventListener(MouseEvent.MOUSE_OUT, _recordController.stopRecord);
			
			if (_timer_mc)
			{
				_timer_bg_mc.removeChild(_timer_mc);
				_timer_mc = null;
			}
			
			_timer_mc = new MovieClip();
			_timer_bg_mc.addChild(_timer_mc);
			_timer_mc.y = _timer_bg_mc.height;
		}		
		
		private function onRecordingStopped(event:Event):void 
		{
			_record_btn.removeEventListener(MouseEvent.MOUSE_OUT, onRecordingStopped);
			_record_btn.removeEventListener(MouseEvent.MOUSE_OUT, _recordController.stopRecord);
		}
		
		private function onMicrophoneData(event:RecordingTimerEvent):void 
		{
			if(event.microphoneActivityLevel > 0)
			{
				var lineLengthIncr:Number = _timer_bg_mc.height / 100;

				_timer_mc.graphics.moveTo(event.timerCycle*2, 0);
				_timer_mc.graphics.lineStyle(0.2, 0x99edff);
				_timer_mc.graphics.lineTo(event.timerCycle*2, ( -1 * Math.abs(event.microphoneActivityLevel * lineLengthIncr)));
				
				if (_timer_mc.width > _baseTimerSize.x)
				{
					_timer_mc.width = _baseTimerSize.x;
				}
				
				if (_timer_mc.height > _baseTimerSize.y)			
				{
					_timer_mc.height = _baseTimerSize.y;
				}
			}
			
			_time_txt.text = TimeFormat.hhmmss(Math.floor(event.timerCycle/_recordController.FPS));
		}
		
		private function hasSoundData(event:Event):void 
		{
			_play_btn.enabled = true;
			_play_btn.alpha = 1;
			Greyscale.apply(_play_btn, false);
			
			_ok_btn.enabled = true;
			_ok_btn.alpha = 1;			
			Greyscale.apply(_ok_btn, false);
		}
		
		public function destroy():void
		{
			removeChild(_base);
			_base = null;
			_close_btn = null;
			_record_btn = null;
			_play_btn = null;
			_ok_btn = null;
		}
	}

}