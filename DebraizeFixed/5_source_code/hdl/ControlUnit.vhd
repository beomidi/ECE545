----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 05:38:32 PM
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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

ENTITY ControlUnit IS
    PORT (
        done     : OUT STD_LOGIC;
        ldi, ldj : OUT STD_LOGIC;
        eni, enj : OUT STD_LOGIC;
        enrand   : OUT STD_LOGIC;
        enr      : OUT STD_LOGIC;
        enro     : OUT STD_LOGIC;
        init     : OUT STD_LOGIC;
        we       : OUT STD_LOGIC;
        start    : IN  STD_LOGIC;
        zi, zj   : IN  STD_LOGIC;
        rst      : IN  STD_LOGIC;
        clk      : IN  STD_LOGIC
    );
end ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS

   TYPE STATE_TYPE IS (s_wait, s_table_gen, s_a2b, s_done);
   SIGNAL CurrentState   : STATE_TYPE;
   SIGNAL NextState   : STATE_TYPE;
   SIGNAL ChangeState: STD_LOGIC;
  

BEGIN

    PROCESS(CurrentState, start, zi, zj)
    
    BEGIN 
        eni     <= '0';
        enj     <= '0';
        ldi     <= '0';
        ldj     <= '0';
        enrand  <= '0';
        enr     <= '0';
        enro    <= '0';
        init    <= '0';
        we      <= '0';
        done    <= '0';
        
        CASE CurrentState IS
               WHEN s_wait  =>
                    IF(start = '1') then
                      NextState <= s_table_gen;
                    END IF;
                            
               WHEN s_table_gen =>
                     we      <= '1';
                     enj     <= '1';
                            
                     IF(zj = '1') THEN
                         eni     <= '1';
                         enrand  <= '1';
                         IF(zi = '1') THEN
                            ldi     <= '1';
                            ldj     <= '1';
                            eni     <= '1';
                            enj     <= '1';
                            enr     <= '1';
                            init    <= '1';
                            enrand  <= '0';
                            NextState   <= s_a2b;
                          END IF;
                      END IF;
                                                        
                        WHEN s_a2b     =>
                            eni     <= '1';
                            enr     <= '1';
                            IF(zi = '1') THEN
                                enro      <= '1';
                                NextState <= s_done;
                            END IF;
                        WHEN s_done    =>
                            done      <= '1';
                            ldi       <= '1';
                            ldj       <= '1'; 
                            eni       <= '1';
                            enj       <= '1'; 
                            NextState <= s_wait;     
                    END CASE;
    END PROCESS;

    State_Control: PROCESS(clk, rst)
    BEGIN
        IF(rst = '1') THEN
            CurrentState <= s_wait;
        ELSE
            if(clk'event and clk = '1') THEN
                   CurrentState <= NextState; 
            END IF;
        END IF;
    END PROCESS;

END Behavioral;