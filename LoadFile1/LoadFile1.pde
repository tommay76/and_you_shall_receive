/**
 * LoadFile 1
 * 
 * Loads a text file that contains two numbers separated by a tab ('\t').
 * A new pair of numbers is loaded each frame and used to draw a point on the screen.
 */
import processing.sound.*;
SoundFile tick;
int textMul;
int randomseed;
int random1;
int random2;
String[] lines;
int index = 0;
int start;
int end;
int start2;
int end2;
String src;
String dst;
int lineNo;
int[] source= new int[4]; 

int[] dest= new int[4]; 
int lineDepth = 30;
void setup() {
  textMul = 0;
  randomseed = 0;
  lineNo = 1;
  textSize(32);
  //size(1920, 1080);
  fullScreen();
  background(0);
  stroke(255);
  source= new int[4]; 

  dest = new int[4]; 
  lines = loadStrings("newCaptures.txt");
  drawframe();
  tick = new SoundFile(this, "tick.mp3");
  tick.loop();
}

void draw() {
  if (randomseed%50==0){
  random1 = int(random(0,width-10));
  random2 = int(random(0,height-10));
  }
  randomseed++;
  
  //println(lines.length);
  if (lineNo*lineDepth > height-10) {
    lineNo = 0;
    textMul++;
    if (textMul>3)textMul=0;
    //background(0);
  }
  drawframe();
  fill(0,5);
  noStroke();
  rect(0,0,width,height);
  if (index < lines.length) {
    if (lines[index].contains("Internet Protocol Version 4, Src:")){
      println(lines[index]);
      start = lines[index].indexOf(":");
      end = lines[index].indexOf(',',start);
      println("start: "+start+",end: "+end);
      src = lines[index].substring(start+2,end);
      String[] sources = src.split("\\.");
      fill(255);
      text("src: "+src, 50+textMul*600,lineNo*lineDepth);

      start2 = lines[index].indexOf(':',end); 
      end2 = lines[index].length();
      dst = lines[index].substring(start2+2,end2);
      String[] dests = dst.split("\\.");  
      text("dst: "+dst, 500+textMul*600,lineNo*lineDepth);
      println("::::+"+src);
      println("::::-"+dst);
      println("srclen. "+sources.length+", dstlen. "+dests.length);
      
      
      for (int i=0; i < sources.length; i++){
        source[i] = int(map(int(sources[i]),0,256,0,width-10));
        dest[i] = int(map(int(sources[i]),0,256,0,height-10));
      }
      createLines(source,dest,lineNo);
      lineNo ++;
      
    }
    // Go to the next line for the next run through draw()
    index = index + 1;
  }else index = 0;
}
void createLines(int[] src,int[] dst, int lineNo){
  for (int i = 0;i < src.length/2; i++){
    stroke(255);
    fill(255);
    strokeWeight(1);
    println("Ints: "+src[i],dest[i+1],src[i+1],dst[i]);
    line(src[i],src[i+1],random1,random2);
    line(dest[i],dest[i+1],random1,random2);
    //line(src[i],src[i+1],random(10,width-10),random(10,height-10));
    //line(dest[i],dest[i+1],random(10,width-10),random(10,height-10));
  }
}
void drawframe(){
  line(10,10,width-10,10);
  line(10,10,10,height-10);
  line(10,height-10,width-10,height-10);
  line(width-10,10,width-10,height-10);
  for (int i=0; i < width-10; i+=20){
    for (int j=0; j < height-10; j+=20){
      stroke(255,0,0);
      point(i,j);
    }
  }
}
