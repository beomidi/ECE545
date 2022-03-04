----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 01:33:25 PM
-- Design Name: 
-- Module Name: Counters - Behavioral
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

ENTITY Counters IS
PORT (
            i   : OUT STD_LOGIC_VECTOR(log2_unsigned(n) -1 DOWNTO 0);
            j   : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0);
            zi  : OUT STD_LOGIC;
            zj  : OUT STD_LOGIC;
            ldi : IN  STD_LOGIC;
            ldj : IN  STD_LOGIC;
            eni : IN  STD_LOGIC;
            enj : IN  STD_LOGIC;
            rst : IN  STD_LOGIC;
            clk : IN  STD_LOGIC  
      );
END Counters;

ARCHITECTURE Behavioral OF Counters IS

BEGIN

    i_counter: PROCESS(clk, rst)
        VARIABLE counter : std_logic_vector(log2_unsigned(n) -1 DOWNTO 0);     
    BEGIN
        IF(rst = '1') THEN
            counter := (OTHERS => '0');
            zi      <= '0';
            i       <= (OTHERS => '0');
        ELSE
            IF(clk'event and clk = '1') THEN
                IF(eni = '1') THEN
                     IF(ldi = '1') THEN
                         counter := (OTHERS => '0');
                         zi      <= '0';
                     ELSE
                        counter := STD_LOGIC_VECTOR(UNSIGNED(counter) + 1);
                        IF(counter = STD_LOGIC_VECTOR(TO_UNSIGNED(n - 1, log2_unsigned(n)))) THEN
                            zi <= '1';
                        ELSE
                            zi <= '0';
                        END IF;
                     END IF;
                END IF;
                i       <= counter;
             END IF;
        END IF;
    END PROCESS;
    
    
    
    j_counter: PROCESS(clk, rst)
        VARIABLE counter : STD_LOGIC_VECTOR(k-1 DOWNTO 0); 
    BEGIN
        IF(rst = '1') THEN
            counter := (OTHERS => '0');
            zj      <= '0';
            j       <= (OTHERS => '0');
        ELSE
            IF(clk'event AND clk = '1') THEN
                IF(enj = '1') THEN
                     IF(ldj = '1') THEN
                         counter := (OTHERS => '0');
                         zj      <= '0';
                     ELSE
                        counter := STD_LOGIC_VECTOR(UNSIGNED(counter) + 1);
                        IF(counter = STD_LOGIC_VECTOR(TO_UNSIGNED(2**k - 1, k))) THEN
                            zj <= '1';
                        ELSE
                            zj <= '0';
                        END IF;
                     END IF;
                END IF;
                j       <= counter;
             END IF;
        END IF;
    END PROCESS;
    
END Behavioral;
