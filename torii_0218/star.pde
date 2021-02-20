ArrayList stars = new ArrayList();
float speed;
class Star {
  PVector pos = new PVector();
  float pz;
  float speed;
  Star(float eSpeed) {
    pos.x = random(-width, width);
    pos.y = random(-height, height);
    pos.z = random(width);
    pz = pos.z;

    speed = eSpeed;
  }
  void update() {
    pos.z -= speed;
    if (pos.z < 1) {
      pos.z = width;
      pos.x = random(-width, width);
      pos.y = random(-height, height);
      pz = pos.z;
    }
  }
  void show() {
    fill(255);
    noStroke();
    float sx = map(pos.x/pos.z, 0, 1, 0, width);
    float sy = map(pos.y/pos.z, 0, 1, 0, height);
    float r = map(pos.z, 0, width, 16, 0);

    float px = map(pos.x/pz, 0, 1, 0, width);
    float py = map(pos.y/pz, 0, 1, 0, height);
    stroke(200);
    line(px, py, sx, sy);
    pz = pos.z;
  }
}
