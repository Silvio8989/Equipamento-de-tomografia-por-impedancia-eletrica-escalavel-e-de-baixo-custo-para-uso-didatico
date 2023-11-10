

void calc_img(){
    for (int px = 0 ; px < N_PIXELS; px++) {
        image[px] = 0;
        for (int mi = 0; mi < N_MEDIDAS; mi++) {
            image[px] = image[px] + MA[px][mi]*(ref_vol[mi]-medidas_diff[mi]);
            if (remove_negative && image[px] > 0)
                image[px] = 0;
        }
    }
    PImage img;
    img = createImage(32, 32, RGB);
    for (int px = 0; px < N_PIXELS; px++){
        float a = map(image[px], -img_max_scale, img_max_scale, 1, -1);
        img.pixels[px] = color(mred(a), mgreen(a), mblue(a));
    }
    int diametro = 250;
    int pos_yi=40;
    img.resize(0,diametro);
    image(img, 900, pos_yi+T1y);
    noFill();
    circle(900+(diametro/2),pos_yi+(diametro/2)+T1y,diametro);
    int cx = 1056-160+diametro/2;
    int cy = pos_yi+266-160+diametro/2;
    int raio = (diametro/2)+8;
    textFont(f,16);
    fill(0);
    text("1",cx+raio*sin(PI/8+0*PI/4),cy-raio*cos(PI/8+0*PI/4));
    text("2",cx+raio*sin(PI/8+1*PI/4),cy-raio*cos(PI/8+1*PI/4));
    text("3",cx+raio*sin(PI/8+2*PI/4),cy-raio*cos(PI/8+2*PI/4));
    text("4",cx+raio*sin(PI/8+3*PI/4),cy-raio*cos(PI/8+3*PI/4));
    text("5",cx+raio*sin(PI/8+4*PI/4),cy-raio*cos(PI/8+4*PI/4));
    text("6",cx+raio*sin(PI/8+5*PI/4),cy-raio*cos(PI/8+5*PI/4));
    text("7",cx+raio*sin(PI/8+6*PI/4),cy-raio*cos(PI/8+6*PI/4));
    text("8",cx+raio*sin(PI/8+7*PI/4),cy-raio*cos(PI/8+7*PI/4));
    
    textFont(f,16);
    fill(50);
    text("Removing injecting electrodes",900,pos_yi+T1y-10);
    
}





void calc_img_full(){
    for (int px = 0 ; px < N_PIXELS; px++) {
        image[px] = 0;
        for (int mi = 0; mi < N_MEDIDAS; mi++) {
            image[px] = image[px] + MA_full[px][mi]*(ref_vol[mi]-medidas_diff[mi]);
            if (remove_negative && image[px] > 0)
                image[px] = 0;
        }
    }
    PImage img;
    img = createImage(32, 32, RGB);
    for (int px = 0; px < N_PIXELS; px++){
        float a = map(image[px], -img_max_scale, img_max_scale, 1, -1);
        img.pixels[px] = color(mred(a), mgreen(a), mblue(a));
    }
    int diametro = 250;
    int pos_yi=330;
    img.resize(0,diametro);
    image(img, 900, pos_yi+T1y);
    noFill();
    circle(900+(diametro/2),pos_yi+(diametro/2)+T1y,diametro);
    int cx = 900+156-160+diametro/2;
    int cy = pos_yi+266-160+diametro/2;
    int raio = (diametro/2)+8;
    textFont(f,16);
    fill(0);
    text("1",cx+raio*sin(PI/8+0*PI/4),cy-raio*cos(PI/8+0*PI/4));
    text("2",cx+raio*sin(PI/8+1*PI/4),cy-raio*cos(PI/8+1*PI/4));
    text("3",cx+raio*sin(PI/8+2*PI/4),cy-raio*cos(PI/8+2*PI/4));
    text("4",cx+raio*sin(PI/8+3*PI/4),cy-raio*cos(PI/8+3*PI/4));
    text("5",cx+raio*sin(PI/8+4*PI/4),cy-raio*cos(PI/8+4*PI/4));
    text("6",cx+raio*sin(PI/8+5*PI/4),cy-raio*cos(PI/8+5*PI/4));
    text("7",cx+raio*sin(PI/8+6*PI/4),cy-raio*cos(PI/8+6*PI/4));
    text("8",cx+raio*sin(PI/8+7*PI/4),cy-raio*cos(PI/8+7*PI/4));
    
    textFont(f,16);
    fill(50);
    text("All measurements",900,pos_yi+T1y-10);
}


float interpolate( float val, float y0, float x0, float y1, float x1 ) {
  return (val-x0)*(y1-y0)/(x1-x0) + y0;
}
int mblue( float grayscale ) {
  if ( grayscale < -0.33 ) return 255;
  else if ( grayscale < 0.33 ) return int((interpolate( grayscale, 1.0, -0.33, 0.0, 0.33 ))*255);
  else return 0;
}
int mgreen( float grayscale ) {
  if ( grayscale < -1.0 ) return 0; // unexpected grayscale value
  if  ( grayscale < -0.33 ) return int((interpolate( grayscale, 0.0, -1.0, 1.0, -0.33 ))*255);
  else if ( grayscale < 0.33 ) return 255;
  else if ( grayscale <= 1.0 ) return int((interpolate( grayscale, 1.0, 0.33, 0.0, 1.0 ))*255);
  //else return 255; // unexpected grayscale value
  else return 0; // unexpected grayscale value
}
int mred( float grayscale ) {
  if ( grayscale < -0.33 ) return 0;
  else if ( grayscale < 0.33 ) return int((interpolate( grayscale, 0.0, -0.33, 1.0, 0.33 ))*255);
  else return 255;
}
