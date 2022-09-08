#ifndef _ARM_COMMANDS
#define _ARM_COMMANDS

#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<math.h>

#define MAXSIZE 150

void inverse(char x[], int len){
	int i, j;
	for(i = 0, j = len - 1; i < j; i++, j--){
		char temp = x[i];
		x[i] = x[j];
		x[j] = temp;
	}
}

void zeroExtend(char a[], int size){
	int i, len;
	len = strlen(a);
	if(len >= size)
		return;
	inverse(a, len);
	for(i = len; i < size; i++)
		a[i] = '0';
	a[i] = '\0';
	len = i;
	inverse(a, len);
	return;
}

// sign extend to to_size, pre_size is used to check whether
// a is positive or negative. If positive, extend with '0',
// otherwise extend with '1'.
void signExtend(char a[], int to_size, int pre_size){
	int i, len;
	char tag;
	len = strlen(a);
	if(len >= to_size)
		return;
	if(len == pre_size)
		if(a[0] == '0')
			tag = '0';
		else if(a[0] == '1')
			tag = '1';
	else
		tag = '0';
	inverse(a, len);
	for(i = len; i < to_size; i++)
		a[i] = tag;
	a[i] = '\0';
	len = i;
	inverse(a, len);
	return;
}

int length;

// no signed decimal to binary
void DecToBin(char a[], char res[], int size){
	int i = 0, c, j = 0, r, k = 0, len = strlen(a);
    int decimal[MAXSIZE], bin[MAXSIZE] = { 0 };
    //memset(res, '\0', MAXSIZE);
    for(j = 0; j < len; j++){ // 字符串转数字数组
        decimal[j] = a[j] - '0';
    }
    while(i < len){ // 逐位实现十进制转二进制
        c = 0;
        for(j = i; j < len; j++){
            r = (decimal[j] + c * 10) % 2; // 余数
            decimal[j] = (decimal[j] + c * 10) >> 1; // 商
            c = r; // 进位
        }
        bin[k++] = c; // 保存进位
        while(decimal[i] == 0 && i < len){
            i++;
        }
    }
    for(i = k - 1, j = 0; i >= 0; i--, j++){
        res[j] = bin[i] + '0';
    }
    if(k < size){
    	inverse(res, k);
    	for(i = k; i < size; i++)
    		res[i] = '0';
    	inverse(res, size);
    }
    return;
}

// signed decimal to binary
void signDecToBin(char a[], char res[], int size){
	int i, len_a;
	len_a = strlen(a);
	char temp[MAXSIZE];
	memset(temp, '\0', MAXSIZE);
	memset(res, '\0', MAXSIZE);
	
	if(a[0] == '-'){
		inverse(a, len_a);
		len_a--;
		a[len_a] = '\0';
		inverse(a, len_a);
		DecToBin(a, res, size);
		int c = 0;
		res[0] = '1';
		for(i = size - 1; i > 0; i--){
			if(i == size - 1){
				if(res[i] == '0')
					c = 1;
				else
					c = 0;
			}else{
				if(res[i] == '0'){
					res[i] = (1+c) % 2 + '0';
					c = (1+c) / 2;
				}else{
					res[i] = c + '0';
					c = 0;
				}
			}
		}
	}else{
		DecToBin(a, res, size);
	}
	return;
}

void bin2signInt(char bin[], int size, char res[]){
	int i, len;
	long long temp = 0;
	memset(res, '\0', MAXSIZE);
	
	len = strlen(bin);
	if(len < size){
		for(i = 0; i < len; i++)
			temp += pow(2, len-i-1) * (bin[i] - '0');
		for(i = 0; temp > 0; i++){
			res[i] = (temp % 10) + '0';
			temp /= 10;
		}
		res[i] = '\0';
		inverse(res, i);
	}else if(len == size){
		if(bin[0] == '1'){
			int c = 0;
			for(i = len-1; i > 0; i--){
				if(i == len-1){
					if(bin[i] == '0')
						c = 1;
					else
						c = 0;
				}else{
					if(bin[i] == '0'){
						bin[i] = (1+c) % 2 + '0';
						c = (1+c) / 2;
					}else{
						bin[i] = c + '0';
						c = 0;
					}
				}
			}
			for(i = 1; i < len; i++){
				temp += pow(2, len-i-1) * (bin[i] - '0');
			}
			temp *= (-1);
			if(temp == 0){
				temp = -1 * pow(2, size-1);
			}
			
			//res[0] = '-';
			temp = -1 * temp;
			for(i = 0; temp > 0; i++){
				res[i] = (temp % 10) + '0';
				temp /= 10;
			}
			res[i] = '-';
			res[i+1] = '\0';
			inverse(res, i+1);
			
			return;
		}else{
			for(i = 1; i < len; i++){
				temp += pow(2, len-i-1) * (bin[i] - '0');
			}
			
			for(i = 0; temp > 0; i++){
				res[i] = (temp % 10) + '0';
				temp /= 10;
			}
			res[i] = '\0';
			inverse(res, i);
			return;
		}
	}
}

void extract(char binary[], int start, int end, char res[]);

