
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:12:32 11/23/2010
-- Design Name:   chronometre
-- Module Name:   H:/E2/projet/ise/test_chrono.vhd
-- Project Name:  ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: chronometre
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

ENTITY test_chrono_vhd IS
END test_chrono_vhd;

ARCHITECTURE behavior OF test_chrono_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT chronometre
	Port ( H : in STD_LOGIC;
			 reset : in STD_LOGIC;
          enable : in  STD_LOGIC;
			 pulse_seconde : in  STD_LOGIC;
          heure_ecoule : out  STD_LOGIC_VECTOR (4 downto 0);
          minute_ecoule : out  STD_LOGIC_VECTOR (5 downto 0);
			 seconde_ecoule : out  STD_LOGIC_VECTOR (5 downto 0);
          selection : in  STD_LOGIC;
			 adjust : in STD_LOGIC;
			 etat_chrono : out STD_LOGIC);
	END COMPONENT;

	--Inputs
	SIGNAL H : std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL enable :  std_logic := '0';
	SIGNAL selection :  std_logic := '0';
	SIGNAL adjust :  std_logic := '0';
	SIGNAL pulse_seconde :  std_logic := '0';

	--Outputs
	SIGNAL heure_ecoule :  std_logic_vector(4 downto 0);
	SIGNAL minute_ecoule :  std_logic_vector(5 downto 0);
	SIGNAL seconde_ecoule :  std_logic_vector(5 downto 0);
	SIGNAL etat_chrono :  std_logic;
	
	--constante
	CONSTANT demi_periode : TIME := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: chronometre PORT MAP(
		H => H,
		reset => reset,
		enable => enable,
		pulse_seconde => pulse_seconde,
		heure_ecoule => heure_ecoule,
		minute_ecoule => minute_ecoule,
		seconde_ecoule => seconde_ecoule,
		selection => selection,
		adjust => adjust,
		etat_chrono => etat_chrono
	);
	
	horloge : PROCESS
	BEGIN
		wait for demi_periode;
		H <= not H;
	END PROCESS horloge;
	
	hSeconde : PROCESS
	BEGIN
		wait for demi_periode * 4;
		pulse_seconde <= not pulse_seconde;
	END PROCESS hSeconde;

	tb : PROCESS
	BEGIN

		reset <= '1';
		enable <= '1';
		
		wait for 100 ns;

		reset <= '0';
		
		wait for demi_periode * 4;
		
		selection <= '1'; -- START
		
		wait for demi_periode * 4;
		
		selection <= '0';
		
		wait for demi_periode * 500;
		
		adjust <= '1'; -- STOP
		
		wait for demi_periode * 4;
		
		adjust <= '0';
		
		wait for demi_periode * 4;
		
		selection <= '1'; -- RESTART
		
		wait for demi_periode * 4;
		
		selection <= '0';
		
		wait for demi_periode * 400;
		
		adjust <= '1'; -- STOP
		
		wait for demi_periode * 4;
		
		adjust <= '0';
		
		wait for demi_periode * 4;
		
		adjust <= '1'; -- RESET
		
		wait for demi_periode * 4;
		
		adjust <= '0';

		wait; -- will wait forever
	END PROCESS;

END;
