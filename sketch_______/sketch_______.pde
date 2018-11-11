Data data;
int margin = 10;
int xCount = 5;
String date = "Jan, 22, 18";

void setup() {
  size(500, 500);
  background(50);
  
  data = new Data("Produce Data 2.csv", margin, date);

  //data.createGrid(xCount);
  //data.displayGrid(xCount);
  //data.displayGridInfo(xCount);
  
  //data.connectedBars();
  //data.connectedBarsInfo();
  
  //data.circularLine();
  //data.circularLineInfo();
  
  data.arcs();
  data.arcsInfo();
}

void draw() {
}