// binary to signed int
long long signInt(char bin[], int size){
	int i;
	char a[MAXSIZE];
	memset(a, '\0', MAXSIZE);
	strcpy(a, bin);
	long long temp = 0;
	int len = strlen(a);
	if(len < size){
		for(i = 0; i < len; i++){
			temp += pow(2, len-i-1) * (a[i] - '0');
		}
		/*
		for(i = 0; temp > 0; i++){
			res[i] = (temp % 10) + '0';
			temp /= 10;
		}
		res[i] = '\0';
		inverse(res, i);
		*/
		return temp;
	}else if (len == size){
		if(a[0] == '1'){
			int c = 0;
			for(i = len-1; i > 0; i--){
				if(i == len-1){
					if(a[i] == '0')
						c = 1;
					else
						c = 0;
				}else{
					if(a[i] == '0'){
						a[i] = (1+c) % 2 + '0';
						c = (1+c) / 2;
					}else{
						a[i] = c + '0';
						c = 0;
					}
				}
			}
			for(i = 1; i < len; i++){
				temp += pow(2, len-i-1) * (a[i] - '0');
			}
			temp *= (-1);
			if(temp == 0){
				temp = -1 * pow(2, size-1);
			}
			/*
			res[0] = '-';
			temp = -1 * temp;
			for(i = 1; temp != 0; i++){
				res[i] = (temp % 10) + '0';
				temp /= 10;
			}
			res[i] = '\0';
			*/
			return temp;
		}else{
			for(i = 1; i < len; i++){
				temp += pow(2, len-i-1) * (a[i] - '0');
			}
			return temp;
		}
	}else if(len > size){
		char temp2[MAXSIZE];
		memset(temp2, '\0', MAXSIZE);
		extract(a, 0, size-1, temp2);
		memset(a, '\0', MAXSIZE);
		strcpy(a, temp2);
		len = size;
		if(a[0] == '1'){
			int c = 0;
			for(i = len-1; i > 0; i--){
				if(i == len-1){
					if(a[i] == '0')
						c = 1;
					else
						c = 0;
				}else{
					if(a[i] == '0'){
						a[i] = (1+c) % 2 + '0';
						c = (1+c) / 2;
					}else{
						a[i] = c + '0';
						c = 0;
					}
				}
			}
			for(i = 1; i < len; i++){
				temp += pow(2, len-i-1) * (a[i] - '0');
			}
			temp *= (-1);
			if(temp == 0){
				temp = -1 * pow(2, size-1);
			}
			/*
			res[0] = '-';
			temp = -1 * temp;
			for(i = 1; temp != 0; i++){
				res[i] = (temp % 10) + '0';
				temp /= 10;
			}
			res[i] = '\0';
			*/
			return temp;
		}else{
			for(i = 1; i < len; i++){
				temp += pow(2, len-i-1) * (a[i] - '0');
			}
			return temp;
		}
	}
	//printf("des2value %s\n", bin);
}

long long unsignInt(char bin[]){
	int i, len;
	char a[MAXSIZE];
	memset(a, '\0', MAXSIZE);
	strcpy(a, bin);
	long long sum = 0;
	len = strlen(a);
	/*
	inverse(a, len);
	i = len - 1;
	while(a[i] == '0'){
		i--;
	}
	a[i+1] = '\0';
	inverse(a, i+1);
	len = i+1;
	*/
	for(i = 0; i < len; i++){
		sum += pow(2, len-i-1) * (a[i] - '0');
	}
	return sum;
}

void FPabsBin(char a[], int size){
	int len;
	len = strlen(a);
	if(len < size)
		return;
	if(len == size){
		if(a[0] == '1')
			a[0] = '0';
	}
	return;
}

void absBin(char bin[], int size){
	int i, len, temp = 0;
	len = strlen(bin);
	if(len < size)
		return;
	if(len == size){
		if(bin[0] == '0')
			return;
		else if(bin[0] == '1'){
			/*
			i = 1;
			while(i < len){
				if(bin[i] != '0')
					break;
				i++;
			}
			if(i == len)
				return (-1)*(signInt(bin, size));
			*/
			int c = 0;
			bin[0] = '0';
			for(i = len-1; i > 0; i--){	// translate to true value
				if(i == len-1){
					if(bin[i] == '0')
						c = 1;
					else
						c = 0;
				}else{
					if(bin[i] == '0'){
						bin[i] = (1+c) % 2 + '0';
						c = (1+c) / 2;
					}else{
						bin[i] = c + '0';
						c = 0;
					}
				}
			}
			/*
			for(i = 1; i < len; i++){
				temp += pow(2, len-i-1) * (bin[i] - '0');
			}*/
			//temp *= (-1);
			/*if(temp == 0){
				temp = pow(2, size-1);
			}*/
			/*
			res[0] = '-';
			temp = -1 * temp;
			for(i = 1; temp != 0; i++){
				res[i] = (temp % 10) + '0';
				temp /= 10;
			}
			res[i] = '\0';
			*/
			return;
		}
	}
}

void Bigadd(char a[], int len_a, char b[], int len_b){
	int i = 0, c = 0;
	char temp;
	/*
	if(a[0] == '\0'){
		strcpy(a, "0");
		len_a = 1;
	}
	if(b[0] == '\0'){
		strcpy(b, "0");
		len_b = 1;
	}
	*/
	inverse(a, len_a);
	inverse(b, len_b);
	for(i = 0; i < len_a && i < len_b; i++){
		temp = a[i];
		a[i] = (a[i] - '0' + b[i] - '0' + c) % 10 + '0';
		c = ((temp - '0') + (b[i] - '0') + c) / 10;
	}
	if(len_a > len_b){
		for(; i < len_a; i++){
			temp = a[i];
			a[i] = (a[i] - '0' + c) % 10 + '0';
			c = (temp - '0' + c) / 10;
		}
		if(c == 1){
			a[i] = '1';
			a[i+1] = '\0';
			len_a++;
		}else{
			a[i] = '\0';
			len_a = i;
		}
	}else if(len_a < len_b){
		for(; i < len_b; i++){
			a[i] = (b[i] - '0' + c) % 10 + '0';
			c = (b[i] - '0' + c) / 10;
		}
		//len_a = len_b;
		if(c == 1){
			a[i] = '1';
			a[i+1] = '\0';
			len_a = i + 1;
		}else{
			a[i] = '\0';
			len_a = i;
		}
	}else{
		if(c == 1){
			a[i] = '1';
			a[i+1] = '\0';
			len_a = i + 1;
		}else{
			a[i] = '\0';
			len_a = i;
		}
	}
	inverse(a, len_a);
	inverse(b, len_b);
}

