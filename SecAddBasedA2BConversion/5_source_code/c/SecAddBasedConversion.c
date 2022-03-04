//
//  main.c
//  SecAddBasedConversion
//
//  Created by Behnam Omidi on 10/29/21.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <time.h>

#define n 2
#define k 8

#define getBit(val, index) ((val >> index) & 1)



/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure and*/

void SecAnd(uint64_t z[n], uint64_t x[n], uint64_t y[n]){
    uint64_t r[n][n];
    //srand (time(0));
    for(uint64_t i = 0; i < n; i++)
        for(uint64_t j = i+1; j < n; j++){
            r[i][j] = (i+j) % (uint64_t) pow(2,k); //rand() % (uint64_t) pow(2,k);
            r[j][i] = r[i][j] ^ (x[i] & y[j]) ^ (x[j] & y[i]);
        }
    
    for(uint64_t i = 0; i < n; i++){
        z[i] = x[i] & y [i];
        for(uint64_t j = 0; j < n; j++)
            if(i != j)
                z[i] = z[i] ^ r[i][j];
    }
}

/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure add*/

void SecAdd(uint64_t z[n], uint64_t x[n], uint64_t y[n]){
    uint64_t c[n], xy[n], xc[n], yc[n];
    
    /*c <- 0*/
    for(uint64_t i = 0; i < n; i++ )
        c[i] = 0;
    
    //getBit
    /*get bit of j-th of x , y, c*/
    for(uint64_t j = 0; j < k - 1; j++){
        
        SecAnd(xy, x, y);
        SecAnd(xc, x, c);
        SecAnd(yc, y, c);
        
        /*generate carry of j-th bit*/
        for(uint64_t i = 0; i < n; i++ )
            c[i] = c[i] | (getBit(((xy[i] ^ xc[i] ^ yc[i])), j) << (j + 1));
    }
    
    /*secure sum*/
    for(uint64_t i = 0; i < n; i++)
        z[i] = x[i] ^ y[i] ^ c[i];
    
}


/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure add Goubin*/

void SecAddGoubin(uint64_t z[n],  uint64_t x[n], uint64_t y[n]){
    uint64_t w[n], u[n],a[n], ua[n], *temp;
    
    SecAnd(w, x, y); // w <- x and b
    
    for(uint64_t i = 0; i < n; i++){
        u[i] = 0; //initialize shares of u to zero
        a[i] = x[i] ^ y [i];// a <- x xor y
    }
    
    
    for(uint64_t j = 0; j < k - 1; j++){
        SecAnd(ua, u, a);
        for(uint64_t i = 0; i < n; i++){
            u[i] = ua[i] ^ w[i];
            u[i] = (u[i] << 1) % (uint64_t) pow(2, k); // u <- 2(u and a xor w)
        }
    }
    
    

    for(uint64_t i = 0; i < n; i++)
        z[i] = x[i] ^ y[i] ^ u[i]; // z = x + y = x xor y xor y
}

/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure Mux*/

void SecMux(uint64_t z[n],  uint64_t s[n], uint64_t s_bar[n], uint64_t carry){
    uint64_t c_bar[n];
    uint64_t c[n];
    uint64_t z_c[n];
    uint64_t z_c_bar[n];
    
    for(uint64_t i = 0; i < n; i++){
        c[i] = 0;
        c_bar[i] = 0;
    }
    c[n-1] = (carry!= 0) ? (uint64_t) pow(2,k) - 1 : 0;
    c_bar[n-1] = (carry!= 0) ? 0 : (uint64_t) pow(2,k) - 1;
    
    SecAnd(z_c, s, c);
    SecAnd(z_c_bar, s_bar, c_bar);
    
    for(uint64_t i = 0; i < n; i++)
        z[i] = z_c[i] ^ z_c_bar[i];
    
}


/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure addQ*/

