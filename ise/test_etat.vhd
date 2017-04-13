
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:37:43 11/09/2010
-- Design Name:   machine_etat
-- Module Name:   H:/2Anne/projet/ise/test_etat.vhd
-- Project Name:  ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: machine_etat
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

ENTITY test_etat_vhd IS
END test_etat_vhd;

ARCHITECTURE behavior OF test_etat_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT machine_etat
	PORT(
		H : IN std_logic;
		mode : IN std_logic;
		adjust : IN std_logic;
		R : IN std_logic;          
		state : OUT std_logic_vector(2 downto 0);
		enable_alarme : OUT std_logic;
		enable_chrono : OUT std_logic;
		enable_reglage_h : OUT std_logic;
		enable_reglage_a : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL H :  std_logic := '0';
	SIGNAL mode :  std_logic := '0';
	SIGNAL adjust :  std_logic := '0';
	SIGNAL R :  std_logic := '0';

	--Outputs
	SIGNAL state :  std_logic_vector(2 downto 0);
	SIGNAL enable_alarme :  std_logic;
	SIGNAL enable_chrono :  std_logic;
	SIGNAL enable_reglage_h :  std_logic;
	SIGNAL enable_reglage_a :  std_logic;
	
	--constante
	CONSTANT demi_periode : TIME := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: machine_etat PORT MAP(
		H => H,
		mode => mode,
		adjust => adjust,
		R => R,
		state => state,
		enable_alarme => enable_alarme,
		enable_chrono => enable_chrono,
		enable_reglage_h => enable_reglage_h,
		enable_reglage_a => enable_reglage_a
	);
	
	horloge : PROCESS
	BEGIN
		wait for demi_periode;
		H <= not H;
	END PROCESS horloge;

	tb : PROCESS
	BEGIN

		R <= '1';
		mode <= '0';
		adjust <= '0';
		
		wait for demi_periode * 2;
		
		R <= '0';
		
		wait for demi_periode * 2;
		
		adjust <= '1';
		
		wait for demi_periode * 4;
		
		adjust <= '0';
		
		wait for demi_periode * 8;
		
		adjust <= '1';
		
		wait for demi_periode * 4;
		
		adjust <= '0';
		mode <= '1';
		
		wait for demi_periode * 4;
		
		mode <= '0';
		
		wait for demi_periode * 4;
		
		adjust <= '1';
		
		wait for demi_periode * 4;
		
		adjust <= '0';
		
		wait for demi_periode * 8;
		
		adjust <= '1';
		
		wait for demi_periode * 4;
		
		adjust <= '0';
		mode <= '1';
		
		wait for demi_periode * 4;
		
		mode <= '0';
		
		wait for demi_periode * 16;

END PROCESS;

END;
