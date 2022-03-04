----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2021 06:32:47 PM
-- Design Name: 
-- Module Name: util_pkg - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- Package Declaration Section
PACKAGE util_pkg IS
 
  CONSTANT n : INTEGER := 4;
  CONSTANT k : INTEGER := 8;
 
 FUNCTION log2_unsigned ( x : NATURAL ) RETURN NATURAL;
 
  COMPONENT RAM
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
   END COMPONENT;
   
   COMPONENT TableGenerator
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
   END COMPONENT;
   
   
   COMPONENT Counters
   PORT (
            i   : OUT STD_LOGIC_VECTOR(log2_unsigned(n) -1 DOWNTO 0);
            j   : OUT STD_LOGIC_VECTOR(k-1 DOWNTO 0);
            zi  : OUT STD_LOGIC;
            zj  : OUT STD_LOGIC;
            ldj : IN  STD_LOGIC;
            ldi : IN  STD_LOGIC;
            enj : IN  STD_LOGIC;
            eni : IN  STD_LOGIC;
            rst : IN  STD_LOGIC;
            clk : IN  STD_LOGIC  
      );
    END COMPONENT;

    COMPONENT DebraizeFixed
    PORT (
            B      : OUT std_logic_vector(n*k-1 DOWNTO 0);
            beta   : OUT std_logic;
            Al     : OUT std_logic_vector(k-1 DOWNTO 0);
            A      : IN  std_logic_vector(n*k-1 DOWNTO 0);
            R      : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            rand   : IN  std_logic_vector(n*k-1 DOWNTO 0);
            p      : IN  std_logic;
            tipa   : IN  std_logic_vector(k DOWNTO 0);
            init   : IN  std_logic;
            enr    : IN  std_logic;
            enro   : IN  STD_LOGIC;
            rst    : IN  std_logic;
            clk    : IN  std_logic);
    END COMPONENT;
   
   COMPONENT ControlUnit
   PORT (
            done     : OUT std_logic;
            ldi, ldj : OUT std_logic;
            eni, enj : OUT std_logic;
            enrand   : OUT std_logic;
            enr      : OUT std_logic;
            enro     : OUT STD_LOGIC;
            init     : OUT std_logic;
            we       : OUT std_logic;
            start    : IN  std_logic;
            zi, zj   : IN  std_logic;
            rst      : IN  std_logic;
            clk      : IN  std_logic
    );
    END COMPONENT;
    
    
   COMPONENT DataPath
   PORT (
            B        : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            zi, zj   : OUT STD_LOGIC;
            A        : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            R        : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
            p        : IN  STD_LOGIC;
            eni, enj : IN  STD_LOGIC;
            enrand   : IN  STD_LOGIC;
            enr      : IN  STD_LOGIC;
            enro     : IN  STD_LOGIC;
            ldi,ldj  : IN  STD_LOGIC;
            init     : IN  STD_LOGIC;
            we       : IN  STD_LOGIC;
            rst      : IN  STD_LOGIC;
            clk      : IN  STD_LOGIC 
       );
    END COMPONENT;   
    
    COMPONENT DebraizeFixed_Wrapper 
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
    END COMPONENT; 
   
   
END PACKAGE util_pkg;
 
-- Package Body Section
PACKAGE BODY util_pkg IS
 
    FUNCTION log2_unsigned ( x : NATURAL ) RETURN NATURAL IS
        VARIABLE temp : NATURAL := x ;
        VARIABLE n    : NATURAL := 0 ;
    BEGIN
        WHILE temp > 1 LOOP
            temp := temp / 2 ;
            n := n + 1 ;
        END LOOP ;
        RETURN n ;
    END FUNCTION log2_unsigned ;
 
END PACKAGE BODY util_pkg;
