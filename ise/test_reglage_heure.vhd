
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:25:13 11/16/2010
-- Design Name:   reglage_heure
-- Module Name:   H:/2Anne/projet/ise/test_reglage_heure.vhd
-- Project Name:  ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reglage_heure
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

ENTITY test_reglage_heure_vhd IS
END test_reglage_heure_vhd;

ARCHITECTURE behavior OF test_reglage_heure_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT reglage_heure
	Port ( H : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           selection : in  STD_LOGIC;
           heure : in  STD_LOGIC_VECTOR (4 downto 0);
           minute : in  STD_LOGIC_VECTOR (5 downto 0);
           rotation : in  STD_LOGIC_VECTOR (1 downto 0);
           set_heure : out  STD_LOGIC_VECTOR (4 downto 0);
           set_minute : out  STD_LOGIC_VECTOR (5 downto 0);
		 change_heure : out STD_LOGIC;
		 change_minute : out STD_LOGIC);
	END COMPONENT;

	--Inputs
	SIGNAL H :  std_logic := '0';
	SIGNAL reset :  std_logic := '0';
	SIGNAL enable :  std_logic := '0';
	SIGNAL selection :  std_logic := '0';
	SIGNAL heure :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL minute :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL rotation :  std_logic_vector(1 downto 0) := (others=>'0');

	--Outputs
	SIGNAL set_heure :  std_logic_vector(4 downto 0);
	SIGNAL set_minute :  std_logic_vector(5 downto 0);
	SIGNAL change_heure :  std_logic := '0';
	SIGNAL change_minute :  std_logic := '0';
	
	--constante
	CONSTANT demi_periode : TIME := 1 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: reglage_heure PORT MAP(
		H => H,
		reset => reset,
		enable => enable,
		selection => selection,
		heure => heure,
		minute => minute,
		rotation => rotation,
		set_heure => set_heure,
		set_minute => set_minute,
		change_heure => change_heure,
		change_minute => change_minute
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
		rotation <= "00";
		heure <= "10110";
		wait for 100 ns;

		reset <= '0';
		
		wait for demi_periode * 2;
		
		rotation <= "01";
		
		wait for demi_periode * 4;
		
		rotation <= "11";
		
		wait for demi_periode * 4;
		
		rotation <= "10";
		
		wait for demi_periode * 4;
		
		rotation <= "11";
		
		wait for demi_periode * 42;
		
		rotation <= "01";
		
		wait for demi_periode * 4;
		
		rotation <= "00";
		
		wait for demi_periode * 4;
		
		rotation <= "01";
		
		wait for demi_periode * 4;
		
		rotation <= "11";
		
		wait for demi_periode * 4;
		
		rotation <= "10";
		
		wait for demi_periode * 4;
		
		rotation <= "00";
		
		wait for demi_periode * 4;
		selection <= '1';
		rotation <= "01";
		
		wait for demi_periode * 4;
		selection <= '0';
		rotation <= "11";
		
		wait for demi_periode * 4;
		
		rotation <= "10";
		
		wait for demi_periode * 4;
		
		rotation <= "11";
		
		wait for demi_periode * 4;
		
		rotation <= "01";
		
		wait for demi_periode * 4;
		
		rotation <= "00";
		
		wait for demi_periode * 4;
		
		rotation <= "01";
		
		wait for demi_periode * 4;
		
		rotation <= "11";
		
		wait for demi_periode * 4;
		
		rotation <= "10";
		
		wait for demi_periode * 4;
		
		rotation <= "00";

		wait; -- will wait forever
	END PROCESS;
	
	--heure <= set_heure;
	--minute <= set_minute;

END;
