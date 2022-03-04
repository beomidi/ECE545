----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2021 07:40:48 PM
-- Design Name: 
-- Module Name: SecAddQSimplified - Behavioral
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

ENTITY SecAddQSimplified IS
      GENERIC(
        n : INTEGER := n;
        k : INTEGER := k
      );
      PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
END SecAddQSimplified;

ARCHITECTURE Behavioral OF SecAddQSimplified IS
    
    SIGNAL s     : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL c     : STD_LOGIC; 
    SIGNAL cbar  : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL c_temp: STD_LOGIC_VECTOR(n DOWNTO 0); 
    
BEGIN

    SecAdd_Inst0:
    SecAdd
    GENERIC MAP(
        n => n,
        k => k
    )
    PORT MAP(
        z => s,
        x => x,
        y => y
    );
    
    c_temp(0) <= '0';
    c_gen: 
    FOR i IN 0 TO n-1 GENERATE
         c_temp(i+1) <= c_temp(i) XOR s((i+1)*k-1);
    END GENERATE c_gen; 
    c <= c_temp(n);
    
    cbar(n*k-1 DOWNTO (n-1)*k) <= q WHEN c = '1' ELSE (OTHERS => '0');
    cbar((n-1)*k-1 DOWNTO 0)   <= (OTHERS => '0');  
    
    SecAdd_Inst1:
    SecAdd
    GENERIC MAP(
        n => n,
        k => k
    )
    PORT MAP(
        z => z,
        x => s,
        y => cbar
    );

END Behavioral;
