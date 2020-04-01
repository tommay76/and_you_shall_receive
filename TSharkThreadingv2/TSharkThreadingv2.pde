// Uses Windows powershell to run Tshark program and write to Processing sketch
// Use threading so application doesnt have to wait for Tsharks 10 seconds of collection.

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

int threadLive;
ArrayList<String> dataOld;
ArrayList<String> dataNew;
String allLines;
String newAllLines;
Thread collectionThread;
public class MyThread extends Thread {
  @Override
  public void run(){
    threadLive = 1;
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
void setup(){
  fullScreen();
  newAllLines= "";
  allLines = "";
  collectionThread = new MyThread();
  collectionThread.start();
}
void draw(){
  background(0);
  if (allLines != ""){
    text(allLines,10,10,1910,1070);   
  }
  if (threadLive == 0){
    collectionThread = new MyThread();
     collectionThread.start();
     println("\n\n\nYYYYYYYYYYYYYYYY\n\n\n");
  }
 
}




void executeCommand() throws IOException {

  //String command = "powershell.exe  your command";
  //Getting the version
  String command = "powershell.exe  C:\\'Program Files'\\Wireshark\\tshark.exe -i 1 -a duration:3";
  // Executing the command
  Process powerShellProcess = Runtime.getRuntime().exec(command);
  // Getting the results
  powerShellProcess.getOutputStream().close();
  String line;
  System.out.println("Standard Output:");
  BufferedReader stdout = new BufferedReader(new InputStreamReader(
    powerShellProcess.getInputStream()));
  while ((line = stdout.readLine()) != null) {
    text(line,100,100);
   newAllLines =newAllLines+ line+ "\n";
  }
  stdout.close();
  System.out.println("Standard Error:");
  BufferedReader stderr = new BufferedReader(new InputStreamReader(
    powerShellProcess.getErrorStream()));
  while ((line = stderr.readLine()) != null) {
   System.out.println(line);
  }
  stderr.close();
  System.out.println("Done");
  allLines = newAllLines;
  newAllLines = "";
}
