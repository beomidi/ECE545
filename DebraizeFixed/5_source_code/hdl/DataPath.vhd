----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 02:27:02 PM
-- Design Name: 
-- Module Name: DataPath - Behavioral
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

ENTITY DataPath IS
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
END DataPath;

ARCHITECTURE Behavioral OF DataPath IS
    SIGNAL i      : STD_LOGIC_VECTOR(log2_unsigned(n) -1 DOWNTO 0);
    SIGNAL j      : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    SIGNAL rand_t : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    SIGNAL rand   : STD_LOGIC_VECTOR(n*k-1 DOWNTO 0);
    SIGNAL tipa   : STD_LOGIC_VECTOR(k DOWNTO 0);
    SIGNAL beta   : STD_LOGIC;
    
    SIGNAL al     : STD_LOGIC_VECTOR(k-1 DOWNTO 0);
    SIGNAL p_temp : STD_LOGIC;
    SIGNAL j_temp : STD_LOGIC_VECTOR(k-1 DOWNTO 0);

BEGIN

    Counters_Inst: Counters 
    PORT MAP(
        i       => i,
        j       => j,
        zi      => zi,
        zj      => zj,
        ldi     => ldi,
        ldj     => ldj,
        eni     => eni,
        enj     => enj,
        rst     => rst,
        clk     => clk 
    );
    
   
   p_temp <= p WHEN we = '1' ELSE beta; 
   j_temp <= j WHEN we = '1' ELSE al;
   
   
   TableGenerator_Inst: TableGenerator
   PORT MAP(
        tipa    => tipa,
        r      => rand_t,
        p      => p_temp,
        j      => j_temp,
        i      => i,
        we     => we,
        rst    => rst,
        clk    => clk
   );
   
   
   DebraizeFixed_inst: DebraizeFixed
   PORT MAP(
            B      => B,
            beta   => beta,
            Al     => Al,
            A      => A,
            R      => R,
            rand   => rand,
            p      => p,
            tipa   => tipa,
            init   => init,
            enr    => enr,
            enro   => enro,
            rst    => rst,
            clk    => clk);
            

    Rand_Gen: PROCESS(clk, rst)
        VARIABLE counter : UNSIGNED(k-1 DOWNTO 0);
    BEGIN
        IF(rst = '1') THEN
            counter := (OTHERS => '0');
            rand_t  <= (OTHERS => '0');
            rand    <= (OTHERS => '0');
        ELSE
            IF(clk'event AND clk ='1') THEN
                IF(enrand = '1') THEN
                    counter := counter + 1; 
                    rand_t  <= STD_LOGIC_VECTOR(counter);
                    rand    <= STD_LOGIC_VECTOR(counter & UNSIGNED(rand(n*k-1 DOWNTO k)));  
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    
END Behavioral;
