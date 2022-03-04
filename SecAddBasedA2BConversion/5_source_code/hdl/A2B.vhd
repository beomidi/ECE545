----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2021 06:06:04 PM
-- Design Name: 
-- Module Name: A2B - Behavioral
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

ENTITY A2B IS 
    PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0));
END A2B;

ARCHITECTURE Behavioral OF A2B IS
    SIGNAL B1        : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL B2        : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL R0         : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL R0_temp    : STD_LOGIC_VECTOR(n*k-1   DOWNTO 0);
    SIGNAL R1         : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL R1_temp    : STD_LOGIC_VECTOR(n*k-1   DOWNTO 0);
    
BEGIN
    
    R0_temp(k-1 DOWNTO 0) <= (OTHERS => '0');
    R1_temp(k-1 DOWNTO 0) <= (OTHERS => '0');
    rand_gen: 
    FOR i IN 0 TO n-2 GENERATE
        R0((i+1)*k-1 DOWNTO i*k) <=  STD_LOGIC_VECTOR(TO_UNSIGNED(i, k));  --rand_slv((i+1)*12);
        R0_temp((i+2)*k-1 DOWNTO (i+1)*k) <= R0_temp((i+1)*k-1 DOWNTO i*k) XOR R0((i+1)*k-1 DOWNTO i*k);
        
        R1((i+1)*k-1 DOWNTO i*k) <= STD_LOGIC_VECTOR(TO_UNSIGNED(i+2, k)); --rand_slv((i+3)*12);
        R1_temp((i+2)*k-1 DOWNTO (i+1)*k) <= R1_temp((i+1)*k-1 DOWNTO i*k) XOR R1((i+1)*k-1 DOWNTO i*k);
    END GENERATE rand_gen;
    R0(n*k-1 DOWNTO (n-1)*k) <= R0_temp(n*k-1 DOWNTO (n-1)*k);
    R1(n*k-1 DOWNTO (n-1)*k) <= R1_temp(n*k-1 DOWNTO (n-1)*k);
    
    B1 <= x XOR R0;
    B2 <= y XOR R1;
    
    SecAdd_Inst:
    SecAdd
    PORT MAP(
        z => z,
        x => B1,
        y => B2
    );
    

END Behavioral;
