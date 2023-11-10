

import processing.serial.*;   //importa a biblioteca serial.

Serial MasterPort;            //Cria um objeto da classe serial
String Buffer;
String[] token;
int lf = 10;    // Nova linha (Linefeed) em ASCII
int N_ELET = 8;
int N_MEDIDAS = 64;
int N_PIXELS = 1024;
float[] medidas = new float[N_MEDIDAS];
float[] medidas_diff = new float[N_MEDIDAS];
int[] positivo = new int[N_MEDIDAS];
int[] negativo = new int[N_MEDIDAS];

int SIZE_X = 1280;
int SIZE_Y = 1024;
int T1y = 100;
int T2y = 50;
int G1x = 100;
int G1y = 450+T1y;
int G2y = 650+T1y;
float escala_y1 = 0.25;
float escala_y2 = 0.25;
PFont f;                           // STEP 1 Declare PFont variable
boolean le_dados_gravados = false;
String nome_dados = "dados_gravados_0123678c.txt";
String[] lines;
int count_line = 0;
int m;
int frame = 0;
float[][] MA = new float[N_PIXELS][N_MEDIDAS];
float[][] MA_full = new float[N_PIXELS][N_MEDIDAS];
String nome_MA = "MA_sem_injecao.txt";
String nome_MA_full = "MA_todos.txt";
float[] ref_vol = new float[N_MEDIDAS];
boolean get_ref = true;
boolean remove_negative = true;
int ref_count = 0;
int REF_FRAMES = 12;
float[] image = new float[N_PIXELS];
float img_max_scale = 80;
float escala = 1.0;


void setup() { //Prepara o programa.
    size(1280, 1024);
    background(255);
    f = createFont("Arial",5,true); // STEP 2 Create Font
    
    draw_header();
    draw_kb_commands();
    create_diff_vecs(0);
    load_MA();
    start_serial();
    
    m = millis();
}

void draw(){
    Buffer = null;
    
    
    get_buffer();
    
    if (Buffer != null) {        // buffer ok
        
        token = splitTokens(Buffer);
        //println(token);
        
        if (token.length >= 2*N_MEDIDAS) {
            clip(0,T1y,SIZE_X,SIZE_Y-T1y);
            for (int i = 0; i < N_MEDIDAS; i++) {
                medidas[i] = round(float(token[i*2])*100000.0)/100.0;
            }
            for (int i = 0; i < N_MEDIDAS; i++) {
                medidas_diff[i] = medidas[positivo[i]] - medidas[negativo[i]];
            }
            
            background(255);
            frame++;
            textFont(f,16);                  // STEP 3 Specify font to be used
            fill(50);                         // STEP 4 Specify font color
            text("Frame " + str(frame), 60, 200 + T1y);
            text("Rate " + nf( 1000.0/(millis()-m), 0, 2 ) + " frames/sec", 60, 220 + T1y);
            m = millis();
            
            draw_graphs();
            draw_measurements_table();
            
            if (get_ref) {
                textFont(f,16);
                fill(50);
                text("Getting reference voltage", 900, 16 + T1y);
                if (ref_count == 0) for (int i = 0; i < N_MEDIDAS; i++) ref_vol[i] = 0;
                for (int i = 0; i < N_MEDIDAS; i++) ref_vol[i] = ref_vol[i] + (1.0/REF_FRAMES)*medidas_diff[i];
                //arrayCopy(medidas_diff, ref_vol);
                ref_count++;
                if (ref_count == REF_FRAMES){
                    ref_count = 0;
                    get_ref = false;
                }
            }
            else {
                calc_img();
                calc_img_full();
            }
        }
        else{
            atualiza_texto(Buffer, 12, 600, 10, 900, 255);
            //text(Buffer, 60, 980);
        }
    }
}


void get_buffer() {
    if (le_dados_gravados) {
        Buffer = lines[count_line];
        count_line++;
        if (count_line == lines.length){
            count_line = 0;
            frame = 0;
        }
        while (millis()-m < 300) ;
        
    }
    else if (MasterPort.available() > 0){
        Buffer = MasterPort.readStringUntil(lf);
        //println(Buffer);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Escreve um texto em determinada posição apagando o que tinha antes desenhando
// um retângulo branco em cima.
// Esta função só roda quando chamada.
void atualiza_texto(String texto, int tam_fonte, int x, int y, int largura, int borda){
    // apaga o texto anterior desenhando um retânculo branco por cima:
    fill(255);            // cor utilizada
    stroke(borda);           // cor da borda (usar outra para ver o que está sendo apagado)
    rect(x, y-int(0.8*tam_fonte), largura, int(1.1*tam_fonte));
    
    // escreve texto:
    textFont(f, tam_fonte);  // fonte utilizada, tamanho da fonte em pixels
    fill(0);             // cor utilizada
    text(texto, x, y);
}
