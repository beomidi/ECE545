----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/10/2021 03:27:26 PM
-- Design Name: 
-- Module Name: DebraizeFixed - Behavioral
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

ENTITY DebraizeFixed IS
      PORT (
            B      : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            beta   : OUT STD_LOGIC;
            Al     : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0);
            A      : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            R      : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            rand   : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            p      : IN  STD_LOGIC;
            tipa   : IN  STD_LOGIC_VECTOR(k DOWNTO 0);
            init   : IN  STD_LOGIC;
            enr    : IN  STD_LOGIC;
            enro   : IN  STD_LOGIC;
            rst    : IN  STD_LOGIC;
            clk    : IN  STD_LOGIC);
END DebraizeFixed;

ARCHITECTURE Behavioral OF DebraizeFixed IS
    SIGNAL A_temp_i      : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL B_temp_i      : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL R_temp_i      : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL beta_temp_i   : STD_LOGIC;
    SIGNAL A_temp_o      : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL B_temp_o      : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL R_temp_o      : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL A_temp_plus_R : UNSIGNED(n*k-1 DOWNTO 0);
    SIGNAL beta_temp_o   : STD_LOGIC;
    
    SIGNAL B_Test       : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
BEGIN
    
    A_temp_plus_R <= UNSIGNED(A_temp_o) + UNSIGNED(R_temp_o(k-1 DOWNTO 0));
    
    A_temp_i      <= STD_LOGIC_VECTOR(UNSIGNED(A) - UNSIGNED(rand)) WHEN init = '1' 
    ELSE STD_LOGIC_VECTOR(SHIFT_RIGHT(A_temp_plus_R, k));
    
    R_temp_i      <= R   WHEN init = '1' 
    ELSE STD_LOGIC_VECTOR(SHIFT_RIGHT(UNSIGNED(R_temp_o), k));
    
    B_temp_i      <= ((tipa(k-1 DOWNTO 0) XOR R_temp_o(k-1 DOWNTO 0)) & B_temp_o(n*k-1 DOWNTO k));
    B_Test        <= tipa(k-1 DOWNTO 0) XOR R_temp_o(k-1 DOWNTO 0);
    
    
    beta_temp_i   <= p WHEN init = '1' 
    ELSE tipa(k);
    
    
    DebraizeFixedAlgorithm: PROCESS(clk, rst)
    BEGIN
        IF(rst = '1') THEN
            A_temp_o             <= (OTHERS => '0');
            R_temp_o             <= (OTHERS => '0');
            B_temp_o             <= (OTHERS => '0');
            R_temp_o             <= (OTHERS => '0');
            beta_temp_o          <= '0';
        ELSE
            IF(clk'event AND clk = '1') THEN
                IF(enr = '1') THEN 
                    A_temp_o     <= A_temp_i;
                    R_temp_o     <= R_temp_i;
                    B_temp_o     <= B_temp_i;
                    R_temp_o     <= R_temp_i;
                    beta_temp_o  <= beta_temp_i;
                END IF;
                
                IF(enro = '1') THEN
                     B           <= B_temp_i XOR rand;
                END IF;
            END IF;
         END IF;
    END PROCESS;
    
    Al        <= STD_LOGIC_VECTOR(A_temp_plus_R(k-1 DOWNTO 0));
    beta      <= beta_temp_o;
    
END Behavioral;
