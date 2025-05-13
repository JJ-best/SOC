//to run simulation, you should chage the file name in "run_sim" from fir.c to fir_control.c
#include <defs.h>  //Caravel Memory Map IO 

// User Project 
#define reg_fir_control (*(volatile uint32_t*) 0x30000000)
#define reg_fir_data_len (*(volatile uint32_t*) 0x30000010)
#define reg_fir_tap_num (*(volatile uint32_t*) 0x30000014)

#define reg_fir_x (*(volatile uint32_t*) 0x30000040)
#define reg_fir_y (*(volatile uint32_t*) 0x30000044)

#define reg_fir_coeff     (*(volatile uint32_t*) 0x30000080)
// #define tap0 (*(volatile uint32_t*) 0x30000080)
// #define tap1 (*(volatile uint32_t*) 0x30000084)
// #define tap2 (*(volatile uint32_t*) 0x30000088)
// #define tap3 (*(volatile uint32_t*) 0x3000008c)
// #define tap4 (*(volatile uint32_t*) 0x30000090)
// #define tap5 (*(volatile uint32_t*) 0x30000094)
// #define tap6 (*(volatile uint32_t*) 0x30000098)
// #define tap7 (*(volatile uint32_t*) 0x3000009c)
// #define tap8 (*(volatile uint32_t*) 0x300000A0)
// #define tap9 (*(volatile uint32_t*) 0x300000A4)
// #define tap10 (*(volatile uint32_t*) 0x300000A8)

#define TAP_NUM      11
#define DATA_LEN     64

static const int32_t init_taps[TAP_NUM] = { 
    0, -10, -9, 23, 56, 63, 56, 23, -9, -10, 0
};
int outputsignal[64];
////up can be fir.h///////////////////////////////////////////////////////////

void __attribute__ ( ( section ( ".mprjram" ) ) ) initfir() {
	//initial your fir
	reg_fir_data_len = DATA_LEN;             //progrm data_len
    	reg_fir_tap_num = TAP_NUM;               //progrm tap_num
	for (int i = 0; i < TAP_NUM; i++) {      //progrm coeff
        (&reg_fir_coeff)[i] = init_taps[i];
    }

	return;
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) fir(){
	initfir();
	reg_fir_control = 1;  //ap_start
	
	reg_mprj_datal = (0xA5 << 16);// start timer  0xA5 is StartMark

	//write down your fir
	// i = 0
	// i = 0
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 0;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[0] = reg_fir_y;

	// i = 1
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 1;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[1] = reg_fir_y;

	// i = 2
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 2;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[2] = reg_fir_y;

	// i = 3
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 3;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[3] = reg_fir_y;

	// i = 4
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 4;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[4] = reg_fir_y;

	// i = 5
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 5;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[5] = reg_fir_y;

	// i = 6
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 6;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[6] = reg_fir_y;

	// i = 7
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 7;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[7] = reg_fir_y;

	// i = 8
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 8;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[8] = reg_fir_y;

	// i = 9
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 9;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[9] = reg_fir_y;

	// i = 10
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 10;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[10] = reg_fir_y;

	// i = 11
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 11;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[11] = reg_fir_y;

	// i = 12
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 12;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[12] = reg_fir_y;

	// i = 13
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 13;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[13] = reg_fir_y;

	// i = 14
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 14;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[14] = reg_fir_y;

	// i = 15
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 15;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[15] = reg_fir_y;

	// i = 16
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 16;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[16] = reg_fir_y;

	// i = 17
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 17;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[17] = reg_fir_y;

	// i = 18
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 18;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[18] = reg_fir_y;

	// i = 19
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 19;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[19] = reg_fir_y;

	// i = 20
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 20;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[20] = reg_fir_y;

	// i = 21
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 21;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[21] = reg_fir_y;

	// i = 22
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 22;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[22] = reg_fir_y;

	// i = 23
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 23;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[23] = reg_fir_y;

	// i = 24
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 24;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[24] = reg_fir_y;

	// i = 25
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 25;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[25] = reg_fir_y;

	// i = 26
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 26;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[26] = reg_fir_y;

	// i = 27
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 27;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[27] = reg_fir_y;

	// i = 28
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 28;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[28] = reg_fir_y;

	// i = 29
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 29;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[29] = reg_fir_y;

	// i = 30
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 30;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[30] = reg_fir_y;

	// i = 31
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 31;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[31] = reg_fir_y;

	// i = 32
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 32;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[32] = reg_fir_y;

	// i = 33
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 33;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[33] = reg_fir_y;

	// i = 34
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 34;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[34] = reg_fir_y;

	// i = 35
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 35;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[35] = reg_fir_y;

	// i = 36
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 36;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[36] = reg_fir_y;

	// i = 37
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 37;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[37] = reg_fir_y;

	// i = 38
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 38;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[38] = reg_fir_y;

	// i = 39
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 39;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[39] = reg_fir_y;

	// i = 40
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 40;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[40] = reg_fir_y;

	// i = 41
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 41;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[41] = reg_fir_y;

	// i = 42
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 42;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[42] = reg_fir_y;

	// i = 43
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 43;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[43] = reg_fir_y;

	// i = 44
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 44;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[44] = reg_fir_y;

	// i = 45
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 45;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[45] = reg_fir_y;

	// i = 46
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 46;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[46] = reg_fir_y;

	// i = 47
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 47;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[47] = reg_fir_y;

	// i = 48
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 48;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[48] = reg_fir_y;

	// i = 49
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 49;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[49] = reg_fir_y;

	// i = 50
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 50;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[50] = reg_fir_y;

	// i = 51
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 51;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[51] = reg_fir_y;

	// i = 52
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 52;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[52] = reg_fir_y;

	// i = 53
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 53;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[53] = reg_fir_y;

	// i = 54
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 54;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[54] = reg_fir_y;

	// i = 55
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 55;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[55] = reg_fir_y;

	// i = 56
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 56;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[56] = reg_fir_y;

	// i = 57
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 57;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[57] = reg_fir_y;

	// i = 58
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 58;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[58] = reg_fir_y;

	// i = 59
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 59;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[59] = reg_fir_y;

	// i = 60
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 60;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[60] = reg_fir_y;

	// i = 61
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 61;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[61] = reg_fir_y;

	// i = 62
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 62;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[62] = reg_fir_y;

	// i = 63
	// while ((reg_fir_control >> 4) & 1 != 1) {}
	reg_fir_x = 63;
	// while ((reg_fir_control >> 5) & 1 != 1) {}
	outputsignal[63] = reg_fir_y;


	// output to mprj[31:24], and stop timer
	reg_mprj_datal = ((outputsignal[DATA_LEN - 1] & 0xFF) << 24) | (0x5A << 16); //
	//{reg_mprj_datal[31:24], reg_mprj_datal[23:16]} = {Yn[7:0], 0x5A}   0x5A is EndMark
	while ((reg_fir_control & 0x02) != 0x02);// for 800ver.(fir.v version12) we need this line
	return outputsignal;

    }

