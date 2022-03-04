----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2021 07:15:50 PM
-- Design Name: 
-- Module Name: SeqAnd - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.UTIL_PKG.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY SecAnd IS
  GENERIC(
        n : INTEGER := n;
        k : INTEGER := k
  ); 
  PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0) 
  );
END SecAnd;

ARCHITECTURE Behavioral OF SecAnd IS
    
    SIGNAL z_temp       : ARRAY_TYPE;
    SIGNAL x_temp       : ARRAY_TYPE;
    SIGNAL y_temp       : ARRAY_TYPE;
    
    TYPE  MATRIX  IS  ARRAY (NATURAL RANGE 0 TO n-1, NATURAL RANGE  0 TO n-1) OF STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    SIGNAL rand         : MATRIX;
    SIGNAL z_matrix     : MATRIX;
    
BEGIN

    input_output_assign: 
    FOR i IN 0 TO n-1 GENERATE
        z((i+1)*k-1 DOWNTO i*k)      <=  z_temp(i);
        x_temp(i)                    <=  x((i+1)*k-1 DOWNTO i*k);
        y_temp(i)                    <=  y((i+1)*k-1 DOWNTO i*k);    
    END GENERATE input_output_assign; 
    
    
    
    rand_i_loop_gen: 
    FOR i IN 0 TO n-1 GENERATE
        rand_j_loop_gen: FOR j IN i+1 TO n-1 GENERATE
            rand(i, j) <= STD_LOGIC_VECTOR(TO_UNSIGNED(i + j, k)); --rand_slv((i+1)*j*12);
            rand(j, i) <= rand(i, j) XOR ((x_temp(i) AND y_temp(j)) XOR (x_temp(j) AND y_temp(i)));
        END GENERATE rand_j_loop_gen; 
    END GENERATE rand_i_loop_gen;
    
    
   z_matrix_i_loop_gen: 
   FOR i IN 0 TO n-1 GENERATE
       z_matrix_j_loop_gen: 
       FOR j IN 0 TO n-1 GENERATE
           i_j_comp_1: 
           IF(i = j) GENERATE 
                 z_matrix(i, j) <= (x_temp(i) AND y_temp(i));
           END GENERATE i_j_comp_1; 
           
           i_j_comp_2: 
           IF(i /= j) GENERATE 
                 j_comp_1: 
                 IF(j = 0) GENERATE
                        z_matrix(i, j) <= z_matrix(i, i) XOR rand(i, j);
                 END GENERATE j_comp_1;
                 
                 j_comp_2: 
                 IF(j /= 0) GENERATE
                        j_comp_3: 
                        IF(j-1 = i) GENERATE
                                 j_comp_4: 
                                 IF(j-1 = i AND j-2 >= 0) GENERATE
                                        z_matrix(i, j) <= z_matrix(i, j-2) XOR rand(i, j);
                                 END GENERATE j_comp_4;
                                 
                                 j_comp_5: 
                                 IF(j-1 = i AND j-2 < 0) GENERATE
                                        z_matrix(i, j) <= z_matrix(i, j-1) XOR rand(i, j);
                                 END GENERATE j_comp_5;
                        END GENERATE j_comp_3;
                        
                        j_comp_4: 
                        IF(j-1 /= i) GENERATE
                                 z_matrix(i, j) <= z_matrix(i, j-1) XOR rand(i, j);
                        END GENERATE j_comp_4;
                        
                 END GENERATE j_comp_2;
           END GENERATE i_j_comp_2;
        END GENERATE z_matrix_j_loop_gen;
   END GENERATE z_matrix_i_loop_gen;
   
   z_loop_gen: 
   FOR i IN 0 TO n-1 GENERATE
                i_comp_1: 
                IF(i = n-1) GENERATE
                        z_temp(i) <=  z_matrix(i, n-2);
                 END GENERATE i_comp_1;
                 
                 i_comp_2: 
                 IF(i /= n-1) GENERATE
                        z_temp(i) <=  z_matrix(i, n-1);
                 END GENERATE i_comp_2;
                 
    END GENERATE z_loop_gen;
    
END Behavioral;
