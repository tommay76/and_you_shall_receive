int sizeX = 640;
int sizeY = 480;
void setup(){
  
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
  
  //Paths
  paths = new ArrayList<Path>();
  size(640,480, P2D);
  
}

void draw(){
  if (threadLive == 0){
    threadLive = 1;
    collectionThread = new MyThread();
    collectionThread.start();
  }
  // Load the new frame of our camera in to OpenCV
  // Mac:
  // Change this to whatever capture function returns a Pimage of current capture
  opencv.loadImage(video.updateImage());
  //if (cam.available() == true) {
  //  cam.read();
  //}
  // opencv.loadImage(image(cam, 0, 0));
  //
  // MAC USERS: once again, im not sure if this works :)
  
  
  
  // display image: Debugging
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
  image(src, 0, 0);
  displayBlobs();
  displayPaths();
 
}

void displayPaths(){
  for (Path p: paths){
    p.display();
  }
  for (int i = paths.size(); i >=0; i --){
    Path p = paths.get (i);
    if (p.done()){
      paths.remove(i);
    }
  }
}
