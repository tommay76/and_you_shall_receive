int sizeX = 1920;
int sizeY = 1080;
String ThreadDuration = "3";
int t ;
float delay;
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
  size(1920,1080, P2D);
  
}

void draw(){
  
  background(0);
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
  image(src, 0, 0);
  
  //displayBlobs();
  
  displayPaths();
  deletePaths();
  text(frameRate,width/2,height/2);
  t++;
}

void displayPaths(){
  int size = paths.size();
  int amount = 300/ size;
  if (amount > size){amount = 0;}
  
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
