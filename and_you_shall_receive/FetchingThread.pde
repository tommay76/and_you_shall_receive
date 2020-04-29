//
//  Collecting input data to use
//  Logs amount of inbound/outbound packets per capture.

import java.io.InputStreamReader;

int threadLive;
ArrayList<String> dataOld;
ArrayList<String> dataNew;
String allLines;
String newAllLines;
Thread collectionThread;
// Difference between these two messages is one is used in collection stage, other is used in display stage

public class MyThread extends Thread {
  @Override
  public void run(){

    try {
      executeCommand();
    }
    catch (IOException e){
      System.out.println("Oh shid");
    }
    threadLive= 0;
    //background(100);
  }
}
void executeCommand() throws IOException {

  //String command = "powershell.exe  your command";
  //Getting the version
  String command = "powershell.exe  C:\\'Program Files'\\Wireshark\\tshark.exe -i 4 -a duration:"+ThreadDuration;
  
  // Executing the command
  Process powerShellProcess = Runtime.getRuntime().exec(command);
  
  // Getting the results
  powerShellProcess.getOutputStream().close();
  String line = null;
  //System.out.println("Standard Output:");
  BufferedReader stdout = new BufferedReader(new InputStreamReader(powerShellProcess.getInputStream()));
  inboundMessages  = 0;
  outboundMessages = 0;
  incomingMessages = 0;
  outgoingMessages = 0;
  internalIPs = 0;
  int count = 0;
  internalIPPositions = new Hashtable<String, int[]>();
  newPaths = new ArrayList<Path>(); 
  externalIPPositions = new Hashtable<String, int[]>();
  while ((line = stdout.readLine()) != null) {
    //println(line);
    //text(line,100,100);
    parseMessage(line);
    newAllLines =newAllLines+ line+ "\n";
    count ++;
    if (count >100) break;
  }
  stdout.close();
  System.out.println("Done");
  allLines = newAllLines;
  newAllLines = null;
  paths = newPaths;
  t = 0;
  out.playNote( 0,0.5,300* random(0.95,1.05));
}
