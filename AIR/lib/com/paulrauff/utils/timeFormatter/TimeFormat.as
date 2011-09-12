package com.paulrauff.utils.timeFormatter 
{
	public class TimeFormat 
	{
		
		public function TimeFormat() 
		{
			
		}
		
		public static function hhmmss(s:int):String
		{
		   // Do some time calculations
		   var hrs:Number = Math.floor(s/3600);
		   var mins:Number = Math.floor((s%3600)/60);
		   var secs:Number = Math.floor((s%3600)%60);
		   
		   // Define some vars
		   var formattedTime:String = '';
		   var hours:String = '';
		   var minutes:String = '';
		   var seconds:String = '';
		   
		   // Update the hours variable
		   if (hrs != 0)
		   {
			  if (hrs < 10)
			  {
				 hours = '0' + hrs.toString() + ':';
			  }
			  else
			  {
				 hours = hrs.toString() + ':';
			  }
		   }
		   
		   // Update the minutes variable
		   if (mins < 10)
		   {
			  minutes = '0' + mins.toString() + ':';
		   }
		   else
		   {
			  minutes = mins.toString() + ':';
		   }
		   
		   // Update the seconds variable
		   if (secs < 10)
		   {
			  seconds = '0' + secs.toString();
		   }
		   else
		   {
			  seconds = secs.toString();
		   }
		   
		   // Update the formattedTime variable;
		   formattedTime = hours + minutes + seconds;
		   
		   // Kick the formatted time back out
		   return formattedTime;
		}

	}

}