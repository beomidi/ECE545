----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2021 06:49:34 PM
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
  
  FUNCTION log2_unsigned (x : NATURAL) RETURN NATURAL; 
  FUNCTION rand_slv(seed : NATURAL) RETURN STD_LOGIC_VECTOR;
  
  TYPE ARRAY_TYPE IS ARRAY (0 TO n-1) OF STD_LOGIC_VECTOR(k-1 DOWNTO 0);
  
  COMPONENT SecAnd
  GENERIC(
        n : INTEGER := n;
        k : INTEGER := k); 
  PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0) 
  );
  END COMPONENT;
  
  
  COMPONENT SecAdd 
  GENERIC(
        n : INTEGER := n;
        k : INTEGER := k);
  PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0));
  END COMPONENT;
  
  
  COMPONENT SecMux
  PORT(
        z   : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x   : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y   : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        sel : IN  STD_LOGIC
  );
  END COMPONENT;

  COMPONENT SecAddQ 
  PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT SecAddQSimplified
  GENERIC(
        n : INTEGER := n;
        k : INTEGER := k);
  PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT A2B 
  PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT B2A
  PORT (
        z : OUT STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
        y : IN  STD_LOGIC_VECTOR(n*k-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT A2BQ IS
  PORT (
        z : OUT STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
  END COMPONENT;
  
  COMPONENT B2AQ IS
  PORT (
        z : OUT STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        x : IN  STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
        q : IN  STD_LOGIC_VECTOR(k-1 DOWNTO 0));
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
    
---------------------------------------------------------------------------------------  
---------------------------------------------------------------------------------------    
  
  FUNCTION rand_slv(seed : NATURAL) RETURN STD_LOGIC_VECTOR IS
         VARIABLE r : real;
         VARIABLE seed1, seed2 : NATURAL := seed;
         VARIABLE slv : std_logic_vector(k-1 DOWNTO 0);
  
  BEGIN
      FOR i IN slv'range LOOP
        UNIFORM(seed1, seed2, r);
        IF( r > 0.5) THEN 
            slv(i) := '1';
        ELSE 
            slv(i) := '0';
        END IF;
      END LOOP ;
      RETURN slv;
  END FUNCTION rand_slv;
 
---------------------------------------------------------------------------------------  
--------------------------------------------------------------------------------------- 

END PACKAGE BODY util_pkg;
