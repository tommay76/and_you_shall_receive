

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
int threadLive;
public class MyThread extends Thread {
  @Override
  public void run(){
    threadLive = 1;
    try {
      executeCommand();
    }
    catch (IOException e){
      System.out.println("OH shid");
    }
    threadLive= 0;
    //background(100);
  }
}
void setup(){
  fullScreen();
  Thread collectionThread = new MyThread();
  collectionThread.start();
}
void draw(){
  if (threadLive == 1)background(255,0,0);
  else background(0,255,0);
}
void executeCommand() throws IOException {

  //String command = "powershell.exe  your command";
  //Getting the version
  String command = "powershell.exe  C:\\'Program Files'\\Wireshark\\tshark.exe -i 1 -a duration:10";
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
}
