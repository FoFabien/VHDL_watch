--
-- EMBEDDED_KCPSM3.VHD
--
-- Ken Chapman - Xilinx Ltd - 3rd June 2003
--
-- This file instantiates the KCPSM3 processor macro and connects the 
-- program ROM.
--
-- NOTE: The name of the program ROM will probably need to be changed to 
--       reflect the name of the program (PSM) file applied to the assembler.
--
------------------------------------------------------------------------------------
--
-- Standard IEEE libraries
--
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--
------------------------------------------------------------------------------------
--
--
ENTITY embedded_kcpsm3 IS
  PORT (      port_id : OUT std_logic_vector(7 DOWNTO 0);
              write_strobe : OUT std_logic;
              read_strobe : OUT std_logic;
              out_port : OUT std_logic_vector(7 DOWNTO 0);
              in_port : IN std_logic_vector(7 DOWNTO 0);
              interrupt : IN std_logic;
              interrupt_ack : OUT std_logic;
              reset : IN std_logic;
              clk : IN std_logic);
END embedded_kcpsm3;
--
------------------------------------------------------------------------------------
--
-- Start of test achitecture
--
ARCHITECTURE connectivity OF embedded_kcpsm3 IS
--
------------------------------------------------------------------------------------
--
-- declaration of KCPSM3
--
  COMPONENT kcpsm3
    PORT (      address : OUT std_logic_vector(9 DOWNTO 0);
                instruction : IN std_logic_vector(17 DOWNTO 0);
                port_id : OUT std_logic_vector(7 DOWNTO 0);
                write_strobe : OUT std_logic;
                out_port : OUT std_logic_vector(7 DOWNTO 0);
                read_strobe : OUT std_logic;
                in_port : IN std_logic_vector(7 DOWNTO 0);
                interrupt : IN std_logic;
                interrupt_ack : OUT std_logic;
                reset : IN std_logic;
                clk : IN std_logic);
  END COMPONENT;
--
-- declaration of program ROM
--
  COMPONENT prog_rom 
    PORT (      address : IN std_logic_vector(9 DOWNTO 0);
                instruction : OUT std_logic_vector(17 DOWNTO 0);
                clk : IN std_logic);
  END COMPONENT;
--
------------------------------------------------------------------------------------
--
-- Signals used to connect KCPSM3 to program ROM
--
  SIGNAL     address : std_logic_vector(9 DOWNTO 0);
  SIGNAL instruction : std_logic_vector(17 DOWNTO 0);
--
------------------------------------------------------------------------------------
--
-- Start of test circuit description
--
BEGIN

  processor: kcpsm3
    PORT MAP(      address => address,
                   instruction => instruction,
                   port_id => port_id,
                   write_strobe => write_strobe,
                   out_port => out_port,
                   read_strobe => read_strobe,
                   in_port => in_port,
                   interrupt => interrupt,
                   interrupt_ack => interrupt_ack,
                   reset => reset,
                   clk => clk);

  program: prog_rom
    PORT MAP(      address => address,
                   instruction => instruction,
                   clk => clk);

END connectivity;

------------------------------------------------------------------------------------
--
-- END OF FILE EMBEDDED_KCPSM3.VHD
--
------------------------------------------------------------------------------------

