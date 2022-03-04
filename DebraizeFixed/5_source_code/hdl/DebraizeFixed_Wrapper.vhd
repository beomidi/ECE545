----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 06:35:57 PM
-- Design Name: 
-- Module Name: TopModule - Behavioral
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

ENTITY DebraizeFixed_Wrapper IS
PORT(
     B      : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     done   : OUT STD_LOGIC;
     A      : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     R      : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
     p      : IN  STD_LOGIC;
     start  : IN STD_LOGIC;
     rst    : IN  STD_LOGIC;
     clk    : IN  STD_LOGIC
);
END DebraizeFixed_Wrapper;

ARCHITECTURE Behavioral of DebraizeFixed_Wrapper IS

    SIGNAL ldi,ldj                      : STD_LOGIC;
    SIGNAL eni, enj, enrand, enr, enro  : STD_LOGIC;
    SIGNAL init                         : STD_LOGIC;
    SIGNAL we                           : STD_LOGIC;
    SIGNAL zi, zj                       : STD_LOGIC;
    
    

BEGIN
    
    ControlUnit_Inst: ControlUnit
    PORT MAP(
        done     => done,
        ldi      => ldi,
        ldj      => ldj,
        eni      => eni,
        enj      => enj,
        enrand   => enrand,
        enr      => enr,
        enro     => enro, 
        init     => init,
        we       => we,
        start    => start,
        zi       => zi,
        zj       => zj,
        rst      => rst,
        clk      => clk
    );
    
    DataPath_Inst: DataPath
    PORT MAP(
        B        => B,
        zi       => zi,
        zj       => zj,
        A        => A,
        R        => R,
        p        => p,
        eni      => eni,
        enj      => enj,
        enrand   => enrand,
        enr      => enr,
        enro     => enro, 
        ldi      => ldi,
        ldj      => ldj,
        init     => init,
        we       => we,
        rst      => rst,
        clk      => clk
    );
    

END Behavioral;