int Bigsub(char stringA[],int leghtA,char stringB[],int leghtB)
{
	//printf("length %d\n", length);
	//printf("stringA %s\n", stringA);
    int i,j;
    //如果B的长度小于原始字符串B的长度，则要将其换成原始的
    if(leghtB<length)
        leghtB=length;
    leghtA=strlen(stringA);
    stringB[leghtB]='\0';
    //如果字符串A的长度比B小，就可以直接返回-1了
    if(leghtA<leghtB)
         return -1;
    else
    //这里是判断一下字符串A到底能不能减去字符串B 
        if(leghtA==leghtB)
         {
               for(i=0;i<leghtA;i++)
                    if(stringA[i]<stringB[i])
                       return -1;
                     else
                        if(stringA[i]>stringB[i])
                            break;

         }
         //置换位置，方便做减法
    inverse(stringA,leghtA);
    inverse(stringB,leghtB);
    //这里是减去过程，但未进位。
    for(i=0;i<leghtA && i<leghtB;i++)
    {
        stringA[i]=stringA[i]-stringB[i]+'0';
    }
    //如果A中有高位未能执行，则要将高位的先赋值到A中
    while(i<leghtA){
        stringA[i]=stringA[i];
        i++;
    }
        //这里是进位过程。
    for(i=0;i<leghtA;i++)
        if(stringA[i]<'0'){
        	stringA[i]+=10;
            stringA[i+1]--;
        }
    while(leghtA)
        if(stringA[leghtA-1]!='0')
            break;
        else
            leghtA--;
    stringA[leghtA]='\0';
    //置换回来
    inverse(stringA,leghtA);
    inverse(stringB,leghtB);
    
    //printf("stringA @@ %s\n", stringA);
    return leghtA;
}

void Bigmod(char a[], int len_a, char mod[], int len_mod){
	int i, j, L, flag;
	length = len_mod;
	if(len_a < len_mod)
		return;
	for(i = len_mod; i < len_a; i++)
		mod[i] = '0';
	mod[i] = '\0';
	len_mod = len_a;
	L = len_a;
	for(i = 0; i < L; i++){
		while((flag=Bigsub(a, len_a, mod, len_mod-i))!=-1);
		len_a = strlen(a);
		if(len_a == length){
			for(j = 0; j < len_a; j++)
				if(a[j] < mod[j])
					break;
		}
	}
}

int Bigdiv(char a[], int len_a, char b[], int len_b, char res[]){
	int i, j, L, flag, len_dis;
	char temp[MAXSIZE];
	memset(temp, '\0', MAXSIZE);
	length = len_b;
	if(len_a < len_b)
		return -1;
	len_dis = len_a - len_b;
	temp[len_dis+1] = '\0';
	for(i = 0; i <= len_dis; i++)
		temp[i] = '0';
	for(i = len_b; i < len_a; i++)
		b[i] = '0';
	b[i] = '\0';
	len_b = len_a;
	L = len_a;
	for(i = 0; i < L; i++){
		while((flag = Bigsub(a, len_a, b, len_b-i)) != -1){
			temp[len_dis - i]++;
		}
		len_a = strlen(a);
		if(len_a == length){
			for(j = 0; j < len_a; j++)
				if(a[j] < b[j])
					break;
		}
	}
	while(len_dis)
        if(temp[len_dis]!='0')
            break;
        else
            len_dis--;
    temp[len_dis+1]='\0';
    inverse(temp, len_dis+1);
	strcpy(res, temp);
}

int Judge(char ch[])
{//判断字符串ch是否全为0，若全为1，返回，否则返回0
     int i,k;
     k=strlen(ch);
     for(i=0;i<k;i++){
         if(i == 0 && ch[i] == '-')
         	continue;
         if(ch[i]!='0')
             return 0;
     }
     return 1;
}
void BigNumMulti(char a1[],char b1[], char c[])
{
    int i,j,k,lena,lenb;
    int a[MAXSIZE]= {0},b[MAXSIZE]= {0},d[MAXSIZE]= {0};
    //将字符串转化为整型数组，并逆置
    lena=strlen(a1),lenb=strlen(b1);
    
    //printf("a1 %s  b1 %s\n", a1, b1);
    
    // for negative
    int flagA, flagB;
    if(a1[0] == '-'){
    	flagA = 1;
    	inverse(a1, lena);
    	lena--;
    	a1[lena] = '\0';
    	inverse(a1, lena);
    }else{
    	flagA = 0;
    }
    if(b1[0] == '-'){
    	flagB = 1;
    	inverse(b1, lenb);
    	lenb--;
    	b1[lenb] = '\0';
    	inverse(b1, lenb);
    }else{
    	flagB = 0;
    }
    
    for(i=0; i<lena; i++)
        a[i]=a1[lena-i-1]-'0';
    for(i=0; i<lenb; i++)
        b[i]=b1[lenb-i-1]-'0';
    //计算乘数从低位到高位以此乘以被乘数的低位到高位
    for(i=0; i<lena; i++)
        for(j=0; j<lenb; j++)
        {
            d[i+j]=d[i+j]+a[i]*b[j];
            d[i+j+1]+=d[i+j]/10;
            d[i+j]=d[i+j]%10;
        }
    //根据高位是否为判断整型数组的位数
 
    k=lena+lenb;
    while(!d[k-1])
        k--;
    //积转化为字符型
    if(flagA == flagB){
    	for(i=0; i<k; i++)
    	    c[i]=d[k-1-i]+'0';
    	c[i] = '\0';
    }else if(flagA != flagB){
    	c[0] = '-';
    	for(i=1; i<=k; i++)
    		c[i] = d[k-i] + '0';
    	c[i] = '\0';
    }
    if(Judge(c))//若积全为0，则只输出一个0
        strcpy(c,"0");
}

void BigNumInvol(char a1[],int b1, char c[])
{
    int i;
    char temp[MAXSIZE];
    strcpy(temp,a1);//注意乘方是自己乘自己，而不是结果乘结果
    if(b1==1)  
    	strcpy(c,a1);
    else if(b1==0)  
    	strcpy(c,"1");
    else
    {
        for(i=2; i<b1; i++)
    	{
        	BigNumMulti(a1,temp,c);
        	strcpy(temp,c);
        	memset(c,0,sizeof(c));//将c清空，防止出现错误
    	}
    	//进行最后一次乘法
    	BigNumMulti(a1,temp,c);
    	if(Judge(c))//若结果全为0，则只输出一个0
        	strcpy(c,"0");
    }
}

