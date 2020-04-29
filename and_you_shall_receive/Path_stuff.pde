
import java.util.*;

// Path is a sine wave that goes from an edge of the screen ( determined by outer IP) to a blob on screen.
// One path per message.
// Multiple paths to the same blob will look cool with the differently displaced sin waves
ArrayList<Path> newPaths;
public class Path {
  int blobIndex;
  int[] outerIP;

  String message;
  boolean outgoing;
  boolean growing;
  int timeToLive;
  float sineDisplacement;
  float x;
  float y;
  public Path(int b, int[] ip1, String m, boolean og){
    blobIndex = b;
    outerIP = ip1;

    message = m;
    outgoing = og;
    growing = true;
    timeToLive = 1;
    sineDisplacement = random(0, PI*2);
    x = 0;
    y = 0;
  }
  void display(){
    assert(timeToLive != 0);
    float pathLength = setUpMatrix();
    
    for (int i = 0; i <timeToLive; i ++){
      if (growing){
        if (outgoing){
          text(message.charAt(i), 0,i/message.length()* pathLength);
        }else {
          text(message.charAt(i), 0,(1 - i/message.length())* pathLength);
        }
      }else{
        if (outgoing){
          text(message.charAt(message.length()-i), 0,message.length()-i/message.length()* pathLength);
        }else {
          text(message.charAt(message.length()-i), 0,(1 - (message.length()-i)/message.length())* pathLength);
        }
      }
    }
    if (timeToLive == message.length())  {
      growing = false;
    }
    if (growing) timeToLive ++;
    else timeToLive --;
    popMatrix();
  }
  // Returns magnitude of line between edge of screen and blob 
  float setUpMatrix(){
    
    pushMatrix();
    translate(outerIP[0],outerIP[1]);
    Blob blob = getBlob(blobIndex);
    if (blob == null){
      if (x == 0 || y == 0){
        x = random(0, width);
        y = random(0, height);
      }
    }else {
      x = (float)blob.getBoundingBox().getX();
      y = (float)blob.getBoundingBox().getY();
    }
    float angle = atan2(x - outerIP[0], y - outerIP[1]);
    rotate(-angle);
    
    return (float)Math.sqrt((x - outerIP[0])*(x - outerIP[0]) + (y - outerIP[1])*(y-outerIP[1]));
  }
  
  // Blobs, while persistent, still constantly change due to how whacky the blob detection is. Can't rely
  // on a blob staying alive for whole path animation.
  Blob getBlob(int i){
    if (blobList.isEmpty() || i < 0){
      return null;
    }
    if (i >= blobList.size()){
      i = (int)random(0,blobList.size()-1);
    }
    return blobList.get(i);
  }
  //Check if path has finished and should be killed
  boolean done(){
    return (timeToLive == 0) ?  true :  false; // fancy if statements <3
  }
}
