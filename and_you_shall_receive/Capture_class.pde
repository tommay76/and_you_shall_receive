import de.humatic.dsj.*;
import java.awt.image.BufferedImage;

//
// Function I found which allows me to properly use webcam as capture device
//Requires .jlls in code folder
// WINDOWS SPECIFIC FUNCTION: Ignore/delete this class and just use Capture rather than DCapture if on Mac
//
PImage src, preProcessedImage, processedImage, contoursImage;
OpenCV opencv;
DCapture video;
class DCapture implements java.beans.PropertyChangeListener {

  private DSCapture capture;
  public int width, height;

  DCapture() {
    DSFilterInfo[][] dsi = DSCapture.queryDevices();
    println(dsi[0].length);
    println(dsi[1].length);
    capture = new DSCapture(DSFiltergraph.DD7, dsi[0][1], false, 
    DSFilterInfo.doNotRender(), this);
    width = capture.getDisplaySize().width;
    height = capture.getDisplaySize().height;
  }

  public PImage updateImage() {
    PImage img = createImage(width, height, RGB);
    BufferedImage bimg = capture.getImage();
    bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
    img.updatePixels();
    img.resize(sizeX,sizeY);
    return img;
  }

  public void propertyChange(java.beans.PropertyChangeEvent e) {
    switch (DSJUtils.getEventType(e)) {
    }
  }
}
