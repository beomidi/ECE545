//
//  main.c
//  Debraize_Fixed
//
//  Created by Behnam Omidi on 10/26/21.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#define n 4
#define k 8

#define print_table_gen 0

/*generate Ah, Al, Rh, Rl*/
void UpdateUperLowerBound(uint64_t A, uint64_t R, uint64_t *Ah, uint64_t *Al, uint64_t *Rh, uint64_t *Rl){
    *Rl = (R % ((uint64_t) pow(2,k)));
    *Rh = (uint64_t) (R >> k);
    *Al = (A % ((uint64_t) pow(2,k)));
    *Ah = (uint64_t) (A >> k);
    
}


/*generate T table*/
void TableGenerator(uint64_t T[n][2][(uint64_t) pow(2,k)], uint64_t p, uint64_t r[n])
{
    for(uint64_t i = 0; i < n; i++){
        r[i] =  i;//(uint64_t) rand() % ((uint64_t) pow(2,k));
        for(uint64_t A = 0 ; A < pow(2,k); A++){
            T[i][p][A] = (A + r[i]) ^ ((p << k) | r[i]);
            T[i][p ^ 1][A] = (A + r[i] + 1) ^ ((p << k)| r[i]);
        }
    }
}


uint64_t DebraizeFixedConversion(uint64_t A, uint64_t R, uint64_t T[n][2][(uint64_t) pow(2,k)], uint64_t p, uint64_t r[n]){
    uint64_t A_Temp = A, R_Temp = R;
    uint64_t B = 0;
    uint64_t Bi[n], beta = p;
    uint64_t Rl, Rh, Al, Ah;
    uint64_t ri = 0;
    
    UpdateUperLowerBound(A_Temp, R_Temp, &Ah, &Al, &Rh, &Rl);
    
    /*generate Rn||....||R1||r0*/
    for(int i = n; i > 0; i--){
        ri = (ri << k) | r[i-1];
    }
    
    A_Temp = (A_Temp  - ri) % (uint64_t) pow(2,n*k);
    UpdateUperLowerBound(A_Temp, R_Temp, &Ah, &Al, &Rh, &Rl);
    
    for(uint64_t i = 0; i < n; i++){
        A_Temp = (A_Temp + Rl) % (uint64_t) pow(2,(n-i)*k);
        UpdateUperLowerBound(A_Temp, R_Temp, &Ah, &Al, &Rh, &Rl);
        
        Bi[i] = T[i][beta][Al] % (uint64_t) pow(2 , k);
        beta = ((T[i][beta][Al] >> k) != 0) ? 1 : 0;
       // printf("%llx\n", T[i][beta][Al] );
        Bi[i] = Bi[i] ^ Rl;
        A_Temp = Ah;
        R_Temp = Rh;
        UpdateUperLowerBound(A_Temp, R_Temp, &Ah, &Al, &Rh, &Rl);
    }
  
    /*generate Bn||....||B1||B0*/
    for(int i = n; i > 0; i--)
        B = (B << k) | Bi[i - 1];
    
    B = B ^ ri;
    return B;
}





int main(int argc, const char * argv[]) {
    
    uint64_t T[n][2][(uint64_t) pow(2,k)];//power_2_k
    uint64_t r[n];
    uint64_t p = 1;
    
    uint64_t A = 0xab25ef2e;
    uint64_t B = 0;
    uint64_t R = 0x29abec20;
    
    if(n*k > 64){
        perror("ERROR: please select appropriate n and k vlues to satisfy the condition n*k < 65");
        return 0;
    }
    TableGenerator(T, p, r);
    
    /*print table contents*/
    if(print_table_gen){
        for(int i = 0; i < n; i++)
            for(int j = 0; j < 2; j++)
                for(int l = 0; l < (uint64_t) pow(2,k); l++)
                    printf("T[%d][%d][%d] = %llx\n", i, j , l, T[i][j][l]);
    }
                
                
                
    B = DebraizeFixedConversion(A, R, T, p, r);
    printf("B       = %3llx\n", B);
    printf("A + R   = %3llx\n", A+R);
    printf("B ^ R   = %3llx\n", B^R);
    return 0;
}










