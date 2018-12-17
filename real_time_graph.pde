import processing.serial.*;
Serial myPort;
static final int name_1=1, name_2=2;
float data_1,data_2;
graphMonitor graph;

void setup(){
    size(1500,1000);
    myPort = new Serial(this,"COM4",115200);//COM4 serial 115200
frameRate(50);
smooth(); //滑らかな曲線を描く、処理が遅いなら削除
  myPort.bufferUntil('\n');//(改行)が受信されるまで通信受け付け
  graph=new graphMonitor("title",100,100,500,150);//String,_TITLE,_X_POSITION,_Y_POSITION,_,_Y_LENGTH
}

void draw(){
    background(25);
    graph.graphDraw(data_1,data_2);
}

void serialEvent(Serial myPort){
  String myString = myPort.readStringUntil('\n');//シリアルバッファから文字を読み、文字列に書き込む。この関数は、終了文字(/n)を検出するかタイムアウトすれば終了する
  if (myString != null) {
    myString = trim(myString);//trim 空白消去
    float sensors[] = float(split(myString, ','));//dataを[,]区切りにして配列代入
    if (sensors.length > 1) {//myPort.available()>1
      switch(int(sensors[0])){
      case name_1://name_1が送られてきたら
          data_1 = sensors[1];
        break;
      case name_2://name_2が送られてきたら
          data_2 = sensors[1];
        break;
         }
      }
    }
}

class graphMonitor {
    String TITLE;
    int X_POSITION, Y_POSITION;
    int X_LENGTH, Y_LENGTH;
    int _COLORS;
    float [] y1, y2;
    float maxRange;
    graphMonitor(String _TITLE, int _X_POSITION, int _Y_POSITION, int _X_LENGTH, int _Y_LENGTH) {
      TITLE = _TITLE;
      X_POSITION = _X_POSITION;
      Y_POSITION = _Y_POSITION;
      X_LENGTH   = _X_LENGTH;
      Y_LENGTH   = _Y_LENGTH;
      y1 = new float[X_LENGTH];
      y2 = new float[X_LENGTH];
        for (int i = 0; i < X_LENGTH; i++) {
        y1[i] = 0;//Initialize rotations 
        y2[i] = 0;
      }
    }
 void graphDraw(float _y1,float _y2) {
      y1[X_LENGTH - 1] = _y1;
      y2[X_LENGTH - 1] = _y2;
      for (int i = 0; i < X_LENGTH - 1; i++) {
        y1[i] = y1[i + 1];
        y2[i] = y2[i + 1];
      }

      maxRange = 1.0;
      for (int i = 0; i < X_LENGTH - 1; i++) {// data value bigger maxRange change ic change
        maxRange = (abs(y1[i]) > maxRange ? abs(y1[i]) : maxRange);
        maxRange = (abs(y2[i]) > maxRange ? abs(y2[i]) : maxRange);
    }

      pushMatrix();//この時点の位置を保持
      translate(X_POSITION, Y_POSITION);//graph position      //
      fill(0);//fill(□) is Light fill(□,□,□)is R,G,B color;  //
      stroke(255);                                            //graph
      strokeWeight(1);                                        //
      rect(0,0, X_LENGTH, Y_LENGTH);//graph form potison      //
      line(0, Y_LENGTH / 2, X_LENGTH, Y_LENGTH / 2);//graph center line

      fill(255);
      text(TITLE, 20, -5);//graph title

      text(nf(maxRange, 0, 1), -50, 18);//maxrange potision
      text(nf(-1 * maxRange, 0, 1), -45, Y_LENGTH);//lowrange potision

      textSize(22);                    //
      fill(255);//white	               //origin  
      translate(0, Y_LENGTH / 2);//初めにtranslataで宣言した graph potisionが原点だがそれをgraph中央に変更
      text(0,-20,7);                   // 0

      fill(255,0,0);//red
      text(nf(y1[X_LENGTH-1],0,2), X_LENGTH+10,-3);//data value display
      fill(0,255,0);//grean      
      text(nf(y2[X_LENGTH-1],0,2), X_LENGTH+85,-3);//text((nfは桁指定),x_potision,y_potision)

      scale(1, -1);//graph data lineのy軸下が正であるため、y軸を－1倍にして上を正とする
      strokeWeight(1);
      for (int i = 0; i < X_LENGTH - 1; i++) {
        stroke(255,0,0);//color 
        line(i, y1[i] * (Y_LENGTH / 2) / maxRange, i + 1, y1[i + 1] * (Y_LENGTH / 2) / maxRange);// graph data output 1
        stroke(0,255,0);//color
        line(i, y2[i] * (Y_LENGTH / 2) / maxRange, i + 1, y2[i + 1] * (Y_LENGTH / 2) / maxRange);// graph data output 2
      }
      popMatrix();//pushMatrix()で保持した位置に戻す
    }
}
