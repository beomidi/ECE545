----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2021 04:22:15 PM
-- Design Name: 
-- Module Name: SecMux - Behavioral
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

ENTITY SecMux IS
   PORT(
        z   : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x   : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y   : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        sel : IN  STD_LOGIC
    );
END SecMux;

ARCHITECTURE Behavioral OF SecMux IS
    
    SIGNAL c       : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL cbar    : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL z_c     : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL z_c_bar : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    
BEGIN
    
    c_cbar_gen: 
    FOR i IN 0 TO n-2 GENERATE
         c((i+1)*k-1 DOWNTO i*k)    <= (OTHERS => '0');
         cbar((i+1)*k-1 DOWNTO i*k) <= (OTHERS => '0');
    END GENERATE c_cbar_gen; 
    
    c(n*k-1 DOWNTO (n-1)*k)      <=  (OTHERS => '1') WHEN sel = '1' ELSE (OTHERS => '0');
    cbar(n*k-1 DOWNTO (n-1)*k)   <=  NOT c(n*k-1 DOWNTO (n-1)*k);
    
    
    SecAnd_Inst0:
    SecAnd
    PORT MAP(
        z => z_c,
        x => x,
        y => c
    );
    
    SecAnd_Inst1:
    SecAnd 
    PORT MAP(
        z => z_c_bar,
        x => cbar,
        y => y
    );
    
    z <= z_c XOR z_c_bar;
    
END Behavioral;
