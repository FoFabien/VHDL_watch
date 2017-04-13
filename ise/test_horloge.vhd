
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:27:11 12/07/2010
-- Design Name:   horloge
-- Module Name:   H:/E2/projet/ise/test_horloge.vhd
-- Project Name:  ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: horloge
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

ENTITY test_horloge_vhd IS
END test_horloge_vhd;

ARCHITECTURE behavior OF test_horloge_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT horloge
	PORT(
		H : IN std_logic;
		reset : IN std_logic;
		set_minute : IN std_logic_vector(5 downto 0);
		set_heure : IN std_logic_vector(4 downto 0);          
		seconde : OUT std_logic_vector(5 downto 0);
		minute : OUT std_logic_vector(5 downto 0);
		heure : OUT std_logic_vector(4 downto 0);
		H_seconde : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL H :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL set_minute :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL set_heure :  std_logic_vector(4 downto 0) := (others=>'0');

	--Outputs
	SIGNAL seconde :  std_logic_vector(5 downto 0);
	SIGNAL minute :  std_logic_vector(5 downto 0);
	SIGNAL heure :  std_logic_vector(4 downto 0);
	SIGNAL H_seconde :  std_logic;
	
	--constante
	CONSTANT demi_periode : TIME := 1 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: horloge PORT MAP(
		H => H,
		reset => reset,
		seconde => seconde,
		minute => minute,
		set_minute => set_minute,
		heure => heure,
		set_heure => set_heure,
		H_seconde => H_seconde
	);
	
	clock : PROCESS
	BEGIN
		wait for demi_periode;
		H <= not H;
	END PROCESS clock;

	tb : PROCESS
	BEGIN

		reset <= '1';
		-- Wait 100 ns for global reset to finish
		wait for 100 ns;
		
		reset <= '0';

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