// extract("10110", 0, 2) = "110"
/*
void extract(char target[], int start, int end, char res[]){
	char temp[MAXSIZE];
	if(start == 0){
		BigNumInvol("2", end+1, temp);
		strcpy(res, target);
		Bigmod(res, strlen(res), temp, strlen(temp));
	}else {
		strcpy(res, target);
		strcpy(temp, target);
		char temp2[MAXSIZE];
		memset(temp2, '\0', MAXSIZE);
		BigNumInvol("2", start, temp2);
		Bigmod(temp, strlen(temp), temp2, strlen(temp2));
		Bigsub(res, strlen(res), temp, strlen(temp));
		char res2[MAXSIZE];
		memset(res2, '\0', MAXSIZE);
		Bigdiv(res, strlen(res), temp2, strlen(temp2), res2);
		BigNumInvol("2", end-start+1, temp2);
		Bigmod(res2, strlen(res2), temp2, strlen(temp2));
		strcpy(res, res2);
	}
	return;
}
*/
void extract(char binary[], int start, int end, char res[]){
	int i, j, len, size;
	len = strlen(binary);
	size = end - start + 1;
	if(len < size){
		strcpy(res, binary);
		return;
	}
	for(i = len-start-1, j = size-1; j >= 0; i--, j--){
		res[j] = binary[i];
	}
	res[size] = '\0';
	printf("res %s\n", res);
	return;
}

void concate(char a[], char b[]){
	strcat(a, b);
}

// binary a translate to unsigned integer, and store in res.
void binToUInt(char a[], int len_a, char res[]){
	int i;
	char temp[MAXSIZE];
	memset(temp, '\0', MAXSIZE);
	memset(res, '\0', MAXSIZE);
	//printf("len_a %d\n", len_a);
	for(i = 0; i < len_a; i++){
		if(a[i] == '1'){
			BigNumInvol("2", len_a-i-1, temp);
			//printf("%d  temp %s res %s\n", i, temp, res);
			Bigadd(res, strlen(res), temp, strlen(temp));
			//printf("res %s\n", res);
		}
		memset(temp, '\0', MAXSIZE);
	}
}

char* maxUInt(char a[], char b[]){
	if(unsignInt(a) < unsignInt(b))
		return b;
	else
		return a;
}

char* maxSInt(char a[], char b[], int size){
	if(signInt(a, size) > signInt(b, size))
		return a;
	else
		return b;
}

void extendFloatToSize(char a[], int size){
	int i, len_a;
	len_a = strlen(a);
	inverse(a, len_a);
	if(len_a < size){
		for(i = len_a; i < size; i++)
			a[i] = '0';
		a[i] = '\0';
		//inverse(a, size);
	}
	inverse(a, size);
}

void getFPMes(char a[], int size, char exp[], char manti[]){
	int i;
	memset(exp, '\0', 12);
	memset(manti, '\0', 53);
	//printf("aaaa %s\n", a);
	if(size == 16){
		for(i = 1; i < 6; i++)
			exp[i-1] = a[i];
		//exp[i-1] = '\0';
		for(i = 6; i < 16; i++)
			manti[i-6] = a[i];
		//manti[i-6] = '\0';
	}else if(size == 32){
		for(i = 1; i < 9; i++)
			exp[i-1] = a[i];
		//exp[i-1] = '\0';
		for(i = 9; i < 32; i++)
			manti[i-9] = a[i];
		//manti[i-9] = '\0';
	}else if(size == 64){
		for(i = 1; i < 12; i++)
			exp[i-1] = a[i];
		//exp[i-1] = '\0';
		for(i = 12; i < 32; i++)
			manti[i-12] = a[i];
		//manti[i-12] = '\0';
	}
	return;
}

char* setDefault(int size){
	if(size == 16)
		return "0111111000000000";
	else if(size == 32)
		return "01111111110000000000000000000000";
	else if(size == 64)
		return "0111111111111000000000000000000000000000000000000000000000000000";
}

// check whether the floating point binary is NaN, 
// and return 1 for QNaN, 2 for SNaN, 0 for Normal binary, -1 is Infinity.
int checkNaN(char a[], int size){
	//printf("aa???? %s\n", a);
	extendFloatToSize(a, size);
	char exp[12], man[53];
	memset(exp, '\0', 12);
	memset(man, '\0', 53);
	getFPMes(a, size, exp, man);
	//printf("exp %s man %s\n", exp, man);
	if(size == 16){
		if(strcmp(exp, "11111") == 0){
			if(man[0] == '1')
				return 1;
			else if(strcmp(man, "0000000000") == 0)
				return -1;
			else if(strcmp(man, "0000000000") != 0 && man[0] == '0')
				return 2;
		}else
			return 0;
	}else if(size == 32){
		if(strcmp(exp, "11111111") == 0){
			if(man[0] == '1')
				return 1;
			else if(strcmp(man, "00000000000000000000000") == 0)
				return -1;
			else if(strcmp(man, "00000000000000000000000") != 0 && man[0] == '0')
				return 2;
		}else
			return 0;
	}else if(size == 64){
		if(strcmp(exp, "11111111111") == 0){
			if(man[0] == '1')
				return 1;
			else if (strcmp(man, "0000000000000000000000000000000000000000000000000000") == 0)
				return -1;
			else if (strcmp(man, "0000000000000000000000000000000000000000000000000000") != 0 && man[0] == '0')
				return 2;
		}else 
			return 0;
	}
}



// obtain the relation of two binary.
int maxBin(char a[], char b[]){
	int len_a, len_b, i;
	len_a = strlen(a);
	len_b = strlen(b);
	if(len_a == len_b){
		for(i = 0; i < len_a; i++){
			if(a[i] > b[i])
				return 1;			// a is bigger one
			else if(a[i] < b[i])
				return -1;			// b is bigger one
		}
		return 0;					// equal
	}
}

