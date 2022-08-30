#include "arm_commands.h"

#define MAXSIZE 150

char strA[MAXSIZE], strB[MAXSIZE], command[15], dt[5], sizeA[4], sizeB[4], Rdes[MAXSIZE];
char vecA[16][MAXSIZE], vecB[16][MAXSIZE], vecRes[16][MAXSIZE];
char output[MAXSIZE];

int main(){
	int i, j;
	char regA[3], regB[3];
	/*
	printf("enter the command: ");
	scanf("%s", command);
	printf("enter the datatype: ");
	scanf("%s", dt);
	printf("enter first type of register: ");
	scanf("%s", regA);
	printf("enter first num: ");
	scanf("%s", strA);
	printf("enter first size: ");
	scanf("%s", sizeA);
	printf("enter second type of register: ");
	scanf("%s", regB);
	printf("enter second num: ");
	scanf("%s", strB);
	printf("enter second size: ");
	scanf("%s", sizeB);
	*/
	
	memset(command, '\0', 15);
	memset(dt, '\0', 5);
	memset(regA, '\0', 3);
	memset(regB, '\0', 3);
	memset(strA, '\0', MAXSIZE);
	memset(strB, '\0', MAXSIZE);
	
	printf("enter the command command, datatype, source register type, source register type, like (VMAX S16 Q Q):");
	scanf("%s %s %s %s", command, dt, regA, regB);
	printf("first source register value (number):");
	scanf("%s", strA);
	printf("second source register value (number):");
	scanf("%s", strB);
	
	int len_a = strlen(strA);
	int len_b = strlen(strB);
	
	// for mod
	char mod_128[MAXSIZE] = "340282366920938463463374607431768211456";
	mod_128[39] = '\0';
	int len_mod128 = strlen(mod_128);
	char mod_64[MAXSIZE] = "18446744073709551616";
	mod_64[20] = '\0';
	int len_mod64 = strlen(mod_64);
	char mod_32[MAXSIZE] = "4294967296";
	mod_32[10] = '\0';
	int len_mod32 = strlen(mod_32);
	if(strcmp(regA, "Q") == 0){
		length = 39;
		if(len_a >= 39){
			Bigmod(strA, len_a, mod_128, len_mod128);
		}
	} else if(strcmp(regA, "R") == 0 || (strcmp(regA, "S") == 0)){
		length = 10;
		if(len_a >= 10){
			Bigmod(strA, len_a, mod_32, len_mod32);
		}
	} else if(strcmp(regA, "D") == 0){
		length = 20;
		if(len_a >= 20){
			Bigmod(strA, len_a, mod_64, len_mod64);
		}
	}
	
	if(strcmp(regB, "Q") == 0){
		length = 39;
		if(len_b >= 39){
			Bigmod(strB, len_b, mod_128, len_mod128);
		}
	} else if(strcmp(regB, "R") == 0 || strcmp(regB, "S") == 0){
		length = 10;
		if(len_b >= 10){
			Bigmod(strB, len_b, mod_32, len_mod32);
		}
	} else if(strcmp(regB, "D") == 0){
		length = 20;
		if(len_b >= 20){
			Bigmod(strB, len_b, mod_64, len_mod64);
		}
	}
	
	// translate the decimal big num to binary
	char binA[MAXSIZE], binB[MAXSIZE];
	memset(binA, '\0', MAXSIZE);
	memset(binB, '\0', MAXSIZE);
	//DecToBin(strA, binA, 128);
	//DecToBin(strB, binB, 128);
	
	// for extract some bits
	int ele_numA, ele_numB, ele_len = 0;
	char temp[MAXSIZE];
	memset(temp, '\0', MAXSIZE);
	
	for(i = 1; i < strlen(dt); i++){
		ele_len = ele_len*10 + (dt[i] - '0');
	}
	
	if(strcmp(regA, "Q") == 0){
		printf("strA %s\n", strA);
		DecToBin(strA, binA, 128);
		printf("binA %s\n", binA);
		ele_numA = setVec(vecA, binA, dt);
	}else if(strcmp(regA, "R") == 0 || strcmp(regA, "S") == 0){
		DecToBin(strA, binA, 32);
		extract(binA, 0, ele_len-1, temp);
		strcpy(binA, temp);
		memset(temp, '\0', MAXSIZE);
	}else if(strcmp(regA, "D") == 0){
		DecToBin(strA, binA, 64);
	}
	if(strcmp(regB, "Q") == 0){
		printf("strB %s\n", strB);
		DecToBin(strB, binB, 128);
		printf("binB %s\n", binB);
		ele_numB = setVec(vecB, binB, dt);
	}else if(strcmp(regB, "R") == 0 || strcmp(regB, "S") == 0){
		DecToBin(strB, binB, 32);
		printf("binB %s\n", binB);
		extract(binB, 0, ele_len-1, temp);
		strcpy(binB, temp);
		memset(temp, '\0', MAXSIZE);
	}else if(strcmp(regB, "D") == 0){
		DecToBin(strB, binB, 64);
	}
	printf("ele %d\n", ele_numA);
	
	// match command
	if(strcmp(command, "VMAX") == 0){							//1
		executeVMAX(vecA, vecB, dt, ele_numA, vecRes, 0, output);
	}else if(strcmp(command, "VMAXV") == 0){					//1
		executeVMAXV(vecA, binB, dt, ele_numA, ele_len, Rdes, 0, output);
	}else if(strcmp(command, "VMAXNM") == 0){					//1
		if(strcmp(regA, "Q") == 0)
			executeVMAXNM_Q(vecA, vecB, dt, ele_numA, ele_len, vecRes, 0, output);
		else if(strcmp(regA, "S") == 0 || strcmp(regA, "D") == 0)
			executeVMAXNM_SorD(binA, binB, dt, ele_len, Rdes, 0, output);
	}else if(strcmp(command, "VMAXNMV") == 0){					//1
		executeVMAXNMV(vecA, binB, ele_numA, ele_len, Rdes, 0, output);
	}else if(strcmp(command, "VMLAV") == 0){					//1
		executeVMLAV(vecA, vecB, dt, ele_numA, ele_len, Rdes, output);
	}else if(strcmp(command, "VMAXA") == 0){					//1
		executeVMAXA(vecA, vecB, dt, ele_numA, ele_len, vecRes, 0, output);
	}else if(strcmp(command, "VMAXAV") == 0){					//1
		executeVMAXAV(vecA, binB, dt, ele_numA, ele_len, Rdes, 0, output);
	}else if(strcmp(command, "VMAXNMA") == 0){					//1
		executeVMAXNMA(vecA, vecB, dt, ele_numA, ele_len, vecRes, 0, output);
	}else if(strcmp(command, "VMAXNMAV") == 0){					//1
		executeVMAXNMAV(vecA, binB, ele_numA, ele_len, Rdes, 0, output);
	}else if(strcmp(command, "VMIN") == 0){						//1
		executeVMAX(vecA, vecB, dt, ele_numA, vecRes, 1, output);
	}else if(strcmp(command, "VMINV") == 0){					//1
		executeVMAXV(vecA, binB, dt, ele_numA, ele_len, Rdes, 1, output);
	}else if(strcmp(command, "VMINNM") == 0){					//1
		if(strcmp(regA, "Q") == 0)
			executeVMAXNM_Q(vecA, vecB, dt, ele_numA, ele_len, vecRes, 1, output);
		else if(strcmp(regA, "S") == 0 || strcmp(regA, "D") == 0)
			executeVMAXNM_SorD(binA, binB, dt, ele_len, Rdes, 1, output);
	}else if(strcmp(command, "VMINNMV") == 0){					//1
		executeVMAXNMV(vecA, binB, ele_numA, ele_len, Rdes, 1, output);
	}else if(strcmp(command, "VMINA") == 0){					//1
		executeVMAXA(vecA, vecB, dt, ele_numA, ele_len, vecRes, 1, output);
	}else if(strcmp(command, "VMINAV") == 0){					//1
		executeVMAXAV(vecA, binB, dt, ele_numA, ele_len, Rdes, 1, output);
	}else if(strcmp(command, "VMINNMA") == 0){					//1
		executeVMAXNMA(vecA, vecB, dt, ele_numA, ele_len, vecRes, 1, output);
	}else if(strcmp(command, "VMINNMAV") == 0){					//1
		executeVMAXNMAV(vecA, binB, ele_numA, ele_len, Rdes, 1, output);
	}else
		printf("error command!\n");

	// for translate to unsigned or signed int
	//int flag = 0;
	
	//vecCompareInt(vecA, vecB, dt, ele_numA, vecRes, flag);
	
	// translate the element to binary, and concatenate
	// output result
	//printf("%d\n", ele_numA);
	//getResult(vecRes, ele_numA, output);
	
	//printf("output is %s\n", output);
	
	return 0;
}
