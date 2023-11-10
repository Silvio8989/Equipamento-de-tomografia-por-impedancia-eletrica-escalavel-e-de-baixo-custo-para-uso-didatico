
void draw_kb_commands() {
    int PX0 = 800;
    int PX1 = 1000;
    int tam_linha1 = 12;
    int PY1 = 25;
    textFont(f,10);
    fill(50);
    text("R: get reference", PX0, PY1+tam_linha1*0);
    text("N: remove negative pixels", PX0, PY1+tam_linha1*1);
    text("I: increase image scale", PX0, PY1+tam_linha1*2);
    text("D: decrease image scale", PX0, PY1+tam_linha1*3);
    text("*: increase graph scale", PX0, PY1+tam_linha1*2);
    text("/: decrease graph scale", PX0, PY1+tam_linha1*3);
    text("1-4: change frequency [ 200 > 125 > 100 > 50 ]kHz", PX1, PY1+tam_linha1*0);
    text("l: get frames", PX1, PY1+tam_linha1*1);
    text("p: stop measurement", PX1, PY1+tam_linha1*2);
    text("w: decrease skip pattern", PX1, PY1+tam_linha1*4);
    text("z: increase skip pattern", PX1, PY1+tam_linha1*3);
    text("y: increase nbr of points", PX1, PY1+tam_linha1*5);
    text("t: decrease nbr of points", PX1, PY1+tam_linha1*6);
}

void keyPressed() {
    if (key == 'R'){
        get_ref = true;
    }
    else if (key == 'N'){
        if(remove_negative)
            remove_negative = false;
        else
            remove_negative = true;
    }
    else if (key == 'I'){
        img_max_scale = img_max_scale*1.2;
        atualiza_texto("img_max_scale = " + str(img_max_scale), 12, 600, 10, 900, 255);
    }
    else if (key == 'D'){
        img_max_scale = img_max_scale/1.2;
        atualiza_texto("img_max_scale = " + str(img_max_scale), 12, 600, 10, 900, 255);
    }
    else if (key == '*'){
        escala = escala*2.0;
        atualiza_texto("Escala = " + str(escala), 12, 600, 10, 900, 255);
    }
    else if (key == '/'){
        escala = escala / 2.0;
        atualiza_texto("Escala = " + str(escala), 12, 600, 10, 900, 255);
    }
    else if ((le_dados_gravados == false) && (key >= '0') && (key <= 'z')) {
        MasterPort.write(key);
    }
}
