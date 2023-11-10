

void draw_header() {
    textFont(f,T1y);
    fill(50);
    text("EITduino", 60+10 + T1y, T1y-10);

    PImage img_logo;
    img_logo = loadImage("logo_UFABC.png");
    img_logo.resize(0,T1y);
    image(img_logo, 60, 0);
}

void create_diff_vecs(int skip_pattern) {
    int cont = 0;
    for (int idy = 0; idy < N_ELET; idy++) {
        for (int idx = 0; idx < N_ELET; idx++) {
            positivo[cont] = idy*N_ELET + idx;
            negativo[cont] = idy*N_ELET + (idx+1+skip_pattern)%N_ELET;
            cont++;
        }
    }
}

void load_MA() {
    String[] lines_MA;
    String[] lines_MA_full;
    lines_MA = loadStrings(nome_MA);
    lines_MA_full = loadStrings(nome_MA_full);
    for (int px = 0 ; px < lines_MA.length; px++) {
        token = splitTokens(lines_MA[px]);
        for (int mi = 0; mi < N_MEDIDAS; mi++) {
            MA[px][mi] =  float(token[mi]);
        }
        token = splitTokens(lines_MA_full[px]);
        for (int mi = 0; mi < N_MEDIDAS; mi++) {
            MA_full[px][mi] =  float(token[mi]);
        }
    }
}
/*
void start_serial() {
    //String portNum = Serial.list()[0]; // porta no Windows é a primeira
    String portNum = Serial.list()[Serial.list().length -1]; // porta no Linux é a última
    println("Portas seriais disponiveis:");
    println(Serial.list());
    println("Porta serial em uso:");
    println(portNum);
    
    if (portNum.equals("/dev/ttyS0") == true) {
        println("Dispositivo não disponível. Lendo dados gravados.");
        le_dados_gravados = true;
        lines = loadStrings(nome_dados);
    }
    else {
        // Inicializa a porta
        MasterPort = new Serial(this, portNum, 115200);
        
        // joga fora a primeira leitura, diminui a chance de pegar a mensagem no meio
        MasterPort.clear();
        Buffer = MasterPort.readStringUntil(lf);
        Buffer = null;
    }
}*/

void start_serial() {
    //String portNum = Serial.list()[0]; // porta no Windows é a primeira
    String portNum;
    String[] ports = Serial.list();
    if (ports.length != 0) {
        portNum = Serial.list()[Serial.list().length -1]; // porta no Linux é a última
        println("Portas seriais disponiveis:");
        println(ports);
        println("Porta serial em uso:");
        println(portNum);
        if (portNum.equals("/dev/ttyS31") == true) {
            println("Dispositivo não disponível. Lendo dados gravados.");
            le_dados_gravados = true;
            lines = loadStrings(nome_dados);
            println("there are " + lines.length + " lines");
            println(lines[0]);
        }
        else {
            // Inicializa a porta
            MasterPort = new Serial(this, portNum, 115200);
            
            // joga fora a primeira leitura, diminui a chance de pegar a mensagem no meio
            MasterPort.clear();
            Buffer = MasterPort.readStringUntil(lf);
            Buffer = null;
        }
    }
    else {
        println("Nenhuma porta serial encontrada!");
        println("Dispositivo não disponível. Lendo dados gravados.");
        le_dados_gravados = true;
        lines = loadStrings(nome_dados);
        println("there are " + lines.length + " lines");
        println(lines[0]);
    }
}
