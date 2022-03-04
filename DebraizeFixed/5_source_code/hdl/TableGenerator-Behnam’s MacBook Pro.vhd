----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2021 02:38:51 PM
-- Design Name: 
-- Module Name: TableGenerator - Behavioral
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

ENTITY TableGenerator IS
PORT (
   tipa   : OUT STD_LOGIC_VECTOR(k DOWNTO 0);
   r      : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0);
   p      : IN  STD_LOGIC;
   j      : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0);
   i      : IN  STD_LOGIC_VECTOR(log2_unsigned(n)-1 DOWNTO 0);
   we     : IN  STD_LOGIC;
   rst    : IN  STD_LOGIC;
   clk    : IN  STD_LOGIC
   );
END TableGenerator;

ARCHITECTURE Behavioral OF TableGenerator IS

    SIGNAL tipa_temp1        : STD_LOGIC_VECTOR(k DOWNTO 0);
    SIGNAL tipa_temp2        : STD_LOGIC_VECTOR(k DOWNTO 0);
    
    
    
BEGIN
    tipa   <= tipa_temp1 WHEN (p = '1' AND we = '0') ELSE tipa_temp2; 
    
    table1: RAM
    GENERIC MAP(
        data_width      => k + 1,
        addr_width      => log2_unsigned(n) + k 
    )
    PORT MAP(
            dout  => tipa_temp1,
            din   => (p & r) XOR STD_LOGIC_VECTOR('0' & UNSIGNED(r) + UNSIGNED(j)),
            addr  => (i & j),
            we    => we,
            clk   => clk
    );
    
    table2: RAM
    GENERIC MAP(
        data_width      => k + 1,
        addr_width      => log2_unsigned(n) + k 
    )
    PORT MAP(
            dout  => tipa_temp2,
            din   => (p & r) XOR STD_LOGIC_VECTOR('0' & UNSIGNED(r) + UNSIGNED(j) + 1),
            addr  => (i & j),
            we    => we,
            clk   => clk
    );

END Behavioral;
