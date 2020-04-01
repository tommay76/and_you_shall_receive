import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.sound.*;
Minim minim;
AudioOutput out;
LowPass lowPass;
class ToneInstrument implements Instrument
{
  // create all variables that must be used througout the class
  Oscil sineOsc;
  ADSR  adsr;
  
  // constructor for this instrument
  ToneInstrument( float frequency, float amplitude )
  {    
    // create new instances of any UGen objects as necessary
    sineOsc = new Oscil( frequency, amplitude, Waves.TRIANGLE );
    adsr = new ADSR( 0.5, 0.01, 0.05, 0.5, 0.5 );
    
    // patch everything together up to the final output
    sineOsc.patch( adsr );
  }
  
  // every instrument must have a noteOn( float ) method
  void noteOn( float dur )
  {
    // turn on the ADSR
    adsr.noteOn();
    // patch to the output
    adsr.patch( out );
   }
  
  // every instrument must have a noteOff() method
  void noteOff()
  {
    // tell the ADSR to unpatch after the release is finished
    adsr.unpatchAfterRelease( out );
    // call the noteOff 
    adsr.noteOff();
  }
}


int t;
int l;
int m;
float x1;
float x2;
float y1;
float y2;
String[] lines;


void setup(){
  fullScreen();
  strokeWeight(2);
  lines = loadStrings("newCaptures.txt");
  l = 0;
  m = 0;
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 2048 );

}
void draw(){
  background(0);
  stroke(255);
  translate(width/2,height/2);
  t++;
  parametricLinesExperiment(t);
 // if (t%int(map(mouseY,0,1080,75,2))==0)out.playNote( 0,0.1,map(mouseX,0,1920,100,2000) );
  if (t%2==0){
    out.playNote( 0,0.01,map(mouseX,0,1920,100,2000)* random(0.95,1.05));

  }

}
void parametricLinesExperiment(int t){

  for (int i = 0; i <mouseX;i++){
    if (m == lines[l].length()) {
      l++;
      m = 0;
    }
    if (l >= lines.length) l = 0;
    
    
      
    //line(x1(t+i),y1(t+i),x2(t+i),y2(t+i));
    fill(255);
    text(lines[l].charAt(m),x1(t+i),y1(t+i));
    fill(50,50,255);
    text(lines[l].charAt(m),x2(t+i),y2(t+i));
    m++;
  }
  
}
float x1(int boi){
  return sin(boi/20) *300;
}
float x2(int boi){
  return sin(boi/20) *600 - cos(boi/10)*20;
}
float y1(int boi){
  return cos(boi/map(mouseX,0,1920,0,40)) *300 + cos(boi/10) *20;
}
float y2(int boi){
  return cos(boi/20) *150 + cos(boi/map(mouseY,0,1080,0,40))*40;
}
