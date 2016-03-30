# seating-chart-generator
A small Processing application to create and save custom seating charts.

////////////////////////CONTROLS/////////////////////////// 
//    Add student names to names.txt in sketch folder    // 
//    Asterix after last name will display name red      //
//    Set cols and rows to values that accomodate your   //
//    classroom setup                                    //
//    In setup state, click/drag to toggle desks on/off  //
//    m - will load preset .csv table                    //
//    Space will initiate the placement state            //
//    IN PLACEMENT STATE:                                //               
//    a/z - arrange students alphabetically              //
//    r - arrange students randomly                      //
//    s - save current window as a .png in sketch folder //
//    Click on a desk to select it                       //
//    Select two desks to swap their name values         //
//    ENTER - edits the selcted desk's name value        //
//    (press ENTER again to finish typing)               //
//    DELETE - sets selected desk's name value to ""     //
///////////////////////////////////////////////////////////

// asterix needs to go after last name, before space so it doesnt interfere with alphabetizing
// to alter the preset, create a .csv using mcsorely .csv as an example (0 = no desk, 1= desk)
// change loadLayout function to load name of fil eg. "myLayout.csv"
// change cols and rows below to accomodate new layout
