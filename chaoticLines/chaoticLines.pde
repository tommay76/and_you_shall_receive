int t;
float x1;
float x2;
float y1;
float y2;
void setup(){
  size( 1920, 1080, P2D );
  strokeWeight(2);
  
}
void draw(){
  background(0);
  stroke(255);
  translate(width/2,height/2);
  t++;
  parametricLinesExperiment(t);
}
void parametricLinesExperiment(int t){
  //point(x1,y1);
  for (int i = 0; i <10000;i++){
    if (i %100==0) {
      stroke(255,0,0);
      strokeWeight(0.5);
      line(x1(t+i),y1(t+i),x2(t+i),y2(t+i));
      strokeWeight(1);
      stroke(255);
    }
    //line(x1(t+i),y1(t+i),x2(t+i),y2(t+i));
    point(x1(t+i),y1(t+i));
    point(x2(t+i),y2(t+i));
  }
  
}
float x1(int t){
  return sin(t/10) *400 + sin(t/100) *300;
}
float x2(int t){
  return sin(t/10) *200 - cos(t/100)*200;
}
float y1(int t){
  return cos(t/10) *400 + sin(t/10) *30;
}
float y2(int t){
  return cos(t/10) *200;
}
