import javax.imageio.*;
import java.awt.image.*; 
import processing.video.*;

DCapture cap;
PImage img; 
void setup() 
{
  size(1920, 1080);
  background(0);
  cap = new DCapture();
}
 
void draw()
{
  img = cap.updateImage();
  image(img, 0, 0, cap.width, cap.height);
  // We need a buffered image to do the JPG encoding
  int w = img.width;
  int h = img.height;
  BufferedImage b = new BufferedImage(w,h,BufferedImage.TYPE_INT_RGB);

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  b.setRGB( 0, 0, w, h, img.pixels, 0, w);

  // Need these output streams to get image as bytes for UDP
  ByteArrayOutputStream baStream = new ByteArrayOutputStream();
  BufferedOutputStream bos = new BufferedOutputStream(baStream);

  // JPG compression into BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(b, "jpg", bos);
  } catch (IOException e) {
    e.printStackTrace();
  }
}