// return 0 if a < b, return 1 if a > b
int maxFloat(char a[], char b[], int size){
	int i;
	int len_a = strlen(a);
	int len_b = strlen(b);
	extendFloatToSize(a, size);
	extendFloatToSize(b, size);
	
	char signA, signB, expA[12], expB[12], manA[53], manB[53];
	
	signA = a[0];
	signB = b[0];
	getFPMes(a, size, expA, manA);
	getFPMes(b, size, expB, manB);
	
	//printf("A %c  B %c\n", signA, signB);
	if(signA != signB){
		if(signA == '1')
			return 0;
		else if(signA == '0')
			return 1;
	}else if (signA == signB && signA == '0'){
		printf("22222 \n");
		if(maxBin(expA, expB) == 1)
			return 1;
		else if(maxBin(expA, expB) == -1)
			return 0;
		else{
			printf("33333 \n");
			printf("manA %s manB %s\n", manA, manB);
			if(maxBin(manA, manB) == 1)
				return 1;
			else
				return 0;
		}
	}else if (signA == signB && signA == '1'){
		if(maxBin(expA, expB) == 1)
			return 0;
		else if(maxBin(expA, expB) == -1)
			return 1;
		else{
			if(maxBin(manA, manB) == 1)
				return 0;
			else
				return 1;
		}
	}
}

// for Q register, to set the element.
// ex. vec[0] save the bottom element of register.
/*
int setVec(char vec[][MAXSIZE], char dt[], char a[]){
	int i;
	char temp[MAXSIZE];
	for(i = 0; i < 16; i++)
		strcpy(vec[i], "0");
	int dt_num = 0;
	for(i = 1; i < strlen(dt); i++){
		dt_num = dt_num * 10 + (dt[i] - '0');
	}
	int ele_num = 0;
	ele_num = 128 / dt_num;
	for(i = 0; i < ele_num; i++){
		memset(temp, '\0', MAXSIZE);
		extract(a, i*dt_num, (i+1)*dt_num-1, temp);
		strcpy(vec[i], temp);
		printf("%d %s\n", i, vec[i]);
		memset(temp, '\0', MAXSIZE);
	}
	return ele_num;
}
*/
int setVec(char vec[][MAXSIZE], char bin[], char dt[]){
	int i;
	for(i = 0; i < 16; i++)
		strcpy(vec[i], "0");
	int dt_num = 0;
	printf("bin %s\n", bin);
	for(i = 1; i < strlen(dt); i++)
		dt_num = dt_num * 10 + (dt[i] - '0');
	printf("dt %d\n", dt_num);
	int ele_num = 128 / dt_num;
	for(i = 0; i < ele_num; i++){
		extract(bin, i*dt_num, (i+1)*dt_num-1, vec[i]);
	}
	return ele_num;
}

// for vector compare, if flag = 0, output max,
// if flag = 1, output min
void vecCompareInt(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char datatype[], int ele_num, char vecdes[][MAXSIZE], int flag){
	int i;
	for(i = 0; i < 16; i++){
		strcpy(vecdes[i], "0");
	}
	if(datatype[0] == 'S'){
		for(i = 0; i < ele_num; i++){
			if(flag == 0){	// for max
				if(signInt(vec1[i], 128 / ele_num) > signInt(vec2[i], 128 / ele_num))
					strcpy(vecdes[i], vec1[i]);
				else
					strcpy(vecdes[i], vec2[i]);
			}else{			// for min
				if(signInt(vec1[i], 128 / ele_num) > signInt(vec2[i], 128 / ele_num))
					strcpy(vecdes[i], vec2[i]);
				else
					strcpy(vecdes[i], vec1[i]);
			}		
			printf("inter %s\n", vecdes[i]);
		}
	}else if(datatype[0] == 'U'){
		for(i = 0; i < ele_num; i++){
			if(flag == 0){	// for max
				printf("real?");
				if(unsignInt(vec1[i]) > unsignInt(vec2[i]))
					strcpy(vecdes[i], vec1[i]);
				else
					strcpy(vecdes[i], vec2[i]);
			}else {			// for min
				if(unsignInt(vec1[i]) > unsignInt(vec2[i]))
					strcpy(vecdes[i], vec2[i]);
				else
					strcpy(vecdes[i], vec1[i]);
			}
			printf("inter %s\n", vecdes[i]);
		}
	}
}

// for vmaxa, des use unsignedInt, source use signedInt.
void vecCompareabsInt(char vec1[][MAXSIZE], char vec2[][MAXSIZE], int ele_num, char vecdes[][MAXSIZE], int flag){
	int i;
	for(i = 0; i < 16; i++){
		strcpy(vecdes[i], "0");
	}
	for(i = 0; i < ele_num; i++){
		if(flag == 0){	// for max
			if(unsignInt(vec1[i]) > signInt(vec2[i], 128 / ele_num))
				strcpy(vecdes[i], vec1[i]);
			else
				strcpy(vecdes[i], vec2[i]);
		}else{			// for min
			if(unsignInt(vec1[i]) > signInt(vec2[i], 128 / ele_num))
				strcpy(vecdes[i], vec2[i]);
			else
				strcpy(vecdes[i], vec1[i]);
		}		
		printf("inter %s\n", vecdes[i]);
	}
}

// for the vector and the general register compare each element
void vec2RegCompareInt(char vec1[][MAXSIZE], char bin2[], char datatype[], int ele_num, int ele_len, char des[], int flag){
	int i;
	memset(des, '\0', ele_len);
	strcpy(des, bin2);
	if(datatype[0] == 'S'){
		for(i = 0; i < ele_num; i++){
			if(flag == 0){	// for max
				if(signInt(vec1[i], 128 / ele_num) > signInt(des, ele_len)){
					//memset(des, '\0', ele_len);
					strcpy(des, vec1[i]);
					printf("%d des %s\n", i, des);
				}
			}else{			// for min
				if(signInt(vec1[i], 128 / ele_num) < signInt(des, ele_len)){
					//memset(des, '\0', ele_len);
					strcpy(des, vec1[i]);
				}
			}
			//printf("des %s\n", des);
		}
	}else if(datatype[0] == 'U'){
		for(i = 0; i < ele_num; i++){
			if(flag == 0){	// for max
				if(unsignInt(vec1[i]) > unsignInt(des)){
					//memset(des, '\0', ele_len);
					strcpy(des, vec1[i]);
				}
			}else{			// for min
				if(unsignInt(vec1[i]) < unsignInt(des)){
					//memset(des, '\0', ele_len);
					strcpy(des, vec1[i]);
				}
			}
			//printf("des %s\n", des);
		}
	}
	printf("final des %s\n", des);
}

