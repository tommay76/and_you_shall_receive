# ADAD3400
The following works are written in Java for the software Sketchbook [Processing](https://processing.org/)
###FINAL WORK###

#and_you_shall_receive:

This work is a multithreaded visualisation of local internet traffic that is captured from a local machine. The work aims to shed light on the 
sheer amount of data that is constantly being transferred invisibly and to some, unknowingly every second of the day.

I built this on a Windows OS, but I did attempt to also write a version for Mac users as well.
To get it working on windows or mac, you'll need to download Processing, as well as wireshark, which can be done simply online or through the terminal.




TSharkThreading v1:
No threading, the red backgroundis set at setup, and set to green at draw. However, you will note the sketch doesnt turn green for a few seconds as the sketch needs to wait for the powershell process to end.
Note that this won't work on mac as it implements the Windows powershell and my personal PC's file Paths.

TSharkThreading v2:
Threads make this script much more viable : )

Textdump.pde is my most visually appealing in my opinion.
