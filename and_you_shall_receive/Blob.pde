/**
 * Blob Class
 *
 * Based on this example by Daniel Shiffman:
 * http://shiffman.net/2011/04/26/opencv-matching-faces-over-time/
 * 
 * @author: Jordi Tost (@jorditost)
 * 
 * University of Applied Sciences Potsdam, 2014
 */
import gab.opencv.*;
import java.awt.Rectangle;
import processing.video.*;
import controlP5.*;
import javax.imageio.*;
import java.awt.image.*; 
import java.io.ByteArrayOutputStream;
import java.io.BufferedOutputStream;

ArrayList<Contour> contours;
ArrayList<Contour> newBlobContours;
ArrayList<Blob> blobList;
int blobCount = 0;
float contrast = 1.35;
int brightness = 0;
int threshold = 75;
boolean useAdaptiveThreshold = false; // use basic thresholding
int thresholdBlockSize = 489;
int thresholdConstant = 45;
int blobSizeThreshold = 20;
int blurSize = 4;


class Blob {
  
  private PApplet parent;
  
  // Contour
  public Contour contour;
  
  // Am I available to be matched?
  public boolean available;
  
  // Should I be deleted?
  public boolean delete;
  
  // How long should I live if I have disappeared?
  private int initTimer = 5; //127;
  public int timer;
  
  // Unique ID for each blob
  int id;
  
  // Make me
  Blob(PApplet parent, int id, Contour c) {
    this.parent = parent;
    this.id = id;
    this.contour = new Contour(parent, c.pointMat);
    
    available = true;
    delete = false;
    
    timer = initTimer;
  }
  
  // Show me
  void display() {
    Rectangle r = contour.getBoundingBox();
    
    float opacity = map(timer, 0, initTimer, 0, 127);
    fill(0,0,255,opacity);
    stroke(0,0,255);
    rect(r.x, r.y, r.width, r.height);
    fill(255,2*opacity);
    textSize(26);
    text(""+id, r.x+10, r.y+30);
  }

  // Give me a new contour for this blob (shape, points, location, size)
  // Oooh, it would be nice to lerp here!
  void update(Contour newC) {
    
    contour = new Contour(parent, newC.pointMat);
    
    // Is there a way to update the contour's points without creating a new one?
    /*ArrayList<PVector> newPoints = newC.getPoints();
    Point[] inputPoints = new Point[newPoints.size()];
    
    for(int i = 0; i < newPoints.size(); i++){
      inputPoints[i] = new Point(newPoints.get(i).x, newPoints.get(i).y);
    }
    contour.loadPoints(inputPoints);*/
    
    timer = initTimer;
  }

  // Count me down, I am gone
  void countDown() {    
    timer--;
  }

  // I am deed, delete me
  boolean dead() {
    if (timer < 0) return true;
    return false;
  }
  
  public Rectangle getBoundingBox() {
    return contour.getBoundingBox();
  }
}


void displayBlobs() {
  
  for (Blob b : blobList) {
    strokeWeight(1);
    b.display();
  }
}

void displayContours() {
  
  // Contours
  for (int i=0; i<contours.size(); i++) {
  
    Contour contour = contours.get(i);
    
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    contour.draw();
  }
}

void displayContoursBoundingBoxes() {
  
  for (int i=0; i<contours.size(); i++) {
    
    Contour contour = contours.get(i);
    Rectangle r = contour.getBoundingBox();
    
    if (//(contour.area() > 0.9 * src.width * src.height) ||
        (r.width < blobSizeThreshold || r.height < blobSizeThreshold))
      continue;
    
    stroke(255, 0, 0);
    fill(255, 0, 0, 150);
    strokeWeight(2);
    rect(r.x, r.y, r.width, r.height);
  }
}


