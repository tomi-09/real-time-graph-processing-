#define nama_1 1
#define nama_2 2
int data_1=0;
int data_2=0;
void setup() {
  Serial.begin(115200);
}
void loop() {

Serial.print(nama_1);//first data
Serial.print(",");//data to separate
Serial.println(data_1);//改行をprocessing側でデータ仕切り信号とする

Serial.print(nama_2);//second data
Serial.print(",");
Serial.println(data_2);

data_1++;//add graph
data_2--;
delay(1000);
}

