
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:48:23 12/14/2010
-- Design Name:   affichage_liaison_serie
-- Module Name:   H:/E2/projet/ise/test_pour_liaison_serie.vhd
-- Project Name:  ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: affichage_liaison_serie
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

ENTITY test_pour_liaison_serie_vhd IS
END test_pour_liaison_serie_vhd;

ARCHITECTURE behavior OF test_pour_liaison_serie_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT affichage_liaison_serie
	PORT(
		state : IN std_logic_vector(2 downto 0);
		reglage_heure_alarme : IN std_logic_vector(4 downto 0);
		reglage_minute_alarme : IN std_logic_vector(5 downto 0);
		heure : IN std_logic_vector(4 downto 0);
		minute : IN std_logic_vector(5 downto 0);
		seconde : IN std_logic_vector(5 downto 0);
		chrono_heure : IN std_logic_vector(4 downto 0);
		chrono_minute : IN std_logic_vector(5 downto 0);
		chrono_seconde : IN std_logic_vector(5 downto 0);
		alarme_active : IN std_logic;
		CLOCK : IN std_logic;
		RESET : IN std_logic;        
		Y : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL alarme_active :  std_logic := '0';
	SIGNAL CLOCK :  std_logic := '0';
	SIGNAL RESET :  std_logic := '0';
	SIGNAL state :  std_logic_vector(2 downto 0) := (others=>'0');
	SIGNAL reglage_heure_alarme :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL reglage_minute_alarme :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL heure :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL minute :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL seconde :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL chrono_heure :  std_logic_vector(4 downto 0) := (others=>'0');
	SIGNAL chrono_minute :  std_logic_vector(5 downto 0) := (others=>'0');
	SIGNAL chrono_seconde :  std_logic_vector(5 downto 0) := (others=>'0');

	--Outputs
	SIGNAL Y :  std_logic_vector(31 downto 0);
	
	--constante
	CONSTANT demi_periode : TIME := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: affichage_liaison_serie PORT MAP(
		state => state,
		reglage_heure_alarme => reglage_heure_alarme,
		reglage_minute_alarme => reglage_minute_alarme,
		heure => heure,
		minute => minute,
		seconde => seconde,
		chrono_heure => chrono_heure,
		chrono_minute => chrono_minute,
		chrono_seconde => chrono_seconde,
		alarme_active => alarme_active,
		CLOCK => CLOCK,
		RESET => RESET,
		Y => Y
	);
	
	horloge : PROCESS
	BEGIN
		wait for demi_periode;
		CLOCK <= not CLOCK;
	END PROCESS horloge;

	tb : PROCESS
	BEGIN

		RESET <= '1';
		state <= "001";
		heure <= "00101";
		minute <= "001101";
		seconde <= "001101";
		wait for 100 ns;
		
		RESET <= '0';

		wait; -- will wait forever
	END PROCESS;

END;
