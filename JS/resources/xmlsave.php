<?php
	if(isset($_POST["xmldata"]))
	{
		$filename = "1/xml/data.xml";
		$xmlpost = $_POST["xmldata"];

		if(isset($_POST["bakxml"]))
		{
			rename($filename, "1/xml/".$_POST["bakxml"].".xml");
		}
		
		xmlWriter($filename, $xmlpost);
	}
	else
	{
		echo "&r=".urlencode("xmldata data not set");
	}
	
	function xmlWriter($f, $x)
	{
		//open $x
		if (!$handle = fopen($f, 'w')) 
		{
			 echo "&r=".urlencode("Cannot open file ($f)");
			 exit;
		}

		// Write $x to our opened file.
		if (fwrite($handle, $x) === FALSE) 
		{
			echo "&r=".urlencode("Cannot write to file ($f)");
			exit;
		}

		echo "&r=".urlencode("Success, wrote to file ($f)");

		fclose($handle);
	} 
?>
