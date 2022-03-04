----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2021 08:40:34 PM
-- Design Name: 
-- Module Name: A2BQ - Behavioral
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

ENTITY A2BQ IS
   PORT (
        z : OUT STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
END A2BQ;

ARCHITECTURE Behavioral OF A2BQ IS
    
    SIGNAL R0         : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    SIGNAL R1         : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    
    SIGNAL B0         : STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
    SIGNAL B1         : STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
    
BEGIN
    

    R0 <= STD_LOGIC_VECTOR(TO_UNSIGNED(53, k)); -- should be replaced by an RNG
    R1 <= STD_LOGIC_VECTOR(TO_UNSIGNED(43, k)); -- should be replaced by an RNG

    B0(k-1 DOWNTO 0)     <= x(k-1 DOWNTO 0) XOR R0;
    B0(2*k-1 DOWNTO k)   <= R0;
    
    B1(k-1 DOWNTO 0)     <= STD_LOGIC_VECTOR(UNSIGNED(x(2*k-1 DOWNTO k)) +  UNSIGNED(NOT q) + 1) XOR R1;
    B1(2*k-1 DOWNTO k)   <= R1;
    
    SecAddQSimplified_inst : SecAddQSimplified
    GENERIC MAP(
            n => 2,
            k => k
    )
    PORT MAP(
        z => z,
        x => B0,
        y => B1,
        q => q
    );

END Behavioral;
