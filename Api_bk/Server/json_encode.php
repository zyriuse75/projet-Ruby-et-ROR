<?php


 $licence_files = glob("xxx/xxx/xxx/licence*");

foreach ($licence_files as $file_name) { 
  print "processing $file_name...\n";
  include ($file_name);
  $json = json_encode($licenceData, JSON_PRETTY_PRINT);
  $newName = basename($file_name, '.php');
  file_put_contents('/tmp/Api_Bk/'.$newName.".yml", $json);
  unset($licenceData);
}

?>
