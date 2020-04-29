
int inboundMessages;
int outboundMessages;
int incomingMessages;
int outgoingMessages;
int internalIPs;
Hashtable<String, int[]> internalIPPositions;
Hashtable<String, int[]> externalIPPositions;

void parseMessage(String str){
  
  String[] splitStr = str.trim().split("\\s+");
  if (splitStr.length < 5){
    return;
  }
  if (isLocal(splitStr[2])){
    outboundMessages++;
    if (internalIPPositions.get(splitStr[2]) == null){
      internalIPPositions.put(splitStr[2], new int[]{internalIPs});
      internalIPs++;
    }
    if (externalIPPositions.get(splitStr[4]) == null){
      externalIPPositions.put(splitStr[4], getNewEdge());
    }
    println("outbound direct message");
    //print("Internal pos:"+internalIPPositions.get(splitStr[2])[0]);
    //print (" "+ externalIPPositions.get(splitStr[4]));
    newPaths.add( new Path(internalIPPositions.get(splitStr[2])[0],externalIPPositions.get(splitStr[4]), str, true));
  }else{
    inboundMessages++;
    if (externalIPPositions.get(splitStr[2]) == null){
      externalIPPositions.put(splitStr[2], getNewEdge());
    }
    if (isLocal(splitStr[4])){
      if (internalIPPositions.get(splitStr[4]) == null){
        internalIPPositions.put(splitStr[4], new int[]{internalIPs});
        internalIPs++;
      }
      println("Inbound direct message");
      newPaths.add( new Path(internalIPPositions.get(splitStr[4])[0],externalIPPositions.get(splitStr[2]), str, false));
    }else {
      println("Inbound broadcast");
      newPaths.add( new Path(-1,externalIPPositions.get(splitStr[2]), str, false));
    }
  }
}

// Checks if traffic is from a local address via IP
boolean isLocal(String str){
  if (str.contains("192.168")){
    return true;
  }
  return false;
}
// Check if valid IP
public static boolean validIP(final String ip) {
    String PATTERN = "^((0|1\\d?\\d?|2[0-4]?\\d?|25[0-5]?|[3-9]\\d?)\\.){3}(0|1\\d?\\d?|2[0-4]?\\d?|25[0-5]?|[3-9]\\d?)$";
    return ip.matches(PATTERN);
}

int [] getNewEdge(){
  int coin = int(random(0,2));
  int randomx;
  int randomy;
  if (coin == 1){
    randomx =int( random(0,width));
    coin = int(random(0,2));
    if (coin == 1){
      randomy = 0;
    }else{
      randomy = height;
    }
  }else {
    randomy =int( random(0,height));
    coin = int(random(0,2));
    if (coin == 1){
      randomx = 0;
    }else{
      randomx = width;
    }
  }
  return new int[]{randomx,randomy};
}
