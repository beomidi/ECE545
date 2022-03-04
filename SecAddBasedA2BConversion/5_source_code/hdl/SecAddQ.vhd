----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2021 12:09:38 PM
-- Design Name: 
-- Module Name: SecAddq - Behavioral
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

ENTITY SecAddQ IS 
    PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
END SecAddQ;

ARCHITECTURE Behavioral OF SecAddQ IS

    SIGNAL qbar  : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL s     : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL sbar  : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL c     : STD_LOGIC; 
    SIGNAL c_temp: STD_LOGIC_VECTOR(n DOWNTO 0); 
    
BEGIN

 
    qbar((n-1)*k-1 DOWNTO 0) <= (OTHERS => '0');
    qbar(n*k-1 DOWNTO (n-1)*k)     <=  STD_LOGIC_VECTOR(SIGNED(NOT q) + 1);
    
    SecAdd_Inst0:
    SecAdd
    PORT MAP(
        z => s,
        x => x,
        y => y
    );
    
    SecAdd_Inst1:
    SecAdd
    PORT MAP(
        z => sbar,
        x => s,
        y => qbar
    );
    
    c_temp(0) <= '0';
    c_gen: 
    FOR i IN 0 TO n-1 GENERATE
         c_temp(i+1) <= c_temp(i) XOR sbar((i+1)*k-1);
    END GENERATE c_gen; 
    c <= c_temp(n);
    
    SecMux_Inst:
    SecMux
    PORT MAP(
        z   => z,
        x   => s,
        y   => sbar,
        sel => c
    );
    
END Behavioral;
