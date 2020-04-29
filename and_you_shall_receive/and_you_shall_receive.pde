int sizeX = 1920;
int sizeY = 1080;
String ThreadDuration = "3";
int t ;
float delay;
int SPEED = 10;
int randomNumber1;
int randomNumber2;
int randomNumber3;
void setup(){
   t = 0;
   //Collection Thread Setup
   collectionThread = new MyThread();
   newAllLines= null;
   allLines = null;

  
  
  // Mac Users 
  // Change this to a normal capture to work
  // DCapture is windows exlusive
  // You will also need to change line 37 in the draw function
  video  = new DCapture();
  // cam = new Capture(this, cameras[0]);
  // cam.start();   
  // ^^^^^^ USE THIS FOR MAC ^^^^^^^^^^
  // I dont know if it works, I dont own a mac :)
  
  
  opencv = new OpenCV(this, sizeX, sizeY);
  contours = new ArrayList<Contour>();
  
  // Blobs list
  blobList = new ArrayList<Blob>();
  delay = float(ThreadDuration);
  //Paths
  paths = new ArrayList<Path>();
  
  //Instrument
  minim = new Minim( this );
  out = minim.getLineOut( Minim.MONO, 2048 );
  randomNumber1 = (int)random(100,1500);
  randomNumber2 = (int)random(100,1500);
  randomNumber3 = (int)random(100,1500);
  //size(1920,1080, P2D);
  fullScreen(2);
  colorMode(HSB);
  background(0);
}

void draw(){
  
  background(0,10);
  textSize(20);
  if (threadLive == 0){
    threadLive = 1;
    opencv.loadImage(video.updateImage());
    src = opencv.getSnapshot();
  //Filter image for blob detection
    opencv.gray();
    opencv.contrast(contrast);
    opencv.threshold(threshold);
    opencv.invert();
    opencv.dilate();
    opencv.erode();
    opencv.blur(blurSize);
    
    // update Blobs
    detectBlobs();
  
    collectionThread = new MyThread();
    collectionThread.start();
    randomNumber1 = (int)random(100,500);
    randomNumber2 = (int)random(1,30);
    randomNumber3 = (int)random(1,30);
  }
  // Load the new frame of our camera in to OpenCV
  // Mac:
  // Change this to whatever capture function returns a Pimage of current capture
  //if ( (t + 50) % 100 ==0){
  //  opencv.loadImage(video.updateImage());
  //}
  //if ( t%100==0){
  //if (cam.available() == true) {
  //  cam.read();
  //}
  // opencv.loadImage(image(cam, 0, 0));
  //
  // MAC USERS: once again, im not sure if this works :)
  
  
  
  // display image: Debugging
  //src = opencv.getSnapshot();
  
  
  ////Filter image for blob detection
  //opencv.gray();
  //opencv.contrast(contrast);
  //opencv.threshold(threshold);
  //opencv.invert();
  //opencv.dilate();
  //opencv.erode();
  //opencv.blur(blurSize);
  
  //// update Blobs
  //detectBlobs();
  //}
  //image(src, 0, 0);
  
  //displayBlobs();
  
  displayPaths();
  deletePaths();
  //text(frameRate,width/2,height/2);
  t++;
  translate(width/2,height/2);

  parametricLinesExperiment(t);
 // if (t%int(map(mouseY,0,1080,75,2))==0)out.playNote( 0,0.1,map(mouseX,0,1920,100,2000) );
  if (t%2==0){
    out.playNote( 0,0.01,randomNumber1* random(0.95,1.05));

  }
  textSize(20);
  fill(255);
}

void displayPaths(){
  if (paths.size() == 0)return;
  
  int size = paths.size();
  println(size);
  int amount = t / 40;
  if (amount > size){amount = size;}
  
  for (int i = 0; i < amount; i ++){
    Path p = paths.get(i);
    p.display();
  }
}
void deletePaths(){
  if (paths.size() == 0)return;
  
  for (int i = paths.size()-1; i >=0; i --){
    Path p = paths.get (i);
    if (p.done()){
      paths.remove(i);
    }
  }
}
void parametricLinesExperiment(int t){
  if (allLines == null)return;
  for (int i = 0; i <randomNumber1;i++){

      
    //line(x1(t+i),y1(t+i),x2(t+i),y2(t+i));
    fill(255);
    text(allLines.charAt(i%allLines.length()),x1(t+i),y1(t+i));
    fill(50,50,255);
    text(allLines.charAt(i%allLines.length()),x2(t+i),y2(t+i));
  }
  
}
float x1(int boi){
  return sin(boi/20) *400;
}
float x2(int boi){
  return sin(boi/20) *800 - cos(boi/10)*20;
}
float y1(int boi){
  return cos(boi/randomNumber3) *500 + cos(boi/10) *20;
}
float y2(int boi){
  return cos(boi/20) *300 + cos(boi/randomNumber2)*40;
}