void detectBlobs() {
  
  // Contours detected in this frame
  // Passing 'true' sorts them by descending area.
  contours = opencv.findContours(true, true);
  
  newBlobContours = getBlobsFromContours(contours);
  
  //println(contours.length);
  
  // Check if the detected blobs already exist are new or some has disappeared. 
  
  // SCENARIO 1 
  // blobList is empty
  if (blobList.isEmpty()) {
    // Just make a Blob object for every face Rectangle
    for (int i = 0; i < newBlobContours.size(); i++) {
      println("+++ New blob detected with ID: " + blobCount);
      blobList.add(new Blob(this, blobCount, newBlobContours.get(i)));
      blobCount++;
    }
  
  // SCENARIO 2 
  // We have fewer Blob objects than face Rectangles found from OpenCV in this frame
  } else if (blobList.size() <= newBlobContours.size()) {
    boolean[] used = new boolean[newBlobContours.size()];
    // Match existing Blob objects with a Rectangle
    for (Blob b : blobList) {
       // Find the new blob newBlobContours.get(index) that is closest to blob b
       // set used[index] to true so that it can't be used twice
       float record = 50000;
       int index = -1;
       for (int i = 0; i < newBlobContours.size(); i++) {
         float d = dist(newBlobContours.get(i).getBoundingBox().x, newBlobContours.get(i).getBoundingBox().y, b.getBoundingBox().x, b.getBoundingBox().y);
         //float d = dist(blobs[i].x, blobs[i].y, b.r.x, b.r.y);
         if (d < record && !used[i]) {
           record = d;
           index = i;
         } 
       }
       // Update Blob object location
       used[index] = true;
       b.update(newBlobContours.get(index));
    }
    // Add any unused blobs
    for (int i = 0; i < newBlobContours.size(); i++) {
      if (!used[i]) {
        println("+++ New blob detected with ID: " + blobCount);
        blobList.add(new Blob(this, blobCount, newBlobContours.get(i)));
        //blobList.add(new Blob(blobCount, blobs[i].x, blobs[i].y, blobs[i].width, blobs[i].height));
        blobCount++;
      }
    }
  
  // SCENARIO 3 
  // We have more Blob objects than blob Rectangles found from OpenCV in this frame
  } else {
    // All Blob objects start out as available
    for (Blob b : blobList) {
      b.available = true;
    } 
    // Match Rectangle with a Blob object
    for (int i = 0; i < newBlobContours.size(); i++) {
      // Find blob object closest to the newBlobContours.get(i) Contour
      // set available to false
       float record = 50000;
       int index = -1;
       for (int j = 0; j < blobList.size(); j++) {
         Blob b = blobList.get(j);
         float d = dist(newBlobContours.get(i).getBoundingBox().x, newBlobContours.get(i).getBoundingBox().y, b.getBoundingBox().x, b.getBoundingBox().y);
         //float d = dist(blobs[i].x, blobs[i].y, b.r.x, b.r.y);
         if (d < record && b.available) {
           record = d;
           index = j;
         } 
       }
       // Update Blob object location
       Blob b = blobList.get(index);
       b.available = false;
       b.update(newBlobContours.get(i));
    } 
    // Start to kill any left over Blob objects
    for (Blob b : blobList) {
      if (b.available) {
        b.countDown();
        if (b.dead()) {
          b.delete = true;
        } 
      }
    } 
  }
  
  // Delete any blob that should be deleted
  for (int i = blobList.size()-1; i >= 0; i--) {
    Blob b = blobList.get(i);
    if (b.delete) {
      blobList.remove(i);
    } 
  }
}

ArrayList<Contour> getBlobsFromContours(ArrayList<Contour> newContours) {
  
  ArrayList<Contour> newBlobs = new ArrayList<Contour>();
  
  // Which of these contours are blobs?
  for (int i=0; i<newContours.size(); i++) {
    
    Contour contour = newContours.get(i);
    Rectangle r = contour.getBoundingBox();
    
    if (//(contour.area() > 0.9 * src.width * src.height) ||
        (r.width < blobSizeThreshold || r.height < blobSizeThreshold))
      continue;
    
    newBlobs.add(contour);
  }
  
  return newBlobs;
}
