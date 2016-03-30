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
import java.util.Date;

int cols = 9;
int rows = 8;

int w; 
int h; 
int state = 0;
int xOffset;
int yOffset;
Desk[][] desks = new Desk[cols][rows];
String[] data;
int nameCount = -1;
ArrayList<Desk> selectedDesks;
boolean typing = false;
boolean mouseHeld = false;
String tempName = ""; //this holds the current typed string when editing a desk's name value
String[] namesToSwap = new String[2];
String[] lNamesToSwap = new String[2];
Table layout;
Table export;
//String layoutFile = "mcsorely.csv";
String layoutFile = "pommier.csv";

void setup() {
  background(25);
  size(800, 500);
  w = width/(cols + 2);
  h = height/(rows + 2);
  xOffset = (width-(w*cols))/2 + (w/2);
  yOffset = (height-(h*rows))/2 + (h/2);
  rectMode(CENTER);
  data = loadStrings("names.txt");
  data = sort(data);
  selectedDesks = new ArrayList<Desk>();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      desks[i][j] = new Desk(xOffset + (w*i), yOffset + (h*j), w, h, "");
    }
  }
}

void draw() {
  background(255);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      desks[i][j].display();
      desks[i][j].checkMouse();
    }
  }
  if (state == 0) {
    configure();
  }
  else if (state == 1) {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (!desks[i][j].show) {
          desks[i][j].o = 0;
        }
      }
    }
    displayControls();
  }
  if (selectedDesks.size() >= 2) {
    swapDesks();
  }
  if (typing) {
    selectedDesks.get(0).lName = tempName;
  }
}

void displayControls() {
  rectMode(CENTER);
  noStroke();
  fill(127);
  rect(width/2, yOffset*.25, width/2, yOffset*.5, 9);
  fill(30);
  text( "A/Z - Alphabetize", width*.35, yOffset*.25);
  text( "R - Randomize", width/2, yOffset*.25);
  text( "S - Save", width*.64, yOffset*.25);
}

void configure() {
  textAlign(CENTER, CENTER);
  fill(180);
  textSize(20);
  text("Press space to finish configuring", width/2, height-20);
}

void swapDesks() { // when two desks are selected swaps each's name value, clears selectedDesk list
  for (int y = 0; y < selectedDesks.size(); y ++) { // grabs both desks from the selected desks list
    Desk r = selectedDesks.get(y);
    namesToSwap[y] = r.name;
    lNamesToSwap[y] = r.lName;
  }
  Desk first = selectedDesks.get(0);
  Desk second = selectedDesks.get(1);
  first.name = namesToSwap[1];
  second.name = namesToSwap[0];
  first.lName = lNamesToSwap[1];
  second.lName = lNamesToSwap[0];
  first.selected = false;
  second.selected = false;
  selectedDesks.clear();
}

void randomize(String[] a) 
{ 
  String temp; 
  int pick; 

  for (int i=0; i<a.length; i++) 
  { 
    temp = a[i]; 
    pick  = (int)random(a.length); 
    a[i] = a[pick]; 
    a[pick]= temp;
  }
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      desks[i][j].name = "";
      desks[i][j].lName = ""; // clears any names that have been moved to an index > the data array
      if (desks[i][j].show) {
        if (nameCount < a.length-1) {
          nameCount++;
          desks[i][j].name = a[nameCount];
        }
      }
    }
  }
  nameCount = -1;
} 

void alphabetize() {
  data = sort(data);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      desks[i][j].name = "";
      desks[i][j].lName = "";
      if (desks[i][j].show) {
        if (nameCount < data.length-1) {
          nameCount++;
          desks[i][j].name = data[nameCount];
        }
      }
    }
  }
  nameCount = -1;
}

void reverseAlphabetize() { // alphabetizes from z-a
  nameCount = data.length;
  data = sort(data);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      desks[i][j].name = "";
      desks[i][j].lName = "";
      if (desks[i][j].show) {
        if (nameCount > 0) {
          nameCount--;
          desks[i][j].name = data[nameCount];
        }
      }
    }
  }
  nameCount = -1;
}

void loadLayout() {
  layout = loadTable(layoutFile);
  int temp;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      // if (layout.getInt(j, i) != null) {
      temp = layout.getInt(j, i);
      if (temp == 0) {
        desks[i][j].show = false;
      }
      else {
        desks[i][j].show = true;
      }
    }
    //}
  }
}

