<?php
  $uploadfile_fieldname  = "uploadfile";
  if (!isset($_FILES[$uploadfile_fieldname])) exit;
    
  if ($_FILES[$uploadfile_fieldname]["error"] > 0)
  {
    echo "Error: return code: " . $_FILES[$uploadfile_fieldname]["error"] . "<br />";
  }
  else
  {
    $filename = $_FILES[$uploadfile_fieldname]["name"];
    $exts = split("[/\\.]", $filename);
    
	if (count($exts) > 0) 
	{
        $ext = $exts[count($exts)-1];
        if (strtolower($ext) != "mp3") 
		{
            echo ("Error: Only MP3 files are allowed for upload");
            exit;
        }
    }
    else 
	{
        exit;
    }
	
    $uploadfolder = "1/sound";
    if (!file_exists($uploadfolder)) 
	{
        if(!@mkdir($uploadfolder)) 
		{
            echo ("Error: Could not create '" . $uploadfolder . "' folder");
            exit;
        }
    }
    $filename = preg_replace('/[\\/\\\\]/m', '_', $filename);
    move_uploaded_file($_FILES[$uploadfile_fieldname]["tmp_name"], $uploadfolder . "/" . $filename);
    echo "ok";
  }
?>
