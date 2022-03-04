----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2021 06:09:39 PM
-- Design Name: 
-- Module Name: SeqAdd - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY SecAdd IS 
    GENERIC(
        n : INTEGER := n;
        k : INTEGER := k
    );
    PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0));
END SecAdd;

ARCHITECTURE Behavioral OF SecAdd IS
    
    
    
    TYPE  MATRIX  IS  ARRAY (NATURAL RANGE 0 TO k-1) OF STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL xy           : MATRIX;
    SIGNAL xc           : MATRIX;
    SIGNAL yc           : MATRIX;
    SIGNAL c            : MATRIX;
    
    SIGNAL mask         : MATRIX;
BEGIN
    
    input_output_assign: 
    FOR i IN 0 TO n-1 GENERATE
        c(0)                         <=  (OTHERS => '0'); 
        c(k-1)(i*k DOWNTO i*k)       <=  (OTHERS => '0');      
    END GENERATE input_output_assign; 
   
    
    
    j_loop_gen:
    FOR j IN 0 TO k-2 GENERATE 
    
       SecAnd_inst_xy: SecAnd
       GENERIC MAP(
            n => n,
            k => k
       )
       PORT MAP(
            z => xy(j),
            x => x,
            y => y
       );
            
            
       SecAnd_inst_xc: SecAnd
       GENERIC MAP(
            n => n,
            k => k
       )
       PORT MAP(
            z => xc(j),
            x => x,
            y => c(j)
       );
                    
                    
       SecAnd_inst_yc: SecAnd
       GENERIC MAP(
             n => n,
             k => k
        )
        PORT MAP(
             z => yc(j),
             x => y,
             y => c(j)
        );
             
        i_loop_gen:
        FOR i IN 0 TO n-1 GENERATE
             mask(j)((i+1)*k-1 DOWNTO i*k) <= STD_LOGIC_VECTOR(SHIFT_LEFT(TO_UNSIGNED(1, k), j));
             c(j+1) <= c(j) OR STD_LOGIC_VECTOR(SHIFT_LEFT(UNSIGNED((xy(j) XOR xc(j) XOR  yc(j)) AND mask(j)), 1));     
             z <= x XOR y XOR c(k-1);
        END GENERATE i_loop_gen;  
    END GENERATE j_loop_gen;
    

END Behavioral;