void vec2RegCompareabsInt(char vec1[][MAXSIZE], char bin2[], int ele_num, char des[], int flag){
	int i;
	memset(des, '\0', MAXSIZE);
	strcpy(des, bin2);
	for(i = 0; i < ele_num; i++){
		if(flag == 0){	// for max
			if(signInt(vec1[i], 128 / ele_num) > unsignInt(des)){
				//memset(des, '\0', ele_len);
				strcpy(des, vec1[i]);
				printf("%d des %s\n", i, des);
			}
		}else{			// for min
			if(signInt(vec1[i], 128 / ele_num) < unsignInt(des)){
				//memset(des, '\0', ele_len);
				strcpy(des, vec1[i]);
			}
		}
	}
}

// FP vector compare
void vecCompareFP(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char datatype[], int ele_num, int ele_len, char vecdes[][MAXSIZE], int flag){
	int i, t1, t2;
	for(i = 0; i < 16; i++){
		strcpy(vecdes[i], "0");
	}
	for(i = 0; i < ele_num; i++){
		printf("vec1 %s\n", vec1[i]);
		t1 = checkNaN(vec1[i], ele_len);
		printf("vec2 %s\n", vec2[i]);
		t2 = checkNaN(vec2[i], ele_len);
		if(flag == 0){
			if(t1 == 1 && t2 == 1){
				strcpy(vecdes[i], setDefault(ele_len));
			}else if(t1 == 2 || t2 == 2){
				strcpy(vecdes[i], setDefault(ele_len));
			}else if(t1 == 1 && t2 == 0){
				strcpy(vecdes[i], vec2[i]);
			}else if(t1 == 0 && t2 == 1){
				strcpy(vecdes[i], vec1[i]);
			}else if(t1 == -1 && vec1[i][0] == '1'){
				strcpy(vecdes[i], vec2[i]);
			}else if(t2 == -1 && vec2[i][0] == '1'){
				strcpy(vecdes[i], vec1[i]);
			}else{
				printf("normal\n");
				if(maxFloat(vec1[i], vec2[i], ele_len) == 1){
					strcpy(vecdes[i], vec1[i]);
				}else{
					strcpy(vecdes[i], vec2[i]);
				}
			}
			printf("inter 0 %s\n", vecdes[i]);
		}else{
			if(t1 == 1 && t2 == 1){
				strcpy(vecdes[i], setDefault(ele_len));
			}else if(t1 == 2 || t2 == 2){
				strcpy(vecdes[i], setDefault(ele_len));
			}else if(t1 == 1 && t2 == 0){
				strcpy(vecdes[i], vec2[i]);
			}else if(t1 == 0 && t2 == 1){
				strcpy(vecdes[i], vec1[i]);
			}else if(t1 == -1 && vec1[i][0] == '0'){
				strcpy(vecdes[i], vec2[i]);
			}else if(t2 == -1 && vec2[i][0] == '0'){
				strcpy(vecdes[i], vec1[i]);
			}else{
				if(maxFloat(vec1[i], vec2[i], ele_len) == 1)
					strcpy(vecdes[i], vec2[i]);
				else
					strcpy(vecdes[i], vec1[i]);
			}
			printf("inter 1 %s\n", vecdes[i]);
		}
	}
}

void FPRegCompare(char bin1[], char bin2[], char datatype[], int ele_len, char des[], int flag){
	int t1, t2;
	memset(des, '\0', MAXSIZE);
	t1 = checkNaN(bin1, ele_len);
	t2 = checkNaN(bin2, ele_len);
	if(flag == 0){
		if(t1 == 1 && t2 == 1){
			strcpy(des, setDefault(ele_len));
		}else if(t1 == 2 || t2 == 2){
			strcpy(des, setDefault(ele_len));
		}else if(t1 == 1 && t2 == 0){
			strcpy(des, bin2);
		}else if(t1 == 0 && t2 == 1){
			strcpy(des, bin1);
		}else if(t1 == -1 && bin1[0] == '1'){
			strcpy(des, bin2);
		}else if(t2 == -1 && bin2[0] == '1'){
			strcpy(des, bin1);
		}else{
			printf("normal\n");
			if(maxFloat(bin1, bin2, ele_len) == 1){
				strcpy(des, bin1);
			}else{
				strcpy(des, bin2);
			}
		}
	}else if(flag == 1){
		if(t1 == 1 && t2 == 1){
			strcpy(des, setDefault(ele_len));
		}else if(t1 == 2 || t2 == 2){
			strcpy(des, setDefault(ele_len));
		}else if(t1 == 1 && t2 == 0){
			strcpy(des, bin2);
		}else if(t1 == 0 && t2 == 1){
			strcpy(des, bin1);
		}else if(t1 == -1 && bin1[0] == '0'){
			strcpy(des, bin2);
		}else if(t2 == -1 && bin2[0] == '0'){
			strcpy(des, bin1);
		}else{
			printf("normal\n");
			if(maxFloat(bin1, bin2, ele_len) == 1){
				strcpy(des, bin2);
			}else{
				strcpy(des, bin1);
			}
		}
	}
}

