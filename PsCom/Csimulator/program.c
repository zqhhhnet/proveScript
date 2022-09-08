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
	
	for(i = 1; i < strlen(dt); i++){
		ele_len = ele_len*10 + (dt[i] - '0');
	}
	
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
	
	tstart = clock();
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(q1, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, "7101656499985446417749811181341197757318");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
	translate2Bin(r0, "32", 8, binB, "S8", vectemp);
	
	executeVMAXV(vec0, binB, "S8", 16, 8, Rdes, 0, output);
	extract(Rdes, 0, 7, r1);
	concate(q1, r1);
	
	memset(q0, '\0', MAXSIZE);
	memset(r0, '\0', MAXSIZE);
	memset(r1, '\0', MAXSIZE);
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	strcpy(q0, "1447163071352862168344493284646355772084");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "9419896167491740808063989887586577951168");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "6941985641167737716528846811377828489732");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "1033363727627029601985649396351097798283");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "5827932009669502875666190544285247877436");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "4924138603098770130358131084558987319475");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "4337644267499194279942952270566116581885");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "663655083119278761867668831250121166231");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "2600692742856490401830912406952153398413");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "907112666069913837349867571395165964263");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "2694932117843888001747399394048380112313");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "9821821920241091215713474566232361892674");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "4009198122623912839089364287453441355107");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "6247730918379965557388463542923074116009");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	
	strcpy(q0, "157316759269120729406377316743496927952");
	translate2Bin(q0, "128", 8, binA, "S8", vec0);
	
	strcpy(r0, "0");
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
	strcpy(q2, "9110302564881101301142797185345813108425");
	translate2Bin(q2, "128", 8, binB, "S8", vec2);
	
	executeVMLAV(vec1, vec2, "S8", 16, 8, Rdes, output);
	printf("------ first output is %s  %s\n", Rdes, output);
	
	memset(q3, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	setVec(vec1, q1, "S8");
	strcpy(q3, "9322581109971323809051289431880843386465");
	translate2Bin(q3, "128", 8, binB, "S8", vec3);
	
	executeVMLAV(vec1, vec3, "S8", 16, 8, Rdes, output);
	printf("------ second output is %s  %s\n", Rdes, output);
	
	memset(q4, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	setVec(vec1, q1, "S8");
	strcpy(q4, "6459888891961543482907143830613458548582");
	translate2Bin(q4, "128", 8, binB, "S8", vec4);
	
	executeVMLAV(vec1, vec4, "S8", 16, 8, Rdes, output);
	printf("------ third output is %s  %s\n", Rdes, output);
	
	memset(q5, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	
	setVec(vec1, q1, "S8");
	strcpy(q5, "6667587189888747373090849516989613237196");
	translate2Bin(q5, "128", 8, binB, "S8", vec5);
	
	executeVMLAV(vec1, vec5, "S8", 16, 8, Rdes, output);
	printf("------ forth output is %s  %s\n", Rdes, output);
	
	tend = clock();
	
	duration = ((double)(tend - tstart)) / CLOCKS_PER_SEC;
	printf("====== Running time is %lfs ======\n", duration);
	
	return 0;
	
}
