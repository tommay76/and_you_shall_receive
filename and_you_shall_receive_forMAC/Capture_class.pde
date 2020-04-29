
import java.awt.image.BufferedImage;

//
// Function I found which allows me to properly use webcam as capture device
//Requires .jlls in code folder
// WINDOWS SPECIFIC FUNCTION: Ignore/delete this class and just use Capture rather than DCapture if on Mac
//
PImage src, preProcessedImage, processedImage, contoursImage;
OpenCV opencv;
