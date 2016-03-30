class Desk {

  int x;
  int y;
  int w;
  int h;
  int f = 255;
  int o = 255;
  int textFill = 0;
  String name;
  String lName = "";
  boolean mouseOver = false;
  boolean show = true;
  boolean edit = false; // set to true when the name is being edited
  boolean selected = false;
  // maximum chars to be displayed in most cases : 12

  Desk(int t_x, int t_y, int t_w, int t_h, String t_name) {
    x = t_x;
    y = t_y;
    w = t_w;
    h = t_h;
    name = t_name;
  }


  void display() {
    if (name.indexOf(' ') != -1){
      lName = name.substring(name.indexOf(' '), name.length());
      name = name.substring(0, name.indexOf(' '));
      println(lName);
      
    }
    fill(f, o);
    stroke(0, o);
    rect(x, y, w, h);
    if (!show) {
      f = 75;
    }
    else {
      f = 240;
    }
    if (selected) {
      noStroke();
      if (edit) {
        fill(0, 255, 120);
      }
      else if (!edit) {
        fill(127);
      }
      rect(x + (w*.4), y + (h*.3), w/10, w/10);
      //println(name.charAt(name.length()-3));
    }
    if (name.length() > 0 && name.charAt(name.length()-1) == '*') {
      fill(255, 30, 0);
      textSize(10);
      //text(name.substring(1, name.length()), x, y-10);
      text(name.substring(0, name.length()-1), x, y-10);
      text(lName, x, y+10);
    }
    else {
      fill(0);
      textSize(10);
      text(name, x, y-10);
      text(lName, x, y+10);
    }
  }

  void checkMouse() {
    if (mouseX > (x - w/2) && mouseX < (x + w/2) && mouseY > (y - h/2) && mouseY < (y + h/2)) {
      mouseOver = true;
      //println("over: " + x + "," + y + " " + selected);
    }
    else {
      mouseOver = false;
    }
  }
}
