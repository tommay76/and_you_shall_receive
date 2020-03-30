int size = 10;
float colourChange;
int cols=200;
int rows=100;
float terrain[][]= new float[cols][rows];
float yeet= 0;
  //PShape moon;
void setup(){
  //moon = createShape();
  //moon.beginShape();
  //moon.vertex(100,0);
  //moon.bezierVertex(0, 0, 100, -100, 200, -200);
  //moon.bezierVertex(100, -100, 0, -200, 80, -200);
  //moon.bezierVertex(-200, 200, 80, -100, 80, 0);
  //moon.bezierVertex(80, -100, 0, 0, 100,0);
  //moon.endShape();
  fullScreen(P3D);
  background(0);
  colorMode(HSB, 100);
  stroke(255);
  colourChange=0;
}

void draw(){ 
  background(0);
  fill(255);
  colourChange+=0.1;
  //shape(moon,width/2,height/2);
  // yeet tracks movement through terrrain
  yeet += 0.01;
  float xx= 0;
  //Create noise 2d array
  for (int i = 0; i < cols; i++){
    float yy = yeet;
    for (int j = 0; j < rows; j++){
      terrain[i][j] = map ( noise(xx,yy),0,1,-60,60);
      yy += 0.1;
    }
    xx +=0.1;
  }
  translate(width/2,height/2);
  rotateX(1.3);
  translate(-width/2,0,100);

   
  
  for (int i = 0; i <rows-1; i++){
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < cols-1; j++){
      //different Styles:
       //Style 1
      //fill(255);
      //strokeWeight(2);
      //stroke(map(terrain[j][i],-60,60,20,255));
      //Style 2
      noStroke();
      fill((colourChange+i/10)%100,map(terrain[j][i],-60,60,80,100),map(terrain[j][i],-60,60,30,80));
      //
      vertex(j*size,i*size,terrain[j][i]);
      vertex(j*size,(i+1)*size,terrain[j][i+1]);
   
    }
    endShape();
  }
  
  for (int i = 0; i <rows-1; i++){
    for (int j = 0; j < cols-1; j++){
      fill(200,50,50);
      strokeWeight(2);
      stroke(100,0,100);
      point(j*size,i*size,terrain[j][i]);
    }
  }
  noFill();

}
