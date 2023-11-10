

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
    img.resize(0,320);
    image(img, 900, 80+T1y);
    noFill();
    circle(900+160,80+160+T1y,320);
    int cx = 1056;
    int cy = 346;
    int raio = 168;
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
    text("Removing injecting electrodes",900,60+T1y);
    
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
    img.resize(0,320);
    image(img, 900, 480+T1y);
    noFill();
    circle(900+160,480+160+T1y,320);
    int cx = 900+156;
    int cy = 480+266;
    int raio = 168;
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
    text("All measurements",900,460+T1y);
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
