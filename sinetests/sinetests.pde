import processing.sound.*;
SinOsc sine;
float t;
void setup() {
  fullScreen();
  background(255);
  t = 0;
  // Create the sine oscillator.
  sine = new SinOsc(this);
  sine.play();
}

void draw() {
  t ++;
  
  sine.freq((75 + sin(t/10)*50));
  //if (cos(t/10)>0){
  //sine.amp(0);
  //}else{
    sine.amp(map(mouseY,0,1080,0,1));
  //}
}
