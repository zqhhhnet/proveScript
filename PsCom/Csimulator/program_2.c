// store the value in the data.txt,
// The first 16 values are for vectors of the matrix of 
// network, and the last 4 values are the vector of
// weights.

#include "arm_commands.h"
#include <time.h>

#define MAXSIZE 150

clock_t tstart, tend;
double duration;

void translate2Bin(char str[], char size[], int ele_len, char bin[], char dt[], char vec[][MAXSIZE]){
	int len, ele_num, i;
	len = strlen(str);
	char mod_128[MAXSIZE] = "340282366920938463463374607431768211456";
	mod_128[39] = '\0';
	int len_mod128 = strlen(mod_128);
	char mod_64[MAXSIZE] = "18446744073709551616";
	mod_64[20] = '\0';
	int len_mod64 = strlen(mod_64);
	char mod_32[MAXSIZE] = "4294967296";
	mod_32[10] = '\0';
	int len_mod32 = strlen(mod_32);
	if(strcmp(size, "128") == 0){
		length = 39;
		if(len >= 39){
			Bigmod(str, len, mod_128, len_mod128);
		}
	} else if(strcmp(size, "32") == 0){
		length = 10;
		if(len >= 10){
			Bigmod(str, len, mod_32, len_mod32);
		}
	} else if(strcmp(size, "64") == 0){
		length = 20;
		if(len >= 20){
			Bigmod(str, len, mod_64, len_mod64);
		}
	}
	
	char temp[MAXSIZE];
	memset(temp, '\0', MAXSIZE);
	
	if(strcmp(size, "128") == 0){
		//printf("strA %s\n", str);
		DecToBin(str, bin, 128);
		//printf("binA %s\n", bin);
		ele_num = setVec(vec, bin, dt);
	}else if(strcmp(size, "32") == 0){
		DecToBin(str, bin, 32);
		extract(bin, 0, ele_len-1, temp);
		strcpy(bin, temp);
		memset(temp, '\0', MAXSIZE);
	}else if(strcmp(size, "64") == 0){
		DecToBin(str, bin, 64);
	}
}

int main(){
	char q0[MAXSIZE], q1[MAXSIZE], q2[MAXSIZE], q3[MAXSIZE], q4[MAXSIZE], q5[MAXSIZE];
	char r0[MAXSIZE], r1[MAXSIZE];
	char vec0[16][MAXSIZE], vec1[16][MAXSIZE], vec2[16][MAXSIZE], vec3[16][MAXSIZE], vec4[16][MAXSIZE], vec5[16][MAXSIZE], vectemp[16][MAXSIZE];
	char binA[MAXSIZE], binB[MAXSIZE], output[MAXSIZE], Rdes[MAXSIZE];
	char data[20][MAXSIZE];
	
	tstart = clock();
	
	int i;
	
	for(i = 0; i < 20; i++){
		strcpy(data[i], "0");
	}
	
	FILE *rp;
	rp = fopen("data.txt", "r");
	if(rp == NULL)
		return 0;
	
	for(i = 0; i < 20; i++){
		fscanf(rp, "%s", &data[i]);
	}
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(q1, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[0]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[1]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[2]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[3]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[4]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[5]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[6]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[7]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[8]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[9]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[10]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[11]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[12]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[13]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[14]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, data[15]);
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "255");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(r1, q1);
	memset(q1, '\0', MAXSIZE);
	strcpy(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	
	printf("=========  VMLAV ========\n");
	/*
	char q1_temp[MAXSIZE];
	memset(q1_temp, '\0', MAXSIZE);
	strcpy(q1_temp, q1);
	*/
	
	memset(q2, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	setVec(vec1, q1, "S8");
	strcpy(q2, data[16]);
	translate2Bin(q2, "128", 8, binB, "S8", vec2);
	
	executeVMLAV(vec1, vec2, "S8", 16, 8, Rdes, output);
	printf("------ first output is %s  %s\n", Rdes, output);
	
	memset(q3, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	setVec(vec1, q1, "S8");
	strcpy(q3, data[17]);
	translate2Bin(q3, "128", 8, binB, "S8", vec3);
	
	executeVMLAV(vec1, vec3, "S8", 16, 8, Rdes, output);
	printf("------ second output is %s  %s\n", Rdes, output);
	
	memset(q4, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	setVec(vec1, q1, "S8");
	strcpy(q4, data[18]);
	translate2Bin(q4, "128", 8, binB, "S8", vec4);
	
	executeVMLAV(vec1, vec4, "S8", 16, 8, Rdes, output);
	printf("------ third output is %s  %s\n", Rdes, output);
	
	memset(q5, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	setVec(vec1, q1, "S8");
	strcpy(q5, data[19]);
	translate2Bin(q5, "128", 8, binB, "S8", vec5);
	
	executeVMLAV(vec1, vec5, "S8", 16, 8, Rdes, output);
	printf("------ forth output is %s  %s\n", Rdes, output);
	
	tend = clock();
	
	duration = ((double)(tend - tstart)) / CLOCKS_PER_SEC;
	printf("====== Running time is %lfs ======\n", duration);
	
	fclose(rp);
	
	return 0;
	
}
