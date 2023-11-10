void draw_measurements_table() {
    fill(100);
    for (int idy = 0; idy < N_ELET; idy++) {
        for (int idx = 0; idx < N_ELET; idx++) {
            text(str(medidas[idx+idy*N_ELET]),idx*100+10+60,idy*20 + 20 + T1y);
        }
    }
}

void draw_graphs() {
    desenha_grid();
    float escala_y1a = escala_y1 * escala;
    float escala_y2a = escala_y2 * escala;
    for (int i = 0; i < N_MEDIDAS-1; i++) {
        if ((i+1)%8!= 0) {
            line(G1x+i*10, G1y-(medidas[i]*escala_y1a), G1x+(i+1)*10, G1y-(medidas[i+1]*escala_y1a));
            circle(G1x+i*10, G1y-(medidas[i]*escala_y1a),3);
            circle(G1x+(i+1)*10, G1y-(medidas[i+1]*escala_y1a),3);
            line(G1x+i*10, G2y-(medidas_diff[i]*escala_y2a), G1x+(i+1)*10, G2y-(medidas_diff[i+1]*escala_y2a));
            circle(G1x+i*10, G2y-(medidas_diff[i]*escala_y2a), 3);
            circle(G1x+(i+1)*10, G2y-(medidas_diff[i+1]*escala_y2a), 3);
        }
    }
}


void desenha_grid() {
    textFont(f,16);                  // STEP 3 Specify font to be used
    fill(200);                         // STEP 4 Specify font color
    stroke(230);
    for (int i = 0; i < 9; i++) {
        line(G1x, G1y-(100*i*escala_y1), G1x+640, G1y-(100*i*escala_y1));
        text(str(i*100/escala),70,G1y-(100*i*escala_y1)+5);   // STEP 5 Display Text
    }
    for (int i = -4; i < 5; i++) {
        line(G1x, G2y-(100*i*escala_y1), G1x+640, G2y-(100*i*escala_y1));
        text(str(i*100/escala),70,G2y-(100*i*escala_y1)+5);   // STEP 5 Display Text
    }
    stroke(0);
}
