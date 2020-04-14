import processing.serial.*; //<>//

Serial myPort;  // Create object from Serial class


 
int topbar = 50;
int leftbar = 50;
int frameHeight;
int frameWidth;

float[] values0, values1, values2, values3, values4, values5, values6;

void setup() 
{
  size(1600, 800);
  //myPort = new Serial(this, "COM8", 115200);
  myPort = new Serial(this, "COM8", 2000000);
 
  frameHeight = height - topbar;
  frameWidth = width - leftbar;
  values0 = new float[frameWidth];
  values1 = new float[frameWidth];
  values2 = new float[frameWidth];
  values3 = new float[frameWidth];
  values4 = new float[frameWidth];
  values5 = new float[frameWidth];
  values6 = new float[frameWidth];
  smooth();
}

int state = 0;
float[] temp = new float[7];
float[] getData(){
  float f0 = -1000000000;
  float f1 = -1000000000;
  float f2 = -1000000000;
  float f3 = -1000000000;
  float f4 = -1000000000;
  float f5 = -1000000000;
  float f6 = -1000000000;
  byte [] inData0 = new byte[4];
  byte [] inData1 = new byte[4];
  byte [] inData2 = new byte[4];
  byte [] inData3 = new byte[4];
  byte [] inData4 = new byte[4];
  byte [] inData5 = new byte[4];
  byte [] inData6 = new byte[4];
  int intbit0 = 0;
  int intbit1 = 0;
  int intbit2 = 0;
  int intbit3 = 0;
  int intbit4 = 0;
  int intbit5 = 0;
  int intbit6 = 0;
  while (myPort.available() > 0) {
    if(state ==0 & myPort.read() == 195 ) {
      state = 1;
    }
    if(state ==1 & myPort.read() == 192 ) {
      state = 2;
    }
    if(state ==2 & myPort.read() == 105 ) {
      state = 3;
    }
    if(state ==3 & myPort.read() == 95 ) {
      state = 4;
    }
    if (state ==4){
      myPort.readBytes(inData0);
      myPort.readBytes(inData1);
      myPort.readBytes(inData2);
      myPort.readBytes(inData3);
      myPort.readBytes(inData4);
      myPort.readBytes(inData5);
      myPort.readBytes(inData6);
      intbit0 = (inData0[3] << 24) | ((inData0[2] & 0xff) << 16) | ((inData0[1] & 0xff) << 8) | (inData0[0] & 0xff);
      intbit1 = (inData1[3] << 24) | ((inData1[2] & 0xff) << 16) | ((inData1[1] & 0xff) << 8) | (inData1[0] & 0xff);
      intbit2 = (inData2[3] << 24) | ((inData2[2] & 0xff) << 16) | ((inData2[1] & 0xff) << 8) | (inData2[0] & 0xff);
      intbit3 = (inData3[3] << 24) | ((inData3[2] & 0xff) << 16) | ((inData3[1] & 0xff) << 8) | (inData3[0] & 0xff);
      intbit4 = (inData4[3] << 24) | ((inData4[2] & 0xff) << 16) | ((inData4[1] & 0xff) << 8) | (inData4[0] & 0xff);
      intbit5 = (inData5[3] << 24) | ((inData5[2] & 0xff) << 16) | ((inData5[1] & 0xff) << 8) | (inData5[0] & 0xff);
      intbit6 = (inData6[3] << 24) | ((inData6[2] & 0xff) << 16) | ((inData6[1] & 0xff) << 8) | (inData6[0] & 0xff);
      f0 = Float.intBitsToFloat(intbit0);
      f1 = Float.intBitsToFloat(intbit1);
      f2 = Float.intBitsToFloat(intbit2);
      f3 = Float.intBitsToFloat(intbit3);
      f4 = Float.intBitsToFloat(intbit4);
      f5 = Float.intBitsToFloat(intbit5);
      f6 = Float.intBitsToFloat(intbit6);
      state = 0;
      temp[0] = f0;
      temp[1] = f1;
      temp[2] = f2;
      temp[3] = f3;
      temp[4] = f4;
      temp[5] = f5;
      temp[6] = f6;
        } }
    return temp;      
}


float scaledY(float val) {
  return (float)(topbar+ frameHeight/2 - (vshift*100 + val+500) / (50000) *vscale* (frameHeight - 1));
}