void FP2RegCompare(char vec1[][MAXSIZE], char bin2[], int ele_num, int ele_len, char des[], int flag){
	int i, t1, t2;
	memset(des, '\0', MAXSIZE);
	strcpy(des, bin2);
	
	for(i = 0; i < ele_num; i++){
		t1 = checkNaN(vec1[i], ele_len);
		t2 = checkNaN(des, ele_len);
		
		if(flag == 0){
			if(t1 == 1 && t2 == 1){
				strcpy(des, setDefault(ele_len));
			}else if((t1 == 1 && t2 == 2) || (t1 == 2 && t2 == 1)){
				strcpy(des, setDefault(ele_len));
			}else if(t1 == 2 && t2 == 2){
				strcpy(des, setDefault(ele_len));
			}else if(t1 == 1 && t2 == 0){
				continue;
			}else if(t1 == 0 && t2 == 1){
				strcpy(des, vec1[i]);
			}else if(t1 == 2 && t2 == 0){
				continue;
			}else if(t1 == 0 && t2 == 2){
				strcpy(des, vec1[i]);
			}else if(t1 == -1 && vec1[i][0] == '1'){
				continue;
			}else if(t2 == -1 && des[0] == '1'){
				strcpy(des, vec1[i]);
			}else{
				if(maxFloat(vec1[i], des, ele_len) == 1){
					strcpy(des, vec1[i]);
				}
			}
		}else if(flag == 1){
			if(t1 == 1 && t2 == 1){
				strcpy(des, setDefault(ele_len));
			}else if((t1 == 1 && t2 == 2) || (t1 == 2 && t2 == 1)){
				strcpy(des, setDefault(ele_len));
			}else if(t1 == 2 && t2 == 2){
				strcpy(des, setDefault(ele_len));
			}else if(t1 == 1 && t2 == 0){
				continue;
			}else if(t1 == 0 && t2 == 1){
				strcpy(des, vec1[i]);
			}else if(t1 == 2 && t2 == 0){
				continue;
			}else if(t1 == 0 && t2 == 2){
				strcpy(des, vec1[i]);
			}else if(t1 == -1 && vec1[i][0] == '0'){
				continue;
			}else if(t2 == -1 && des[0] == '0'){
				strcpy(des, vec1[i]);
			}else{
				if(maxFloat(vec1[i], des, ele_len) == 0){
					strcpy(des, vec1[i]);
				}
			}
		}
	}
}

// for the add of signed decimal
void InnerAdd(char des[], char b[], char sum[]){
	int len_a, len_b, flagA=0, flagB=0;
	char a[MAXSIZE];
	memset(a, '\0', MAXSIZE);
	strcpy(a, des);
	memset(sum, '\0', MAXSIZE);
	len_a = strlen(a);
	len_b = strlen(b);
	printf("a %s  b %s\n", a, b);
	if(a[0] == '-'){
		flagA = 1;
		inverse(a, len_a);
		len_a--;
		a[len_a] = '\0';
		inverse(a, len_a);
	}
	if(b[0] == '-'){
		flagB = 1;
		inverse(b, len_b);
		len_b--;
		b[len_b] = '\0';
		inverse(b, len_b);
	}
	//printf("@@@ a %s b %s\n", a, b);
	if(flagA == 1 && flagB == 1){
		//printf("len_aaaaaa %d   len_bbbbbb  %d \n", len_a, len_b);
		Bigadd(a, len_a, b, len_b);
		//printf("aaaa %s\n", a);
		len_a = strlen(a);
		inverse(a, len_a);
		a[len_a] = '-';
		len_a++;
		a[len_a] = '\0';
		inverse(a, len_a);
		strcpy(sum, a);
	}else if(flagA == 1 && flagB == 0){
		int flag;
		length = len_a;
		flag = Bigsub(b, len_b, a, len_a);
		if(flag != -1){
			strcpy(sum, b);
		}else{
			length = len_b;
			flag = Bigsub(a, len_a, b, len_b);
			//printf("flag %d\n", flag);
			len_a = strlen(a);
			inverse(a, len_a);
			a[len_a] = '-';
			len_a++;
			a[len_a] = '\0';
			inverse(a, len_a);
			strcpy(sum, a);
		}
	}else if(flagA == 0 && flagB == 1){
		int flag;
		length = len_b;
		flag = Bigsub(a, len_a, b, len_b);
		if(flag != -1){
			strcpy(sum, a);
		}else{
			length = len_a;
			flag = Bigsub(b, len_b, a, len_a);
			//printf("flag %d\n", flag);
			len_b = strlen(b);
			inverse(b, len_b);
			b[len_b] = '-';
			len_b++;
			b[len_b] = '\0';
			inverse(b, len_b);
			strcpy(sum, b);
		}
	}else if(flagA == 0 && flagB == 0){
		Bigadd(a, len_a, b, len_b);
		strcpy(sum, a);
	}
	return;
}

void vecInnerProduct(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char datatype[], int ele_num, int ele_len, char des[]){
	int i, len_prod;
	char temp1[MAXSIZE], temp2[MAXSIZE], prod[MAXSIZE], sum[MAXSIZE];
	memset(des, '\0', MAXSIZE);
	memset(sum, '\0', MAXSIZE);
	
	if(datatype[0] == 'S'){
		for(i = 0; i < ele_num; i++){
			memset(temp1, '\0', MAXSIZE);
			memset(temp2, '\0', MAXSIZE);
			memset(prod, '\0', MAXSIZE);
			//printf("vec1[i]  %s\n", vec1[i]);
			bin2signInt(vec1[i], ele_len, temp1);
			//printf("temp1  %s\n", temp1);
			//printf("vec2[i]  %s\n", vec2[i]);
			bin2signInt(vec2[i], ele_len, temp2);
			//printf("temp2  %s\n", temp2);
			BigNumMulti(temp1, temp2, prod);
			printf("prod %s\n", prod);
			printf("des  %s\n", des);
			InnerAdd(des, prod, sum);
			//printf("des @@ %s\n", sum);
			strcpy(des, sum);
			memset(sum, '\0', MAXSIZE);
		}
	}else if(datatype[0] == 'U'){
		for(i = 0; i < ele_num; i++){
			memset(temp1, '\0', MAXSIZE);
			memset(temp2, '\0', MAXSIZE);
			memset(prod, '\0', MAXSIZE);
			binToUInt(vec1[i], ele_len, temp1);
			binToUInt(vec2[i], ele_len, temp2);
			BigNumMulti(temp1, temp2, prod);
			Bigadd(des, strlen(des), prod, strlen(prod));
		}
	}
	printf("des %s\n", des);
}

