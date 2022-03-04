----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2021 06:28:17 PM
-- Design Name: 
-- Module Name: Testbench - Behavioral
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

ENTITY Testbench IS
END Testbench;

ARCHITECTURE Behavioral OF Testbench IS

    CONSTANT period: TIME := 10 ns;


    SIGNAL B      :  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL done   :  STD_LOGIC := '0';
    SIGNAL A      :  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R      :  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL p      :  STD_LOGIC := '0';
    SIGNAL start  :  STD_LOGIC := '0';
    SIGNAL rst    :  STD_LOGIC := '0';
    SIGNAL clk    :  STD_LOGIC := '0';

BEGIN
    clk <= not clk after period/2;
    
    uut: DebraizeFixed_Wrapper
    PORT MAP(
            B      =>  B,
            done   =>  done,
            A      =>  A,
            R      =>  R,
            p      =>  p,
            start  =>  start,
            rst    =>  rst,
            clk    =>  clk
     );
     
     
     PROCESS 
     BEGIN 
        rst     <= '1';
        A       <= X"ab25ef2e";
        R       <= X"29abec20";
        p       <= '1';
        WAIT FOR 4 * period;
        rst     <= '0';
        start   <= '1';
        WAIT FOR 2 * period;
        rst     <= '0';
        start   <= '0';
        WAIT;
     END PROCESS;
     

END Behavioral;
