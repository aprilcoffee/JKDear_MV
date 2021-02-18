
import processing.sound.*;

SoundFile sound_intro;
SoundFile sound_intro_lead;
SoundFile sound_intro_guitar;
SoundFile sound_intro_vocal;
SoundFile sound_intro_drum;


AudioIn input;
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

void audio_setup() {
  //input = new AudioIn(this, 0);
  //input.start();
  sound_intro = new SoundFile(this, "music/intro.wav");
  sound_intro_lead = new SoundFile(this, "music/intro_lead.wav");
  sound_intro_guitar = new SoundFile(this, "music/intro_secondLead_Guitar.wav");
  sound_intro_vocal = new SoundFile(this, "music/intro_vocal.wav");
  sound_intro_drum = new SoundFile(this, "music/intro.wav");
  sound_intro.loop();

  //loudness = new Amplitude(this);
  //loudness.input(input);

  audio intro = new audio();
  barWidth = width/float(bands);
  fft = new FFT(this, bands);
  fft.input(intro);
  //waveform = new Waveform(this, 1024);
  //waveform.input(input);
}
class audio {
  audio(SoundFile) {
  }
  void soundCheck() {
    //waveform.analyze();
    volume_Bass = 0;

    volume_Low = 0;
    volume_Mid = 0;
    volume_MidHigh = 0;
    volume_High = 0;
    volume_Peak = 0;

    fft.analyze();
    input.amp(1);
    //volume = loudness.analyze();
    //volume += (loudness.analyze() - sum) * smoothingFactor;
    //volume*=1000;
    //println(volume);
    //volume = norm(volume, 0, 50);
    //barWidth *= 100;
    float soundFlag = 1000;
    for (int i = 0; i < bands; i++) {
      // Smooth the FFT spectrum data by smoothing factor
      sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;

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

    //println(volume_Peak);
  }
}