// for vector result, translate the vector element into bigint with concatenate.
void getResult(char vecdec[][MAXSIZE], int ele_num, char result[]){
	int i;
	char temp[MAXSIZE] = "0";
	temp[1] = '\0';
	memset(result, '\0', sizeof(result));
	for(i = ele_num - 1; i >= 0; i--){
		//memset(temp, '\0', MAXSIZE);
		//DecToBin(vecdec[i], temp, 128 / ele_num);
		printf("%s\n", vecdec[i]);
		concate(result, vecdec[i]);
		//memset(temp, '\0', MAXSIZE);
	}
	result[128] = '\0';
	//printf("result @@@ %s\n", result);
	inverse(result, 128);
	int len = 128;
	while(result[len-1] == '0')
		len--;
	result[len] = '\0';
	inverse(result, len);
	//printf("result 222 %s\n", result);
	binToUInt(result, strlen(result), temp);
	memset(result, '\0', sizeof(result));
	strcpy(result, temp);
	return;
}

void executeVMAX(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char datatype[], int ele_num, char vecdes[][MAXSIZE], int flag, char res[]){
	vecCompareInt(vec1, vec2, datatype, ele_num, vecdes, flag);
	getResult(vecdes, ele_num, res);
	printf("output is %s\n", res);
	return;
}

// vec1 is the destination vector, vec2 is the source vector
// so only vec2 need to abs.
void executeVMAXA(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char datatype[], int ele_num, int ele_len, char vecdes[][MAXSIZE], int flag, char res[]){
	int i;
	for(i = 0; i < ele_num; i++){
		absBin(vec2[i], ele_len);
	}
	vecCompareabsInt(vec1, vec2, ele_num, vecdes, flag);
	getResult(vecdes, ele_num, res);
	printf("output is %s\n", res);
	return;
}

// vec1 is source, bin2 is des.
void executeVMAXV(char vec1[][MAXSIZE], char bin2[], char datatype[], int ele_num, int ele_len, char des[], int flag, char res[]){
	vec2RegCompareInt(vec1, bin2, datatype, ele_num, ele_len, des, flag);
	signExtend(des, 32, ele_len);
	binToUInt(des, strlen(des), res);
	if(res[0] == '\0'){
		res[0] = '0';
		res[1] = '\0';
	}
	printf("output is %s\n", res);
	return;
}

// vec1 is the source vector, bin2 is the destination general register.
// vec1 need to abs, bin2 only unsignedInt.
void executeVMAXAV(char vec1[][MAXSIZE], char bin2[], char datatype[], int ele_num, int ele_len, char des[], int flag, char res[]){
	int i;
	for(i = 0; i < ele_num; i++){
		absBin(vec1[i], ele_len);
	}
	vec2RegCompareabsInt(vec1, bin2, ele_num, des, flag);
	signExtend(des, 32, ele_len);
	printf("des !!!! %s\n", des);
	binToUInt(des, strlen(des), res);
	if(res[0] == '\0'){
		res[0] = '0';
		res[1] = '\0';
	}
	printf("output is %s\n", res);
	return;
}

void executeVMAXNM_Q(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char datatype[], int ele_num, int ele_len, char vecdes[][MAXSIZE], int flag, char res[]){
	vecCompareFP(vec1, vec2, datatype, ele_num, ele_len, vecdes, flag);
	getResult(vecdes, ele_num, res);
	printf("output is %s\n", res);
	return;
}

void executeVMAXNM_SorD(char bin1[], char bin2[], char datatype[], int ele_len, char des[], int flag, char res[]){
	FPRegCompare(bin1, bin2, datatype, ele_len, des, flag);
	binToUInt(des, strlen(des), res);
	//if(ele_len == 16)
		//zeroExtend(res, 32);
	printf("output is %s\n", res);
	return;
}

// vec1 is the des, vec2 is the source, both
// of them need to abs.
void executeVMAXNMA(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char datatype[], int ele_num, int ele_len, char vecdes[][MAXSIZE], int flag, char res[]){
	int i;
	for(i = 0; i < ele_num; i++){
		FPabsBin(vec1[i], ele_len);
		FPabsBin(vec2[i], ele_len);
	}
	vecCompareFP(vec1, vec2, datatype, ele_num, ele_len, vecdes, flag);
	getResult(vecdes, ele_num, res);
	printf("output is %s\n", res);
	return;
}

void executeVMAXNMV(char vec1[][MAXSIZE], char binB[], int ele_num, int ele_len, char des[], int flag, char res[]){
	FP2RegCompare(vec1, binB, ele_num, ele_len, des, flag);
	binToUInt(des, strlen(des), res);
	printf("output is %s\n", res);
	return;
}

// vec1 is the source vector, bin2 is the des.
// only vec1 need to abs.
void executeVMAXNMAV(char vec1[][MAXSIZE], char bin2[], int ele_num, int ele_len, char des[], int flag, char res[]){
	int i;
	for(i = 0; i < ele_num; i++){
		FPabsBin(vec1[i], ele_len);
	}
	FP2RegCompare(vec1, bin2, ele_num, ele_len, des, flag);
	binToUInt(des, strlen(des), res);
	printf("output is %s\n", res);
	return;
}

void executeVMLAV(char vec1[][MAXSIZE], char vec2[][MAXSIZE], char dt[], int ele_numA, int ele_len, char des[], char res[]){
	char temp1[MAXSIZE], temp2[MAXSIZE];
	memset(temp1, '\0', MAXSIZE);
	memset(temp2, '\0', MAXSIZE);
	vecInnerProduct(vec1, vec2, dt, ele_numA, ele_len, des);
	signDecToBin(des, temp1, 64);
	extract(temp1, 0, 31, temp2);
	memset(des, '\0', MAXSIZE);
	strcpy(des, temp2);
	binToUInt(temp2, strlen(temp2), res);
	printf("output is %s\n", res);
}


#endif
