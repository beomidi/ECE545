----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2021 06:04:55 PM
-- Design Name: 
-- Module Name: DualPortRam - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.MATH_REAL.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY RAM IS
      GENERIC(
            data_width      : INTEGER := 8;
            addr_width      : INTEGER := 8
      );
      PORT (
            dout   : OUT STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
            din    : IN  STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
            addr   : IN  STD_LOGIC_VECTOR(addr_width-1 DOWNTO 0);
            we     : IN  STD_LOGIC;
            clk    : IN  STD_LOGIC
      );
END RAM;

ARCHITECTURE Behavioral OF RAM IS

    TYPE ram_type IS ARRAY(0 TO 2**addr_width  -1) OF STD_LOGIC_VECTOR(data_width -1 DOWNTO 0);
    SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));
    
BEGIN
    
    table: PROCESS(clk)
    BEGIN
        IF(clk'event AND clk = '1') THEN
            IF(we = '1') THEN
                ram(TO_INTEGER(UNSIGNED(addr))) <= din;
            END IF;
        END IF;
    END PROCESS;
    
    dout <= ram(TO_INTEGER(UNSIGNED(addr)));
    
    
    
    
END Behavioral;
