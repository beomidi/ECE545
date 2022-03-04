----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/09/2021 05:05:20 PM
-- Design Name: 
-- Module Name: B2AQ - Behavioral
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

ENTITY B2AQ IS
   PORT (
        z : OUT STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
END B2AQ;

ARCHITECTURE Behavioral OF B2AQ IS

    SIGNAL A         : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    SIGNAL R         : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    
    SIGNAL B0         : STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
    SIGNAL B1         : STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);

BEGIN

    A <= STD_LOGIC_VECTOR(TO_UNSIGNED(43, k)); -- should be replaced by an RNG
    R <= STD_LOGIC_VECTOR(TO_UNSIGNED(53, k)); -- should be replaced by an RNG

    B0(k-1 DOWNTO 0)     <= STD_LOGIC_VECTOR(UNSIGNED(q) - UNSIGNED(A) +  UNSIGNED(NOT q) + 1) XOR R;
    B0(2*k-1 DOWNTO k)   <= R;
    
    SecAddQSimplified_inst : SecAddQSimplified
    GENERIC MAP(
            n => 2,
            k => k
    )
    PORT MAP(
        z => B1,
        x => x,
        y => B0,
        q => q
    );
    
    z(k-1 DOWNTO 0)   <= A;
    z(2*k-1 DOWNTO k) <= B1(2*k-1 DOWNTO k) XOR B1(k-1 DOWNTO 0); 
    

END Behavioral;
