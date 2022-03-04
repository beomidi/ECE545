----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2021 08:03:19 PM
-- Design Name: 
-- Module Name: B2A - Behavioral
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

ENTITY B2A IS 
    PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0));
END B2A;

ARCHITECTURE Behavioral OF B2A IS
     
     SIGNAL xy_xor    : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     SIGNAL R         : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     SIGNAL R_temp    : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     SIGNAL A         : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
     SIGNAL B1        : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     SIGNAL B         : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     SIGNAL B_temp    : STD_LOGIC_VECTOR((n+1)*k-1 DOWNTO 0);
    
BEGIN
    
    xy_xor <= x XOR y;
    
    A <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, k)); --rand_slv(56);
    R_temp(k-1 DOWNTO 0) <= (OTHERS => '0');
    rand_gen: 
    FOR i IN 0 TO n-2 GENERATE
        R((i+1)*k-1 DOWNTO i*k) <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, k)); --rand_slv((i+3)*12);
        R_temp((i+2)*k-1 DOWNTO (i+1)*k) <= R_temp((i+1)*k-1 DOWNTO i*k) XOR R((i+1)*k-1 DOWNTO i*k);
    END GENERATE rand_gen;
    R(n*k-1 DOWNTO (n-1)*k) <= R_temp(n*k-1 DOWNTO (n-1)*k);
    
    B1(k-1 DOWNTO 0)  <= STD_LOGIC_VECTOR(SIGNED(NOT A) + 1) XOR R(k-1 DOWNTO 0);
    B1(n*k-1 DOWNTO k)  <= R(n*k-1 DOWNTO k);
     
    SecAdd_Inst:
    SecAdd
    PORT MAP(
        z => B,
        x => xy_xor,
        y => B1
    );
    
    B_temp(k-1 DOWNTO 0) <= (OTHERS => '0');
    B_xor_gen: 
    FOR i IN 0 TO n-1 GENERATE
        B_temp((i+2)*k-1 DOWNTO (i+1)*k) <= B_temp((i+1)*k-1 DOWNTO i*k) XOR B((i+1)*k-1 DOWNTO i*k);
    END GENERATE B_xor_gen;
    
    z(k-1 DOWNTO 0)         <= A;
    z((n-1)*k-1 DOWNTO k)   <= (OTHERS => '0');
    z(n*k-1 DOWNTO (n-1)*k) <= B_temp((n+1)*k-1 DOWNTO n*k);
    

END Behavioral;
