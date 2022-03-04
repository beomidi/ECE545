----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/19/2021 08:12:27 PM
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
    CONSTANT period: TIME := 20 ns;
    
    SIGNAL sec_and             : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL sec_add             : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL sec_addq            : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL sec_addq_simplified : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL sec_a2b             : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL sec_b2a             : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL sec_a2b_q           : STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
    SIGNAL sec_b2a_q           : STD_LOGIC_VECTOR(2*k-1 DOWNTO 0);
    SIGNAL x                   : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL y                   : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL q                   : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    
BEGIN
    x <= STD_LOGIC_VECTOR(TO_UNSIGNED(131, k) & TO_UNSIGNED(112, k) & TO_UNSIGNED(126, k) & TO_UNSIGNED(124, k));
    y <= STD_LOGIC_VECTOR(TO_UNSIGNED(129, k) & TO_UNSIGNED(100, k) & TO_UNSIGNED(137, k) & TO_UNSIGNED(82, k));
    q <= STD_LOGIC_VECTOR(TO_UNSIGNED(141, k));
    
    
    uut0 : SecAnd
    GENERIC MAP(
        n => n,
        k => k
    )
    
    PORT MAP(
        z => sec_and,
        x => x,
        y => y
    );

    uut1 : SecAdd
    PORT MAP(
        z => sec_add,
        x => x,
        y => y
    );

    uut2 : SecAddQ
    PORT MAP(
        z => sec_addq,
        x => x,
        y => y,
        q => q
    );
    
    uut3 : SecAddQSimplified
    PORT MAP(
        z => sec_addq_simplified,
        x => x,
        y => y,
        q => q
    );
    
    uut4 : A2B
    PORT MAP(
        z => sec_a2b,
        x => x,
        y => y 
    );
    
    uut5 : B2A
    PORT MAP(
        z => sec_b2a,
        x => x,
        y => y 
    );
    
    
    uut6 : A2BQ
    PORT MAP(
        z => sec_a2b_q,
        x => x(2*k-1 DOWNTO 0),
        q => q 
    );
    
    uut7 : B2AQ
    PORT MAP(
        z => sec_b2a_q,
        x => x(2*k-1 DOWNTO 0),
        q => q 
    );
    
    
END Behavioral;
