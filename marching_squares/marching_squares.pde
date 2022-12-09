
// Variables
float[][] field;
int res = 8;
int cols, rows;
float x, y, xoff, yoff, zoff = 0;
float xyinc = 0.1, zinc = 0.01;
PVector a, b, c, d, top, right, bottom, left;
boolean blocky = false;
OpenSimplexNoise noise;

////////////////////////

// Setup
void setup() {

  // Set size to 1280x640, frame rate to 30 and title
  size(1280, 640);
  surface.setTitle("The coding train cabana #5 : Marching squares");
  frameRate(30);

  // No outline and fill white
  noStroke();
  fill(255);
  
  // Setup the noise
  setup_noise();

  // Setup the gird and noise
  setup_grid();
}

// Setup the noise
void setup_noise() {
  
  // Create noise
  noise = new OpenSimplexNoise(int(random(255)));
}

// Setup the gird
void setup_grid() {
  
  // Calculate the numbers of column and rows
  cols = 2 + width / res;
  rows = 2 + height / res;

  // Initialize the field
  field = new float[cols][rows];
}

// Draw everything
void draw() {

  // Background black
  background(0);

  // Loop for every square in the grid
  xoff = 0;
  for (int i = 0; i < cols; i++) {
    yoff = 0;
    for (int j = 0; j < rows; j++) {

      // Generate the grid with the float value from the noise (move in 3D)
      field[i][j] = map((float)noise.eval(xoff, yoff, zoff), -1, 1, 0, 1);
      yoff += xyinc;
    }
    xoff += xyinc;
  }
  zoff += zinc;

  // Loop for every square in the grid
  for (int i = 0; i < cols - 1; i++) {
    for (int j = 0; j < rows - 1; j++) {

      // Set x and y position of the square
      x = i * res;
      y = j * res;

      // Set the corner of the square
      a = new PVector(x, y);
      b = new PVector(x + res, y);
      c = new PVector(x + res, y + res);
      d = new PVector(x, y + res);

      // If we want a blocky style, don't lerp
      if (blocky) {

        // Calculate the position of the top, bottom, left and right point to create the shape
        top = new PVector((a.x + b.x) / 2, a.y);
        right = new PVector(b.x, (b.y + c.y) / 2);
        bottom = new PVector((c.x + d.x) / 2, c.y);
        left = new PVector(d.x, (d.y + a.y) / 2);
      } else {

        // Calculate the position of the top, bottom, left and right point to create the shape
        top = new PVector(lerp(a.x, b.x, (0.5 - field[i][j]) / (field[i + 1][j] - field[i][j])), a.y);
        right = new PVector(b.x, lerp(b.y, c.y, (0.5 - field[i + 1][j]) / (field[i + 1][j + 1] - field[i + 1][j])));
        bottom = new PVector(lerp(c.x, d.x, (0.5 - field[i + 1][j + 1]) / (field[i][j + 1] - field[i + 1][j + 1])), c.y);
        left = new PVector(d.x, lerp(d.y, a.y, (0.5 - field[i][j + 1]) / (field[i][j] - field[i][j + 1])));
      }

      // Begin drawing the shape, get the right vertices from the state and draw the shape closed
      beginShape();
      switch(getState(field, i, j)) {
      case 1:
        vertex(left);
        vertex(bottom);
        vertex(d);
        break;
      case 2:
        vertex(right);
        vertex(bottom);
        vertex(c);
        break;
      case 3:
        vertex(right);
        vertex(left);
        vertex(d);
        vertex(c);
        break;
      case 4:
        vertex(top);
        vertex(right);
        vertex(b);
        break;
      case 5:
        vertex(top);
        vertex(left);
        vertex(d);
        vertex(bottom);
        vertex(right);
        vertex(b);
        break;
      case 6:
        vertex(top);
        vertex(bottom);
        vertex(c);
        vertex(b);
        break;
      case 7:
        vertex(top);
        vertex(left);
        vertex(d);
        vertex(c);
        vertex(b);
        break;
      case 8:
        vertex(top);
        vertex(left);
        vertex(a);
        break;
      case 9:
        vertex(top);
        vertex(bottom);
        vertex(d);
        vertex(a);
        break;
      case 10:
        vertex(top);
        vertex(right);
        vertex(c);
        vertex(bottom);
        vertex(left);
        vertex(a);
        break;
      case 11:
        vertex(top);
        vertex(right);
        vertex(c);
        vertex(d);
        vertex(a);
        break;
      case 12:
        vertex(left);
        vertex(right);
        vertex(b);
        vertex(a);
        break;
      case 13:
        vertex(right);
        vertex(bottom);
        vertex(d);
        vertex(a);
        vertex(b);
        break;
      case 14:
        vertex(left);
        vertex(bottom);
        vertex(c);
        vertex(b);
        vertex(a);
        break;
      case 15:
        vertex(a);
        vertex(b);
        vertex(c);
        vertex(d);
        break;
      }
      endShape(CLOSE);
    }
  }
}

// If a key is pressed
void keyReleased() {

  // If it is up, zoom
  if (key == CODED && keyCode == UP) {
    res += 1;
    setup_grid();
  }

  // If it is down, dezoom
  else if (key == CODED && keyCode == DOWN) {
    if (res > 1) {
      res -= 1;
      setup_grid();
    }
  }
  
  // If it is R, reset the noise
  else if (key == 'r' || key == 'R') {
    setup_noise();
  }
}

// If we click, draw it blocky
void mouseReleased() {
  blocky = !blocky;
}

// Get the state number of a square to draw the right shape
int getState(float[][] field, int i, int j) {
  return round(field[i][j]) * 8 + round(field[i + 1][j]) * 4 + round(field[i + 1][j + 1]) * 2 + round(field[i][j + 1]);
}

// Refactor vertex to work with a PVector
void vertex(PVector v) {
  vertex(v.x, v.y);
}

// Refactor line to work with 2 PVector
void line(PVector v1, PVector v2) {
  line(v1.x, v1.y, v2.x, v2.y);
}
