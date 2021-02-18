

//Shader PostFix
import ch.bildspur.postfx.builder.*;
import ch.bildspur.postfx.pass.*;
import ch.bildspur.postfx.*;
PostFX fx;

//Camera Moving Variable
float camXX=0, camYY=0, camZZ=0;
float camX=0, camY=0, camZ=0;

//Sound Analyze
PImage torii_img;
ArrayList torii;


void setup() {
  size(1280, 800, P3D);
  torii_img = loadImage("torii.png");
  torii = new ArrayList<Particle>();
  fx = new PostFX(this);
  audio_setup();

  //Shader Post Fix init
  fx = new PostFX(this);
  smooth(8);

  for (int s=0; s<10000; s++) {
    int tx = floor(random(torii_img.width));
    int ty = floor(random(torii_img.height)); 
    color c = torii_img.get(tx, ty);
    while (c == color(255) || brightness(c)>200) {
      tx = floor(random(torii_img.width));
      ty = floor(random(torii_img.height));
      c = torii_img.get(tx, ty);
    }
    fill(c);
    float x = map(tx, 0, torii_img.width, 0, width);
    float y = map(ty, 0, torii_img.height, 0, height); 
    torii.add(new Particle(x-width/2, y-height/2, random(-50, 50), c));
    //ellipse(x, y, 5, 5);
  }
}

void draw() {
  background(255);
  fill(255);
  float camR = 1000;
  float fc = float(frameCount);
  fc = 0;
  camX = camR * sin(radians(fc));
  camY = -200;
  camZ = camR * cos(radians(fc));

  camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);
  for (int s=0; s<torii.size(); s++) {
    Particle P = ((Particle)(torii.get(s)));
    P.update();
    P.show();
  }
  blendMode(DARKEST);
  fx.render()
    //.sobel()
    .bloom(0.1, 20, 30)
    //.blur(10, 0.5)
    //.toon()
    //.brightPass(0.1)
    //.blur(30, 10)
    .compose();

  surface.setTitle(str(frameRate));
}
void keyReleased() {
}
class Particle {
  float px, py, pz;
  float ppx, ppy, ppz;
  float ori_x, ori_y, ori_z;
  color c;
  float easing = 0.3;
  Particle(float _px, float _py, float _pz, color _c) {
    ppx = _px;
    ppy = _py;
    ppz = _pz;
    px = _px;
    py = _py;
    pz = _pz;
    ori_x = px;
    ori_y = py;
    ori_z = pz;
    c = _c;
  }
  void update() {
    px+=(ppx-px)*easing;
    py+=(ppy-py)*easing;
    pz+=(ppz-pz)*easing;

    float R;
    float a, t;
    R = 50*norm(volume_Bass, 0, 5);
    a = (pz*frameCount)*0.37;
    t = (px*frameCount)*0.73;
    float fx = R*sin(radians(a))*cos(radians(t));
    float fy = R*tan(radians(t));
    float fz = R*tan(radians(a))*cos(radians(t));

    ppx = ori_x + fx;
    ppy = ori_y + fy;
    ppz = ori_z + fz;
    //ppx += random(-1,1);
    //ppy += random(-1,1);
    //ppz += random(-1,1);
  }
  void show() {
    noStroke();
    pushMatrix();
    rotateY(radians(frameCount/2));
    translate(px, py, pz);
    fill(c);
    stroke(c);
    strokeWeight(5);
    float flick = constrain(volume*5, 1, 5);
    line(0, 0, 0, 
      random(-flick, flick), 
      random(-flick, flick), 
      random(-flick, flick));
    //ellipse(0, 0, 1, 1);
    popMatrix();
  }
}