void exportCSV() {
  export = new Table();
  for (int i = 0; i < cols; i++) {
    export.addColumn();
  }
  for (int j = 0; j < rows; j++) {
    export.addRow();
  }

  for (int c = 0; c < cols; c++) {
    for (int u = 0; u < rows; u++) {
      if (desks[c][u].show == false) {
        export.setInt(u, c, 0); // 0
      }
      else {
        export.setInt(u, c, 1);
      }
    }
  }
  Date d = new Date();
  long t = (d.getTime()/1000);
  saveTable(export, "Custom_layouts/" + t +  ".csv");
}

void keyPressed() {
  if (state == 0) {
    if (key == ' ') { // switches from configuration of classroom state to adding/moving names state
      state++;
    }
    else if (key == 'm' || key == 'M') {
      loadLayout();
    }

    else if (key == 'e' || key == 'E') {
      exportCSV();
    }
  }
  if (state== 1) {
    if (!typing && key == 'A' || typing == false && key == 'a') {
      alphabetize();
    }
    else if (!typing && key == 'S' || typing == false &&key == 's') {
      fill(255);
      rect(width/2, yOffset*.25, width/2, yOffset*.5, 9); // temporarilly hides control panel for screen capture
      saveFrame("seatingChart###.png");
    }
    else if (!typing && key == 'R' || typing == false &&key == 'r') {
      randomize(data);
    }
    else if (!typing && key == 'Z' || typing == false &&key == 'z') {
      reverseAlphabetize();
    }
    else if (!typing && key == DELETE || !typing && key == BACKSPACE) { //empties current selectedDesk's name value
      if (selectedDesks.size() == 1) {
        selectedDesks.get(0).name = "";
        selectedDesks.get(0).lName = "";
        selectedDesks.get(0).selected = false;
        selectedDesks.clear();
      }
    }
    else if (key == ENTER) {
      if (selectedDesks.size() == 1 && !typing) {
        typing = true;
        tempName = selectedDesks.get(0).lName;
        selectedDesks.get(0).edit = true;
      }
      else if (selectedDesks.size() == 1 && typing) {
        typing = false;
        selectedDesks.get(0).selected = false;
        selectedDesks.get(0).edit = false;
        selectedDesks.clear();
      }
    }
    if (typing) { // changes the tempName string, which affects the currently selected desk
      if (key == DELETE || key == BACKSPACE) { // add data validation for asterix (better, add asterix before name)
        if (tempName.length() > 0) {
          tempName= tempName.substring(0, tempName.length()-1);
        }
      }
      if (key >= 'A' && key <= 'Z') {
        tempName += (char) key;
      }
      else if (key >= 'a' && key <= 'z') {
        tempName += (char) key;
      }
      else if (key >= 33 && key <= 64) {
        tempName += (char) key;
      }
      else if (key == ' ') {
        typing = false;
        selectedDesks.get(0).selected = false;
        selectedDesks.get(0).edit = false;
        selectedDesks.clear();
      }
    }
  }
}

void mouseDragged() { // allows for dragging during configuration
  if (state == 0) { 
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (desks[i][j].mouseOver && desks[i][j].show == true) { //toggles whether a desk is displayed
          desks[i][j].show = false;
        }
      }
    }
  }
}

void mouseClicked() {
  if (state == 0) { // configuring the seating arrangement
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (desks[i][j].mouseOver && desks[i][j].show == true) { //toggles whether a desk is displayed
          desks[i][j].show = false;
        }
        else if (desks[i][j].mouseOver && desks[i][j].show == false) {
          desks[i][j].show = true;
        }
      }
    }
  }
  else if (state == 1) { //handles adding/removing desks to/from the selected desks list
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (!typing && desks[i][j].mouseOver && desks[i][j].show == true && desks[i][j].selected == false ) { //toggles whether a desk is displayed
          desks[i][j].selected = true;
          selectedDesks.add(desks[i][j]);
        }
        else if (desks[i][j].mouseOver && desks[i][j].show == true && desks[i][j].selected ==true) {
          desks[i][j].selected = false;
          selectedDesks.remove(desks[i][j]);
        }
      }
    }
  }
}
