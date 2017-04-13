
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:50:23 11/09/2010
-- Design Name:   Minute
-- Module Name:   H:/2Anne/projet/ise/test_minute.vhd
-- Project Name:  ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Minute
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY test_minute_vhd IS
END test_minute_vhd;

ARCHITECTURE behavior OF test_minute_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT Minutes
	Port ( H : in STD_LOGIC;
			  minute : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  set : in STD_LOGIC_VECTOR (5 downto 0);
			  change : in STD_LOGIC;
			  heure: out STD_LOGIC; 
			  comptage : out  STD_LOGIC_VECTOR (5 downto 0));
	END COMPONENT;

	--Inputs
	SIGNAL H :  std_logic := '0';
	SIGNAL minute :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL set :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL change :  std_logic := '0';

	--Outputs
	SIGNAL heure :  std_logic;
	SIGNAL comptage :  std_logic_vector(5 downto 0);
	
	--constante
	CONSTANT demi_periode : TIME := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: Minutes PORT MAP(
		H => H,
		minute => minute,
		reset => reset,
		set => set,
		change => change,
		heure => heure,
		comptage => comptage
	);

	horloge : PROCESS
	BEGIN
		wait for demi_periode;
		H <= not H;
	END PROCESS horloge;
	
	h2 : PROCESS
	BEGIN
		wait for demi_periode * 2;
		minute <= not minute;
	END PROCESS h2;

	tb : PROCESS
	BEGIN

		reset <= '1';
		change <= '0';
		set <= "000000";
		
		wait for demi_periode * 2;
		
		reset <= '0';
		
		wait for demi_periode * 20;
		
		set <= "010110";
		change <= '1';
		
		wait for demi_periode * 6;
		
		change <= '0';

		wait; -- will wait forever
	END PROCESS;


END;
