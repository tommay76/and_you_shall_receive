
import java.util.*;
int sinMultiplyer = 50;
// Path is a sine wave that goes from an edge of the screen ( determined by outer IP) to a blob on screen.
// One path per message.
// Multiple paths to the same blob will look cool with the differently displaced sin waves
ArrayList<Path> newPaths;
ArrayList<Path> paths;
public class Path {
  int blobIndex;
  int[] outerIP;
  int counter;
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
    counter = 0;
    message = m;
    outgoing = og;
    growing = true;
    timeToLive = 1;
    sineDisplacement = random(0, PI*2);
    x = 0;
    y = 0;
    //println("NEW PATH CREATED");
    //println(blobIndex +", Ip edge = "+ outerIP[0] + ""+outerIP[1]);
    if (outgoing)println(message);
  }
  void display(){
    counter ++;
    if (counter % 2==0)out.playNote( 0,0.01,map(outerIP[0]+outerIP[1],0,1920+1080,100,2000)* random(0.95,1.05));
    if (timeToLive<1)return;
    float pathLength = setUpMatrix();
    fill(140,255,255,255);
    //textSize(30);
    line(0,0,0,pathLength);
    if (outgoing)fill(300,255,255,255);
    //println("time to live"+timeToLive+", length = "+message.length());
    float letters = min (50, message.length());
    for (int i = 0; i <timeToLive; i ++){
      if (growing){
        if (outgoing){

          text(message.charAt((i+counter) %message.length()),
          sin((float)i/letters* pathLength)*sinMultiplyer,
          pathLength -(float)i/letters* pathLength);
        }else {

          text(message.charAt((i+counter) %message.length()), 
          sin(1 - ((float)i/letters)* pathLength)*sinMultiplyer
          ,1 - ((float)i/letters)* pathLength);
        }
      }else{
        if (outgoing){
          text(message.charAt((int)letters-((i+counter) %(int)letters) -1), 
          sin((float)(letters-i -1)/(float)message.length()* pathLength)*sinMultiplyer
          ,pathLength - (float)(message.length()-i -1)/(float)message.length()* pathLength);
        }else {
          text(message.charAt((int)letters-((i+counter) %(int)letters) -1),
          sin((letters-i -1)/letters* pathLength)*sinMultiplyer,
          1 - ((letters-i -1)/letters)* pathLength);
        }
      }
    }
    
    if (timeToLive + 1 >= message.length())  {
      growing = false;
    }
    
    if (growing) timeToLive += SPEED;
    else timeToLive -=SPEED;
    
    popMatrix();
  }
  // Returns magnitude of line between edge of screen and blob 
  float setUpMatrix(){
    
    pushMatrix();
    translate(outerIP[0],outerIP[1]);
    Blob blob = getBlob(blobIndex);
    if (blob == null){
      if (x == 0 || y == 0){
        x = random(0, sizeX);
        y = random(0, sizeY);
      }
    }else {
      x = (float)blob.getBoundingBox().getX() + blob.getBoundingBox().width/2;
      y = (float)blob.getBoundingBox().getY() + blob.getBoundingBox().height/2;
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
    return (timeToLive  < 0) ?  true :  false; // fancy if statements <3
  }
}
