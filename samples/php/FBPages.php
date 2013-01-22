<?php

    ini_set('user_agent', 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.9) Gecko/20071025 Firefox/2.0.0.9');

    $finalEntries = array();

    //Specify the page IDs that you want to obtein                      
    $IDP1 = '152430529406';    // ID PAGE 1
    $IDP2 = '293065340767890'; // ID PAGE 2
    $IDP3 = '397995713555630'; // ID PAGE 3
    $IDP4 = '199781463380856'; // ID PAGE 4
    $IDP5 = '151403534889503'; // ID PAGE 5
    $IDP6 = '446421082071823'; // ID PAGE 6

    //add to array pages, the page IDS
    $pages = array(
                    $IDP1, 
                    $IDP2,
                    $IDP3,
                    $IDP4,
                    $IDP5,
                    $IDP6
                    );

    // Get the RSS of each page

    foreach ($pages as $key => $page) {

        //URL to the Facebook Page's RSS feed.
        $rssUrl = 'https://www.facebook.com/feeds/page.php?id='.$page.'&format=rss20';

        // Load the XML file
        $xml = simplexml_load_file($rssUrl); 

        // This creates an array called "entries" that puts each <item> in FB's
        // XML format into the array
        $entries = $xml->channel->item;

        //numer of entries for each page
        $numberEntries = 4;

        //add entry to array $finalEntries;
        for ($i = 0; $i < $numberEntries; $i++) {

            //format the fb date
            if (($timestamp = strtotime($entries[$i]->pubDate)) == true) {
                $fecha = date('Y-m-d h:i:s A', $timestamp);
            } 

            //create a new element and add it to $finalentries array
            $finalEntries[] = array(
                                    'PUBDATE'     => $fecha,
                                    'ACCOUNTNAME' => (string) $entries[$i]->author,
                                    'POST'        => (string) $entries[$i]->title,
                                    'POSTURL'     => (string) $entries[$i]->link
                                    );
        } //end for page entries
  } //end foreach pages

// sort the entries for date (DESC) .... return $t1 - $t2;  (ASC) :P
function date_compare($a, $b)
{
    $t1 = strtotime($a['PUBDATE']);
    $t2 = strtotime($b['PUBDATE']);
    return $t2 - $t1;
}
//call the function date compare to sort the entries    
usort($finalEntries, 'date_compare');

//encode the array in json format
echo json_encode($finalEntries); 
?>