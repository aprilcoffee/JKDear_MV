

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

PImage lyrics;
PImage album;
PImage bg;
int mode = 0;
boolean drumDetect = false;

void setup() {
  size(800, 800, P3D);
  torii_img = loadImage("torii.png");
  lyrics = loadImage("lyrics.jpeg");
  bg = loadImage("bg2.jpg");
  album = loadImage("image.jpeg");
  torii = new ArrayList<Particle>();
  fx = new PostFX(this);
  audio_setup();
  //Shader Post Fix init
  fx = new PostFX(this);
  frameRate(30);
  smooth(8);

  for (int s=0; s<800; s++) {
    stars.add(new Star(random(1, 20)));
  }
  /*
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
   }*/
  float maxY = 0;
  float xL=width, xR=0;
  for (int ty=0; ty<torii_img.height; ty+=3) {
    for (int tx=0; tx<torii_img.width; tx+=3) {
      color c = torii_img.get(tx, ty);
      if (c != color(255)) {
        //tx = floor(random(torii_img.width));
        //ty = floor(random(torii_img.height));
        //c = torii_img.get(tx, ty);
        float x = map(tx, 0, torii_img.width, 150, width-150);
        float y = map(ty, 0, torii_img.height, 200, height-200); 
        if (y>maxY)maxY = y;
        if (x < xL)xL=x;
        if (x > xR)xR=x;
        torii.add(new Particle(x-width/2, y-height/2, random(-20, 20), c));
      }
    }
  }
  float mid = (xL+xR)/2;
  for (float x=xL; x<xR; x+=2) {
    for (float z=xL-mid; z<xR-mid; z+=5) {
      float gs = map(z, -1000, 1000, 255, 0);
      gs = 125;
      torii.add(new Particle(x-width/2, maxY-height/2, z, color(gs)));
    }
  }
}

void draw() {
  hint(DISABLE_DEPTH_TEST);
  general_soundCheck();
  //background(intro.volume*255, intro.volume*100, intro.volume*100);
  //background(255);
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  //bg.filter(INVERT);
  tint(255, 200+intro.volume_Bass*10);
  imageMode(CENTER);
  float rs =1;
  rs = 1+intro.volume/10;
  //println(intro_drum.volume_Bass);
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(frameCount)/2);
  image(bg, 0, 0, width*rs*1.5, height*rs*1.5);
  imageMode(CORNER);
  popMatrix();
  tint(255);
  //fill(255);
  float camR = 1000;
  float fc = -float(frameCount)/3;
  //fc = 0;
  camX = camR * sin(radians(fc));
  camY = 0;
  camZ = camR * cos(radians(fc));

  camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);

  //translate(width/2, height/2);
  for (int s=0; s<stars.size(); s++) {
    // ((Star)(stars.get(s))).update();
    // ((Star)(stars.get(s))).show();
  }

  for (int s=0; s<torii.size(); s++) {
    Particle P = ((Particle)(torii.get(s)));
    P.update();
  }
  //println(intro.volume);
  if (intro_drum.volume_Bass>10 && drumDetect==false) {
    drumDetect = true;
  }
  if (intro_drum.volume<1) {
    drumDetect = false;
  }

  mode =0;
  if (mode == 0) {
    //beginShape(TRIANGLE_STRIP);
    for (int s=0; s<torii.size(); s++) {
      Particle P = ((Particle)(torii.get(s)));
      P.show();
    }
  } else if (mode==1) {
    beginShape(TRIANGLE_STRIP);
    for (int s=0; s<torii.size(); s++) {
      Particle P = ((Particle)(torii.get(s)));
      float f = constrain(map(intro_drum.volume_Bass, 0, 50, 0.4, 1), 0, 1);

      stroke(red(P.c), green(P.c), blue(P.c), f*20);
      strokeWeight(1);

      //stroke(10);
      fill(red(P.c), green(P.c), blue(P.c), f*50);
      vertex(P.px, P.py, P.pz);
    }
    endShape(CLOSE);
  } else if (mode ==2) {
    println(intro_vocal.volume);
    float f = constrain(map(intro_drum.volume_Bass, 0, 30, 0.5, 1), 0, 1);
    for (int s=0; s<torii.size()*f*2; s++) {
      int f1 = floor(random(torii.size()));
      int f2 = floor(random(torii.size()));
      Particle P1 = ((Particle)(torii.get(f1)));
      Particle P2 = ((Particle)(torii.get(f2)));
      noFill();
      strokeWeight(1);
      //stroke(1);
      float q = 30+f*40;
      if (dist(P1.px, P1.py, P1.pz, P2.px, P2.py, P2.pz)<q) {
        float k = map(intro_vocal.volume, 0, 0.2, 30, 60);
        strokeWeight(map(k, 20, 80, 1, 2));
        stroke(red(P1.c), green(P1.c), blue(P1.c), k);
        line(P1.px, P1.py, P1.pz, P2.px, P2.py, P2.pz);
      }
    }
  }

  //println(torii.size());
  blendMode(BLEND);
  fx.render()
    //.invert()
    .sobel()
    .bloom(0.1, 1, 30)
    .blur(10, 1)
    //.toon()
    //.brightPass(0.1)
    //.blur(30, 10)
    .compose();

  blendMode(REPLACE);
  tint(255, 10);
  fx.render()
    .invert()
    //.sobel()
    //.bloom(0.1, 1, 30)
    //.blur(10, 1)
    //.toon()
    //.brightPass(0.1)
    //.blur(30, 10)
    .compose();

  tint(255);

  surface.setTitle(str(frameRate));
}
void keyReleased() {
  mode = floor(random(3));
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

    float R1, R2;
    float a, t;
    R1 = 7*norm(intro_drum.volume, 0, 5);
    R2 = 7*norm(intro_drum.volume, 0, 5);
    //R1 = 0;
    a = (pz*frameCount)*0.01;
    t = (px*frameCount)*0.01;
    //R1 = 10;
    float fx = R1*sin(radians(a))*tan(radians(t));
    float fy = R1*cos(radians(a))*cos(radians(t));
    float fz = R2*tan(radians(a))*sin(radians(t));

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
    //rotateY(radians(frameCount/2));
    translate(px, py, pz);
    fill(c);
    stroke(c);
    strokeWeight(5);

    stroke(red(c), green(c), blue(c), map(intro_drum.volume_Bass, 0, 5, 10, 20));
    fill(red(c), green(c), blue(c), 40);

    float flick = constrain(intro.volume*1, 1, 5);
    //line(0, 0, 0, 0, 1, 0);

    line(0, 0, 0, 
      random(-flick, flick), 
      random(-flick, flick), 
      random(-flick, flick));

    //ellipse(0, 0, 1, 1);
    popMatrix();
  }
}
