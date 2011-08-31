<?php
	if(isset($_POST["xmldata"]))
	{
		$dirname = "1/xml/";
		$filename = "data.xml";
		$xmlpost = $_POST["xmldata"];

		if(isset($_POST["bakxml"]))
		{
			rename($dirname.$filename, $dirname.$_POST["bakxml"].".xml");
		}
		
		xmlWriter($dirname, $filename, $xmlpost);
	}
	else
	{
		echo urlencode("Error: xmldata data not set");
	}
	
	function xmlWriter($d, $f, $x)
	{
		//try open the file
		$canopen = ($handle = fopen($d.$f, 'w'));
		
		//if we can't open the file, try make the dir
		if (!$canopen) 
		{
			$canopen = (@mkdir($d, 0700, true));
			
			//if we can mkdir, try open again.
			if($canopen)
			{
				$canopen = ($handle = fopen($d.$f, 'w'));
			}
		}
		
		if(!$canopen)
		{
			echo urlencode("Cannot open dir ($d)");
			exit;
		}

		// Write $x to our opened file.
		if (fwrite($handle, $x) === FALSE) 
		{
			echo urlencode("Cannot write to file ($f)");
			exit;
		}

		echo "ok";

		fclose($handle);
	} 
?>
