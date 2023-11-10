#include <Wire_slave.h>
#include "ad9850.h"

#define MEU_ENDERECO 0X40

#include "stm32_adc_dual_mode.h"
#include "dft.h"

int npontos_base, n_pontos_mult;

const float referenceVolts= 3.3;
float sample_freq =  (72e6 / 6.0 / 20.0); // = 600kHz
float freq_sinal = 50000;  // 50kHz
float phase1, phase2, amplitude1, amplitude2;
int NUM_SAMPLES = 24;      // number of samples for each ADCx. Each channel will be sampled NUM_SAMPLES/CHANNELS_PER_ADC
byte comando = 0;
boolean mediu = false;

typedef union{
  float floatingPoint;
  byte binary[4];
} binaryFloat;

#define CHANNELS_PER_ADC  1                      // number of channels for each ADC. Must match values in ADCx_Sequence array below
#define ADC_SMPR          ADC_SMPR_7_5           // when using dual mode, each pair of channels must have same rate. Here all channels have the same
#define NUM_SAMPLES_MAX   500                    // number of samples for each ADCx. Each channel will be sampled NUM_SAMPLES/CHANNELS_PER_ADC
#define PRE_SCALER        RCC_ADCPRE_PCLK_DIV_6  // Prescaler do ADC
#define FAST_INTERLEAVED  false                  // Fast Interleave Mode Flag. Para "dobrar" taxa de amostragem medindo o mesmo canal dos 2 ADCs.
                                                 // Se 'false', habilita "Regular simultaneous mode". Se 'true', habilita "Fast interleaved mode".

#define LED PC13

uint32 adcbuf[NUM_SAMPLES_MAX+1];  // buffer to hold samples, ADC1 16bit, ADC2 16 bit
uint16_t datav1[NUM_SAMPLES_MAX+1];
uint16_t datav2[NUM_SAMPLES_MAX+1];

// O STM32F103 possui 10 pinos do ADC disponíveis:
// pino A0 (PA0) -> 0 (ADC0)
// ...
// pino A7 (PA7) -> 7 (ADC7)
// pino B0 (PB0) -> 8 (ADC8)
// pino B1 (PB1) -> 9 (ADC9)
// Para "dobrar" taxa de amostragem (FAST_INTERLEAVED true), medir o mesmo canal dos 2 ADCs.
uint8 ADC1_Sequence[]={8,0,0,0,0,0};   // ADC1 channels sequence, left to right. Unused values must be 0. Note that these are ADC channels, not pins  
uint8 ADC2_Sequence[]={9,0,0,0,0,0};   // ADC2 channels sequence, left to right. Unused values must be 0



void dadorecebido(int howmany){
  comando = Wire.read();   
}

void dadopedido(){
  if(mediu){
    for(int i=0;i<(NUM_SAMPLES);i++){
      binaryFloat amplitude, fase;
      amplitude.floatingPoint = amplitude1;
      Wire.write(amplitude.binary, 4);
      fase.floatingPoint = phase2-phase1;
      Wire.write(fase.binary, 4);
    }
    //mediu = false;
  }
  else{
    for(int i=0;i<(NUM_SAMPLES*8);i++) Wire.write((byte) 0x00, 1);
  }
}

void processacomando(){
  switch (comando) {
    case 1: // 200Khz 3 pontos (6)
      ad9850_sendFrequency(200000);
      freq_sinal = 200000;
      npontos_base = 3;
      n_pontos_mult = 2;
      NUM_SAMPLES = npontos_base*n_pontos_mult;
      break;
   
    case 2: // 125Khz 24 pontos (24)
      ad9850_sendFrequency(125000); 
      freq_sinal = 125000;
      npontos_base = 24;
      n_pontos_mult = 1;
      NUM_SAMPLES = npontos_base*n_pontos_mult;
      break;
   
    case 3: // 100Khz 6 pontos (12)
      ad9850_sendFrequency(100000);
      freq_sinal = 100000;
      npontos_base = 6;
      n_pontos_mult = 2;
      NUM_SAMPLES = npontos_base*n_pontos_mult;
      break;
    
    case 4: // 50Khz 12 pontos (24)
      ad9850_sendFrequency(50000);
      freq_sinal = 50000;
      npontos_base = 12;
      n_pontos_mult = 2;
      NUM_SAMPLES = npontos_base*n_pontos_mult;
      break; 

    case 'i': // realiza medidas
      mede_ADC();
      break; 
      
    default:
      break;
  }
  comando =0;
}

void mede_ADC(){
  digitalWrite(LED, LOW); // Verificação de funcionamento
  // medindo valores:
  start_convertion_dual_channel(adcbuf, NUM_SAMPLES);
  wait_convertion_dual_channel();

  // separando valores lidos nos 2 ADCs:
  for(int i=0;i<(NUM_SAMPLES);i++) {
    datav1[i] = ((adcbuf[i] & 0xFFFF0000) >>16);
    datav2[i] = (adcbuf[i] & 0xFFFF);
  }

  // calculando amplitudes e fases
  float media1 = sinal_medio (datav1, NUM_SAMPLES);
  phase1 = 0;
  amplitude1 =   calc_dft_singfreq(datav1, freq_sinal, sample_freq, media1, 10000, NUM_SAMPLES, &phase1);
  
  float media2 = sinal_medio (datav2, NUM_SAMPLES);
  phase2 = 0;
  amplitude2 =   calc_dft_singfreq(datav2, freq_sinal, sample_freq, media2, 10000, NUM_SAMPLES, &phase2);

  mediu = true;
  digitalWrite(LED, HIGH); // Verificação de funcionamento
}


void setup(){ 
  Wire.begin(MEU_ENDERECO);                // join i2c bus with address #4
  Wire.onReceive(dadorecebido); // register event
  Wire.onRequest(dadopedido);      // dado solicitado
  
   //Serial.begin(115200); // só usar para debigar...
  set_adc_dual_channel(PRE_SCALER, ADC_SMPR, CHANNELS_PER_ADC, ADC1_Sequence, ADC2_Sequence, FAST_INTERLEAVED);  // initial ADC1 and ADC2 settings

  ad9850_setup(); 
  ad9850_sendFrequency(50000);

  pinMode(LED, OUTPUT); // LED para verificação de funcionamento do eletrodo
  digitalWrite(LED, HIGH); // Verificação de funcionamento  
}

void loop(){
  if(comando!=0){
    processacomando();
  }
}


  




