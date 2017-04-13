
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:52:58 11/23/2010
-- Design Name:   alarme
-- Module Name:   H:/E2/projet/ise/test_alarme.vhd
-- Project Name:  ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alarme
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

ENTITY test_alarme_vhd IS
END test_alarme_vhd;

ARCHITECTURE behavior OF test_alarme_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT alarme
	Port ( H : in  STD_LOGIC;
			  reset : in STD_LOGIC;
           enable : in  STD_LOGIC;
           heure : in  STD_LOGIC_VECTOR (4 downto 0);
           minute : in  STD_LOGIC_VECTOR (5 downto 0);
           set_heure : in  STD_LOGIC_VECTOR (4 downto 0);
           set_minute : in  STD_LOGIC_VECTOR (5 downto 0);
           selection : in  STD_LOGIC;
			  alarme_active : out STD_LOGIC;
           signal_alarme : out  STD_LOGIC);
	END COMPONENT;

	--Inputs
	SIGNAL H :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL enable :  std_logic := '0';
	SIGNAL selection :  std_logic := '0';
	SIGNAL heure :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL minute :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL set_heure :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL set_minute :  std_logic_vector(5 downto 0) := (others=>'0');

	--Outputs
	SIGNAL signal_alarme :  std_logic;
	SIGNAL alarme_active :  std_logic;
	
	--constante
	CONSTANT demi_periode : TIME := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: alarme PORT MAP(
		H => H,
		reset => reset,
		enable => enable,
		heure => heure,
		minute => minute,
		set_heure => set_heure,
		set_minute => set_minute,
		selection => selection,
		signal_alarme => signal_alarme,
		alarme_active => alarme_active
	);
	
	horloge : PROCESS
	BEGIN
		wait for demi_periode;
		H <= not H;
	END PROCESS horloge;

	tb : PROCESS
	BEGIN

		reset <= '1';
		enable <= '1';
		set_heure <= "01111";
		set_minute <= "100011";
		minute <= "000000";
		heure <= "00000";
		
		wait for 100 ns;
		
		reset <= '0';
		
		wait for demi_periode * 3;
		
		selection <= '1';
		
		wait for demi_periode * 4;
		
		selection <= '0';
		minute <= set_minute;
		heure <= set_heure;
		
		wait for demi_periode * 4;
		
		minute <= "000000";
		heure <= "00000";
		
		wait for demi_periode * 6;
		
		selection <= '1';
		enable <= '0';
		
		wait for demi_periode * 6;
		
		selection <= '0';
		minute <= set_minute;
		heure <= set_heure;
		
		wait for demi_periode * 6;
		
		minute <= "000000";
		heure <= "00000";
		
		wait; -- will wait forever
	END PROCESS;

END;