void pushValue(float[] tmp) {
  for (int i=0; i<frameWidth-1; i++){
    values0[i] = values0[i+1];
    values0[frameWidth-1] = tmp[0];

    values1[i] = values1[i+1];
    values1[frameWidth-1] = tmp[1];

    values2[i] = values2[i+1];
    values2[frameWidth-1] = tmp[2];

    values3[i] = values3[i+1];
    values3[frameWidth-1] = (tmp[3]-25)*1000;

    values4[i] = values4[i+1];
    values4[frameWidth-1] = (tmp[4])*10;

    values5[i] = values5[i+1];
    values5[frameWidth-1] = (tmp[5])*10;

    values6[i] = values6[i+1];
    values6[frameWidth-1] = (tmp[6])*10;

}
}

void drawLines(float[] dataVal, int r, int g, int b, int thk) {
  stroke(r,g,b);
  strokeWeight(thk);
  int displayWidth = (int) (frameWidth/scale);
  int k = dataVal.length - displayWidth;
  float x0 = 0;
  float y0 = scaledY(dataVal[k]);
  for (int i=1; i<displayWidth; i++) {
    k++;
    float x1 = (int) (i * (frameWidth-1) / (displayWidth-1));
    float y1 = scaledY(dataVal[k]);
    line(x0+50, y0, x1+50, y1);
    //point(x1+50,y1);
    x0 = x1;
    y0 = y1;
  }
}


void drawGrid() {
  stroke(255, 255, 255,60);
  strokeWeight(1);
  for(int i=0; i<=5; i++){  
  line(leftbar, topbar+frameHeight*i/5, leftbar+frameWidth, topbar+frameHeight*i/5); // horizontal
  }
  
  for (int i = 0; i<=10; i++){  
  line(leftbar+frameWidth*i/10, topbar, leftbar+frameWidth*i/10, height); // vertical
  }
}

void addText(float valtxt0, float valtxt1, float valtxt2, float valtxt3, float valtxt4, float valtxt5, float valtxt6) {
  textSize(24);
  // channel labels
  fill(255, 255, 0);
  text("Bx[mG]:"+nf(valtxt0,0,2), leftbar, 30);
  fill(255, 0, 255);
  text("By[mG]:"+nf(valtxt1,0,2), leftbar+210, 30);
  fill(0, 255, 255);
  text("Bz[mG]:"+nf(valtxt2,0,2), leftbar+420, 30);
  fill(255, 255, 255);
  text("Temp:"+nf(valtxt3,0,2), leftbar+660, 30);
  fill(255, 255, 0);
  text("gx:"+nf(valtxt4,0,2), leftbar+850, 30);
  fill(255, 0, 255);
  text("gy:"+nf(valtxt5,0,2), leftbar+1000, 30);
  fill(0, 255, 255);
  text("gz:"+nf(valtxt6,0,2), leftbar+1150, 30);
  }


float scale = 1.0;
float vscale = 1.0;
float vshift = 0.0;
void keyReleased() {
  switch (key) {
    case '+':
      scale *= 2.0f;
      if ( (int) (frameWidth / scale) <= 1 )
        scale /= 2.0f;
      break;
    case '-':
      scale /= 2.0f;
      if (scale < 1.0f)
        scale *= 2.0f;
      break;

    case '4':
      vscale *= 2.0f;
      if ( (int) (frameWidth / vscale) <= 1 )
        vscale /= 1.2f;
      break;
    case '1':
      vscale /= 2.0f;
      if (vscale < 1.0f)
        vscale *= 1.2f;
      break;

    case '6':
      vshift += 1.0f;
      if ( (int) (frameWidth / vshift) <= 1 )
        vshift += 1.0f;
      break;
    case '3':
      vshift -= 1.0f;
      if (vshift < 1.0f)
        vshift -= 1.0f;
      break;
    case '5':
      vshift = 1.0;
      vscale = 1.0;
      scale = 1.0;
      break;

}

  println(scale);
  println(vscale);
}

void draw() {
    background(0);
    drawGrid();
    float[] val = new float[7];
    val = getData();

    if (val[0] != -1000000000 & val[1] != -1000000000 & val[2] != -1000000000 & val[3] != -1000000000 & val[4] != -1000000000 & val[5] != -1000000000 & val[6] != -1000000000){
      pushValue(val);
      //println(val[0]);
      //println(val[1]);
      //println(val[2]);
      //println(val[3]);
    }
    addText(val[0], val[1], val[2], val[3], val[4], val[5], val[6]);
    drawLines(values0, 255,255,0,2);
    drawLines(values1, 255,0,255,2);
    drawLines(values2, 0,255,255,2);
    drawLines(values3, 255,255,255,2);
    drawLines(values4, 255,255,0,1);
    drawLines(values5, 255,0,255,1);
    drawLines(values6, 0,255,255,1);
}