void SecAddQ(uint64_t z[n],  uint64_t x[n], uint64_t y[n], uint64_t q){
    uint64_t s[n], c = 0, s_bar[n], q_bar[n];
    uint64_t w = k;
    
    for(uint64_t i = 0; i < n; i++)
        q_bar[i] = 0;
    q_bar[n-1] = (uint64_t) pow(2,w) - q;
    
    SecAdd(s, x, y);
    SecAdd(s_bar, s, q_bar);
    
    for(uint64_t i = 0; i < n; i++)
        c = c ^ (s_bar[i] >> (w - 1));
    
    SecMux(z, s, s_bar, c);
}

/*##########################################################################*/
/*##########################################################################*/

/*Implementation of simplified secure addQ simplified*/

void SecAddQSimplified(uint64_t z[n],  uint64_t x[n], uint64_t y[n], uint64_t q){
    uint64_t s[n], c[n], c_bar[n];
    uint64_t w = k;
    
    SecAdd(s, x, y);

    for(uint64_t i = 0; i < n; i++){
        c[i] = (s[i] >> (w - 1)) * q;
        c_bar[i] = 0;
    }
    
    for(uint64_t i = 0; i < n; i++)
        c_bar[n-1] ^= c[i];
        
    SecAdd(z, s, c_bar);
}

/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure A2B*/

void A2B(uint64_t z[n],  uint64_t x[n], uint64_t y[n]){
    uint64_t R1[n], R2[n];
    uint64_t B1[n], B2[n];
    
    R1[n-1] = 0;
    R2[n-1] = 0;
    for(uint64_t i = 0; i < n - 1; i++){
        R1[i] = i % (uint64_t) pow(2,k);//rand() % (uint64_t) pow(2,k);
        R2[i] = (i+2) % (uint64_t) pow(2,k);//rand() % (uint64_t) pow(2,k);
        R1[n-1] ^= R1[i];
        R2[n-1] ^= R2[i];
    }
    
    for(uint64_t i = 0; i < n; i++){
        B1[i] = x[i] ^ R1[i];
        B2[i] = y[i] ^ R2[i];
    }
    
    SecAdd(z, B1, B2);
}

/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure B2A*/

void B2A(uint64_t z[n],  uint64_t x[n], uint64_t y[n]){
    
    uint64_t x_xor_y[n];
    uint64_t B[n], B1[n];
    uint64_t R[n];
    uint64_t A;
    uint64_t B_xor = 0;
    
    R[n-1] = 0;
    for(uint64_t i = 0; i < n - 1; i++){
        R[i] = i % (uint64_t) pow(2,k);//rand() % (uint64_t) pow(2,k);
        R[n-1] ^= R[i];
    }
    
    A = 2;//rand() % (uint64_t) pow(2,k);
    
    for(uint64_t i = 0; i < n; i++){
        x_xor_y[i] = x[i] ^ y[i];
        B1[i] = R[i];
    }
    B1[0] = ((uint64_t) pow(2,k) - A) ^ R[0];
    
    SecAdd(B, x_xor_y, B1);
    
    for(uint64_t i = 0; i < n; i++){
        B_xor = B_xor ^ B[i];
        z[i] = 0;
    }
    z[0] = A;
    z[n-1] = B_xor;
    
}

/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure A2Bq*/

void A2Bq(uint64_t z[n],  uint64_t x[2], uint64_t q){
    uint64_t R0, R1;
    uint64_t B0[2], B1[2];
    uint64_t w = k;
    
    R0 = 53; //rand() % q;
    R1 = 43; //rand() % q;
    
    B0[0] = x[0] ^ R0;
    B0[1] = R0;
    
    B1[0] = ((x[1] + ((uint64_t) pow(2,w) - q)) % (uint64_t) pow(2,k)) ^ R1;
    B1[1] = R1;
    
    SecAddQSimplified(z, B0, B1, q);
    
}

/*##########################################################################*/
/*##########################################################################*/

/*Implementation of secure B2Aq*/

