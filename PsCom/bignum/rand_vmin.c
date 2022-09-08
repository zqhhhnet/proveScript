#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void main(){
    char integer1[41];
    char integer2[41];
    char result_1[41];
    char result_2[41];
    int d, n, m, dt;
    char label[6][4] = {"S8", "U8", "S16", "U16", "S32", "U32"};
    
    srand((unsigned)time( NULL ));
    printf("start:\n");
    for(int i = 0; i < 40; i++){
        integer1[i] = '0';
        integer2[i] = '0';
        //result_1[i] = '\0';
        //result_2[i] = '\0';
    }
    integer1[40] = '\0';
    integer2[40] = '\0';
    
    for(int i = 0; i < 41; i++){
    	result_1[i] = '\0';
    	result_2[i] = '\0';
    }
    
    // change to 1 command
    //for(int i = 0; i < 30; i++){
    	d = rand() % 8;
    	n = rand() % 8;
    	if(n == d){
    		n++;
    		if(n == 8)
    			n = 0;
    	}
    	
    	m = rand() % 8;
    	if(n == m){
    		m++;
    		if(m == 8)
    			m = 0;
    	}
    	
    	dt = rand() % 6;
    	
    	for(int j = 0; j < 40; j++){
        	integer1[j] = rand() % 10 + 48;
        	integer2[j] = rand() % 10 + 48;
    	}
    	
    	for(int k = 0; integer1[k] == '0' && k < 40; k++){
    		if(integer1[k+1] != '0'){
    			for(int l = k+1; l < 40; l++){
    				result_1[l-k-1] = integer1[l];
    			}
    			break;
    		} else
    			continue;
    	}
    	if(integer1[0] != '0')
    		for(int i = 0; i < 40; i++){
    			result_1[i] = integer1[i];
    		}
    	else if(result_1[0] == '\0')
    		result_1[0] = '0';
    	
    	for(int k = 0; integer2[k] == '0' && k < 40; k++){
    		if(integer2[k+1] != '0'){
    			for(int l = k+1; l < 40; l++){
    				result_2[l-k-1] = integer2[l];
    			}
    			break;
    		} else
    			continue;
    	}
    	if(integer2[0] != '0')
    		for(int i = 0; i < 40; i++){
    			result_2[i] = integer2[i];
    		}
    	else if(result_2[0] == '\0')
    		result_2[0] = '0';
    	
    	printf("    VMOV q%d, #%s\n", n, result_1);
    	printf("    VMOV q%d, #%s\n", m, result_2);
    	printf("    VMIN.%s q%d, q%d, q%d\n", label[dt], d, n, m);
    	
    	memset(integer1, 0, sizeof integer1);
    	memset(integer2, 0, sizeof integer2);
    	memset(result_1, '\0', sizeof result_1);
    	memset(result_2, '\0', sizeof result_2);
    //}
    
    printf("end\n");
    
    
}
