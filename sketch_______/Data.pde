class Data {
  Table table;
  PVector[] points;
  float margin;
  String date;
  PFont f;
  int[] vegetables, fruit;

  Data(String fileName, int _margin, String _date) {
    table = loadTable(fileName, "header");
    table.setColumnType("New Quantity", Table.INT);
    date = _date;

    if (!(date.equals("All"))) {
      for (int i = table.getRowCount()-1; i >= 0; i--) {
        String d = table.getRow(i).getString("Date");
        if (!(d.equals(date))) table.removeRow(i);
      }
    }

    points = new PVector[table.getRowCount()];
    
    margin = _margin;
    

    f = createFont("Georgia", 10);
    textMode(MODEL);
    textFont(f);

    vegetables = table.findRowIndices("Vegetable", "Kind");
    fruit = table.findRowIndices("Fruit", "Kind");
  }

  void createGrid(float _xCount) {
    int x = 0;
    int y = 0;
    float xCount = _xCount;
    float yCount = ceil(points.length/xCount);
    float rectW = ((width-margin*2)/xCount);
    float rectH = ((height-margin*2)/yCount);
    for (int i = 0; i < points.length; i++) {
      float posx = x * rectW + margin;
      float posy = y * rectH + margin;
      points[i] = new PVector(posx, posy);
      x++;
      if ((i+1) % xCount == 0) {
        y++;
        x = 0;
      }
    }
  }

  void displayGrid(float _xCount) {
    stroke(255);
    noFill();
    strokeCap(SQUARE);
    sortDesc("New Quantity");
    int[] q = table.getIntColumn("New Quantity");
    int minN = min(q);
    int maxN = max(q);
    
    float xCount = _xCount;
    float yCount = ceil(points.length/xCount);
    float rectW = ((width-margin*2)/xCount);
    float rectH = ((height-margin*2)/yCount);

    for (int i = 0; i < points.length; i++) {
      float strokeW = map(q[i], minN, maxN, 1, 18);
      strokeWeight(strokeW);
      String colorString = table.getString(i, "Color");
      //"FF" = opaque color, "00" = transparent color
      color c = unhex("FF" + colorString);
      stroke(c);
      line(points[i].x, points[i].y + rectH/2, points[i].x + rectW, points[i].y + rectH/2);
    }
  }

  void displayGridInfo(float _xCount) {
    textAlign(CENTER);
    float xCount = _xCount;
    float rectW = ((width-margin*2)/xCount);
    
    for (int i = 0; i < points.length; i++) {
      float textH = textDescent() - textAscent();
      text(table.getRow(i).getString("Item"), points[i].x + rectW/2, points[i].y - textH/2);
    }
  }

  void connectedBars() {
    int maxV = maxInt(vegetables.length, vegetables, "New Quantity");
    int minV = minInt(vegetables.length, vegetables, "New Quantity");
    println("Max Veg: " + maxV, "Min Veg: " + minV);
    beginShape();
    for (int i = 0; i < vegetables.length; i++) {
      int barW = table.getInt(vegetables[i], "New Quantity");
      float barH = ((height-margin*2)/vegetables.length);
      float posx = width/2;
      float posy = i * barH + margin;
      stroke(0, 200, 160);
      noFill();
      vertex(posx + barW, posy);
      vertex(posx + barW, posy + barH);
      //rect(posx, posy, barW, barH);
    }
    endShape();
    
    int maxF = maxInt(fruit.length, fruit, "New Quantity");
    int minF = minInt(fruit.length, fruit, "New Quantity");
    println("Max Fruit: " + maxF, "Min Fruit: " + minF);
    beginShape();
    for (int i = 0; i < fruit.length; i++) {
      int barW = table.getInt(fruit[i], "New Quantity");
      float barH = ((height-margin*2)/fruit.length);
      float posx = width/2;
      float posy = i * barH + margin;
      stroke(200, 200, 0);
      noFill();
      vertex(posx - barW, posy);
      vertex(posx - barW, posy + barH);
      //rect(posx, posy, barW, barH);
    }
    endShape();
  }
  
  void connectedBarsInfo() {
    stroke(255);
    line(width/2, margin, width/2, height-margin);
    for (int i = 0; i < vegetables.length; i++) {
      int barW = table.getInt(vegetables[i], "New Quantity");
      float barH = ((height-margin*2)/vegetables.length);
      float posx = width/2;
      float posy = i * barH + margin;
      fill(255);
      noStroke();
      float textH = textDescent() - textAscent();
      text(table.getString(vegetables[i], "Item"), posx + barW + 4, posy + barH/2 - textH/2);
    }
    for (int i = 0; i < fruit.length; i++) {
      int barW = table.getInt(fruit[i], "New Quantity");
      float barH = ((height-margin*2)/fruit.length);
      float posx = width/2;
      float posy = i * barH + margin;
      fill(255);
      float textW = textWidth(table.getString(fruit[i], "Item"));
      float textH = textDescent() - textAscent();
      text(table.getString(fruit[i], "Item"), posx - barW - 4 - textW, posy + barH/2 - textH/2);
    }
  }
  
  void circularLine() {
    sortDesc("New Quantity");
    int[] q = table.getIntColumn("New Quantity");
    int minN = min(q);
    int maxN = max(q);
    
    float slice = TWO_PI/points.length;
    float theta;
    float radius = -50;
    for (int i = 0; i < points.length; i++) {
      theta = i * slice;
      float lineWidth = table.getInt(i, "New Quantity");
      float lineW = map(lineWidth, minN, maxN, -radius + 10, width+radius*4);
      
      String colorString = table.getString(i, "Color");
      //"FF" = opaque color, "00" = transparent color
      color c = unhex("FF" + colorString);
      stroke(c);
      
      pushMatrix();
      translate(width/2, height/2);
      rotate(-theta);
      line(radius, 0, -lineW, 0);
      popMatrix();
    }
  }
  
  void circularLineInfo() {
    int[] q = table.getIntColumn("New Quantity");
    int minN = min(q);
    int maxN = max(q);
    
    float slice = TWO_PI/points.length;
    float theta;
    float radius = -50;
    for (int i = 0; i < points.length; i++) {
      theta = i * slice;
      float lineWidth = table.getInt(i, "New Quantity");
      float lineW = map(lineWidth, minN, maxN, -radius + 10, width+radius*4);
      
      String info = table.getString(i, "Item");
      
      String colorString = table.getString(i, "Color");
      //"FF" = opaque color, "00" = transparent color
      color c = unhex("FF" + colorString);
      stroke(c);
      
      pushMatrix();
      translate(width/2, height/2);
      rotate(-theta);
      text(info, -lineW -textWidth(info) - 4, 0);
      popMatrix();
    }
  }
  
  void arcs() {
    int[] q = table.getIntColumn("New Quantity");
    int minN = min(q);
    int maxN = max(q);
    
    float slice = TWO_PI/points.length;
    float point1, point2;
    float radius = 200;
    float maxStrokeW = 30;
    for (int i = 0; i < points.length; i++) {
      point1 = i * slice;
      point2 = (i+1) * slice;
      float strokeW = map(table.getInt(i, "New Quantity"), minN, maxN, 1, maxStrokeW);
      
      String colorString = table.getString(i, "Color");
      //"FF" = opaque color, "00" = transparent color
      color c = unhex("FF" + colorString);
      stroke(c);
      strokeWeight(strokeW);
      strokeCap(SQUARE);
      noFill();
      arc(width/2, height/2, radius*2, radius*2, point1, point2);
    }
  }
  
  void arcsInfo() {
    float slice = TWO_PI/points.length;
    float point1, point2;
    float radius = 200;
    float maxStrokeW = 30;
    for (int i = 0; i < points.length; i++) {
      point1 = i * slice;
      point2 = (i+1) * slice;
      float avg = (point1 + point2)/2;
      float textH = textDescent() - textAscent();
      
      //fill(255);
      pushMatrix();
      translate(width/2, height/2);
      rotate(avg);
      text(table.getString(i, "Item"), radius + maxStrokeW/2 + 4, -textH/2);
      popMatrix();
    }
  }

  void sortAsc(String title) {
    table.sort(title);
  }

  void sortDesc(String title) {
    table.sortReverse(title);
  }

  int maxInt(int arrayLength, int[] array, String colName) {
    int maxN = 0;
    int[] destArray = new int[arrayLength];
    for (int i = 0; i < arrayLength; i++) {
      int n = table.getInt(array[i], colName);  
      destArray[i] = n;
      maxN = max(destArray);
    }
    return maxN;
  }
  
  int minInt(int arrayLength, int[] array, String colName) {
    int minN = 0;
    int[] destArray = new int[arrayLength];
    for (int i = 0; i < arrayLength; i++) {
      int n = table.getInt(array[i], colName);  
      destArray[i] = n;
      minN = min(destArray);
    }
    return minN;
  }
}