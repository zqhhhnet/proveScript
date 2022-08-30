#include<stdio.h>
#include<string.h>
#include<math.h>

int main(){
	/*
	char command[10], dt[5], strA[1024], strB[1024];
	printf("enter: like(VMAX S8 121212 232323) ");
	scanf("%s %s %s %s", command, dt, strA, strB);
	printf("the command is %s\n", command);
	printf("the datatype is %s\n", dt);
	printf("the string A is %s\n", strA);
	printf("the string B is %s\n", strB);
	long long s = pow(2, 62);
	printf("%lld\n", s);
	*/
	int i;
	char temp[2][150];
	for(i = 0; i < 2; i++)
		strcpy(temp[i], "0");
	
	FILE *rp;
	rp = fopen("data.txt", "r");
	if(rp == NULL)
		return 0;
	for(int i = 0; i < 2; i++){
		fscanf(rp, "%s", &temp[i]);
		printf("%d %s\n", i, temp[i]);
	}
	fclose(rp);
	
	return 0;
}