void B2Aq(uint64_t z[n],  uint64_t x[2], uint64_t q){
    
    uint64_t R, A;
    uint64_t B0[2], B1[2];
    
    uint64_t w = k;
    
    A = 43;//rand() % q;
    R = 53;//rand()  % (uint64_t) pow(2,w);
    
    B0[0] = (((q - A) % (uint64_t) pow(2,k)) + ((uint64_t) pow(2,w) - q)) ^ R;
    B0[1] = R;
    
    
    SecAddQSimplified(B1, x, B0, q);
    
    z[0] = A;
    z[1] = B1[0] ^ B1[1];
}

/*##########################################################################*/
/*##########################################################################*/
    
int main(int argc, const char * argv[]) {
    uint64_t x[n] = {124, 126, 112, 131};
    uint64_t y[n] = {82, 137, 100, 129};
    uint64_t q = 141;
    
    uint64_t x_xor = 0;
    uint64_t y_xor = 0;
    
    if(k > 64){
        perror("Please select the k value within 1 to 64");
        return 0;
    }
    
    /*SecAnd Test*/
    uint64_t secAnd[n];
    uint64_t secAnd_xor = 0;
    SecAnd(secAnd, x, y);
    for(uint64_t i = 0; i < n; i++){
        x_xor ^= x[i];
        y_xor ^= y[i];
        secAnd_xor ^= secAnd[i];
    }
    printf("x[i] &   y[i] = %3llu ------------- SecAnd(x,y)            = %3llu\n", x_xor & y_xor, secAnd_xor);
    /*###################################################################################*/
    
    /*SecAdd Test*/
    uint64_t secAdd[n];
    uint64_t secAdd_xor = 0;
    SecAdd(secAdd, x, y);
    for(uint64_t i = 0; i < n; i++){
        secAdd_xor ^= secAdd[i];
    }
    printf("x[i] +   y[i] = %3llu ------------- SecAdd(x,y)            = %3llu\n", (x_xor + y_xor) % (uint64_t) pow(2,k), secAdd_xor);
    /*###################################################################################*/

    /*SecAddGoubin Test*/
    uint64_t secAddGoubin[n];
    uint64_t secAddGoubin_xor = 0;
    SecAddGoubin(secAddGoubin, x , y);
    for(uint64_t i = 0; i < n; i++){
        secAddGoubin_xor ^= secAddGoubin[i];
    }
    
    printf("x[i] +   y[i] = %3llu ------------- SecAddGoubin(x,y)      = %3llu\n", (x_xor + y_xor) % (uint64_t) pow(2,k), secAddGoubin_xor);
    /*###################################################################################*/

    /*SecAddQ Test*/
    uint64_t secAddq[n];
    uint64_t secAddq_xor = 0;
    uint64_t q_xor = 0;
    SecAddQ(secAddq, x, y, q);
    secAdd_xor = 0;
    for(uint64_t i = 0; i < n; i++){
        secAddq_xor ^= secAddq[i];
    }
    printf("x[i] +   y[i] = %3llu --------------SecAddQ(x,y)           = %3llu\n", ((x_xor + y_xor) % (uint64_t) pow(2,k)) % q, secAddq_xor);
    
    /*###################################################################################*/

    /*SecAddQSimplified Test*/
    uint64_t secAddqSimplified[n];
    uint64_t secAddqSimplified_xor = 0;
    SecAddQSimplified(secAddqSimplified, x, y, q);
    secAdd_xor = 0;
    for(uint64_t i = 0; i < n; i++){
        secAddqSimplified_xor ^= secAddqSimplified[i];
    }
    printf("x[i] +   y[i] = %3llu --------------SecAddQSimplified(x,y) = %3llu\n", ((x_xor + y_xor) - ((uint64_t) pow(2,k) - q)) % q , secAddqSimplified_xor);
    
    /*###################################################################################*/

    /*A2B Test*/
    uint64_t a2b[n];
    uint64_t a2b_xor = 0;
    A2B(a2b, x, y);
    for(uint64_t i = 0; i < n; i++){
        a2b_xor ^= a2b[i];
    }
    printf("x[i] +   y[i] = %3llu --------------A2B(x,y)               = %3llu\n", (x_xor + y_xor) % (uint64_t) pow(2,k), a2b_xor);

    /*###################################################################################*/

    /*B2A Test*/
    uint64_t b2a[n];
    uint64_t b2a_add = 0;
    B2A(b2a, x, y);
    for(uint64_t i = 0; i < n; i++){
        b2a_add += b2a[i];
    }
    printf("x[i] +   y[i] = %3llu --------------B2A(x,y)               = %3llu\n", (x_xor ^ y_xor) % (uint64_t) pow(2,k), b2a_add % (uint64_t) pow(2,k));
    
    /*###################################################################################*/
    
    /*A2Bq and B2Aq for 2 shares Test*/
    uint64_t a2bq[n];
    uint64_t b2aq[n];
    if(n == 2){
        /*A2Bq Test*/
        uint64_t a2bq_xor = 0;
        A2Bq(a2bq, x, q);
        for(uint64_t i = 0; i < n; i++){
            a2bq_xor ^= a2bq[i];
        }
        printf("A0   +   A1   = %3llu --------------A2Bq(x,y)              = %3llu\n", ((x[0] + x[1]) % (uint64_t) pow(2,k)) % q, a2bq_xor);

        /*###################################################################################*/
        
        /*B2Aq Test*/
        uint64_t b2aq_add = 0;
        B2Aq(b2aq, x, q);
        for(uint64_t i = 0; i < n; i++){
            b2aq_add += b2aq[i];
        }
        
        printf("B0   ^   B1   = %3llu --------------B2Aq(x,y)              = %3llu\n", (x[0] ^ x[1]), b2aq_add % q);
    }
    
    /*###################################################################################*/
    printf("\n######################################################################\n");
    printf("######################################################################\n\n");
    printf("SecAnd Shares        = {");
    for(uint64_t i = n-1; i > 0; i--)
        printf("0x%02llx,", secAnd[i]);
    printf("0x%02llx}\n", secAnd[0]);
    
    /*############################*/
    
    printf("SecAdd Shares        = {");
    for(uint64_t i = n-1; i > 0; i--)
        printf("0x%02llx,", secAdd[i]);
    printf("0x%02llx}\n", secAdd[0]);
    
    /*############################*/
    
    /*printf("SecAddGoubin Shares  = {");
    for(uint64_t i = n-1; i > 0; i--)
        printf("0x%02llx,", secAddGoubin[i]);
    printf("0x%02llx}\n", secAddGoubin[0]);*/
    
    /*############################*/
    
    printf("SecAddQ Shares       = {");
    for(uint64_t i = n-1; i > 0; i--)
        printf("0x%02llx,", secAddq[i]);
    printf("0x%02llx}\n", secAddq[0]);
    
    /*############################*/
    
    printf("SecAddQSimple Shares = {");
    for(uint64_t i = n-1; i > 0; i--)
        printf("0x%02llx,", secAddqSimplified[i]);
    printf("0x%02llx}\n", secAddqSimplified[0]);
    
    /*############################*/
    
    printf("A2B Shares           = {");
    for(uint64_t i = n-1; i > 0; i--)
        printf("0x%02llx,", a2b[i]);
    printf("0x%02llx}\n", a2b[0]);
    
    /*############################*/
    
    printf("B2A Shares           = {");
    for(uint64_t i = n-1; i > 0; i--)
        printf("0x%02llx,", b2a[i]);
    printf("0x%02llx}\n", b2a[0]);
    
    /*############################*/
    if(n == 2){
        printf("A2Bq Shares          = {");
        for(uint64_t i = n-1; i > 0; i--)
            printf("0x%02llx,", a2bq[i]);
        printf("0x%02llx}\n", a2bq[0]);
        
        /*############################*/

        printf("B2Aq Shares          = {");
        for(uint64_t i = n - 1; i > 0; i--)
            printf("0x%02llx,", b2aq[i]);
        printf("0x%02llx}\n", b2aq[0]);
    }
    
    /*############################*/
    
    
    return 0;
}
