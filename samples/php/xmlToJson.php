<?php

/* This class help to convert any xml file (including kml..) to a beautiful Json Format :3
 * isabelpalomar.com ;)
 * 21/01/2013
 */

class XmlToJson {

    /**
    * Function Parser: Get the url and convert the content in json format
    * string $url
    */
    public function Parser( $url ) {

        //get the file content 
        $fileContent  = file_get_contents( $url );

        //replace the newlines, returns and tabs.
        $fileContent  = str_replace(array("\n", "\r", "\t"), '', $fileContent);
        $fileContent  = trim(str_replace('"', "'", $fileContent));

        //load the clean XML 
        $simpleXml    = simplexml_load_string($fileContent);

        //parse the xml in a Json Format
        $json         = json_encode($simpleXml);

        //return the final content (in json format)
        return $json;
    }
}
?>