
import processing.sound.*;

SoundFile sound_intro;
SoundFile sound_intro_lead;
SoundFile sound_intro_guitar;
SoundFile sound_intro_vocal;
SoundFile sound_intro_drum;


audio intro;
audio intro_lead;
audio intro_guitar;
audio intro_vocal;
audio intro_drum;


String song = "am2";
String parentFolder; 


void audio_setup() {
  parentFolder = sketchFile("").getParent();

  //input = new AudioIn(this, 0);
  //input.start();
  sound_intro = new SoundFile(this, parentFolder+"/music/"+song+".wav");
  sound_intro_lead = new SoundFile(this, parentFolder+"/music/"+song+"_lead.wav");
  sound_intro_guitar = new SoundFile(this, parentFolder+"/music/"+song+"_guitar.wav");
  sound_intro_vocal = new SoundFile(this, parentFolder+"/music/"+song+"_vocal.wav");
  sound_intro_drum = new SoundFile(this, parentFolder+"/music/"+song+"_drum.wav");

  sound_intro.loop();
  sound_intro_lead.loop();
  sound_intro_guitar.loop();
  sound_intro_vocal.loop();
  sound_intro_drum.loop();


  FFT fft1; 
  FFT fft2; 
  FFT fft3; 
  FFT fft4; 
  FFT fft5; 
  fft1 = new FFT(this, 1024);
  fft1.input(sound_intro);
  fft2 = new FFT(this, 1024);
  fft2.input(sound_intro_lead);
  fft3 = new FFT(this, 1024);
  fft3.input(sound_intro_guitar);
  fft4 = new FFT(this, 1024);
  fft4.input(sound_intro_vocal);
  fft5 = new FFT(this, 1024);
  fft5.input(sound_intro_drum);

  intro = new audio(sound_intro, fft1);
  intro_lead = new audio(sound_intro_lead, fft2);
  intro_guitar = new audio(sound_intro_guitar, fft3);
  intro_vocal = new audio(sound_intro_vocal, fft4);
  intro_drum = new audio(sound_intro_drum, fft5);

  //waveform = new Waveform(this, 1024);
  //waveform.input(input);
}
void general_soundCheck() {
  intro.soundCheck();
  intro_lead.soundCheck();
  intro_guitar.soundCheck();
  intro_vocal.soundCheck();
  intro_drum.soundCheck();
}
class audio {

  Amplitude loudness;
  FFT fft; 
  Waveform waveform;
  int bands = 1024;
  float smoothFactor = 0.5;
  float[] sum = new float[bands];
  int scale = 5;
  float barWidth;
  float volume;
  int currentBeat = 0;
  float smoothingFactor = 0.25;
  float volume_MidHigh, volume_Mid, volume_High, volume_Low, volume_Bass, volume_Peak;

  audio(SoundFile _sound, FFT _fft ) {
    fft = _fft;
    barWidth = width/float(bands);
  }
  void soundCheck() {
    volume_Bass = 0;
    volume_Low = 0;
    volume_Mid = 0;
    volume_MidHigh = 0;
    volume_High = 0;
    volume_Peak = 0;

    fft.analyze();

    float soundFlag = 1000;
    volume = 0;
    for (int i = 0; i < 512; i++) {
      // Smooth the FFT spectrum data by smoothing factor
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;

      volume+=sum[i]*soundFlag;

      if (i<=4)volume_Bass+=sum[i]*soundFlag;
      else if (i>4 && i<=8)volume_Low +=sum[i]*soundFlag; 
      else if (i>8 && i<=23)volume_Mid +=sum[i]*soundFlag; 
      else if (i>23 && i<=75)volume_MidHigh +=sum[i]*soundFlag; 
      else if (i>75 && i<=190)volume_High+=sum[i]*soundFlag;
      else if (i>190 && i<= 650)volume_Peak+=sum[i]*soundFlag;

      //println(volume_Low);
      //fill(255);
      // Draw the rectangles, adjust their height using the scale factor
      //rect(i*barWidth, height, barWidth, -sum[i]*height*scale);
    }

    volume_Bass /= 4;
    volume_Low /= 4;
    volume_Mid /= 15;
    volume_MidHigh /= 52;
    volume_High /= 115;
    volume_Peak /= 400;

    volume_Bass = norm(volume_Bass, 0, 10);
    volume_Low = norm(volume_Low, 0, 25);
    volume_Mid = norm(volume_Mid, 0, 10);
    volume_MidHigh = norm(volume_MidHigh, 0, 3);
    volume_High = norm(volume_High, 0, 1);
    volume_Peak = norm(volume_Peak, 0, 1);
    volume = norm(volume, 0, 10000);
  }
}
