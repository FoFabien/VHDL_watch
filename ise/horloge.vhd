----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:06:12 12/07/2010 
-- Design Name: 
-- Module Name:    horloge - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity horloge is
    Port ( H : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  seconde : out  STD_LOGIC_VECTOR (5 downto 0);
			  minute : out STD_LOGIC_VECTOR (5 downto 0);
			  set_minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  heure : out STD_LOGIC_VECTOR (4 downto 0);
			  set_heure : in  STD_LOGIC_VECTOR (4 downto 0);
			  change_heure : in STD_LOGIC;
			  change_minute : in STD_LOGIC;
			  H_seconde : out STD_LOGIC);
end horloge;

architecture Behavioral of horloge is

component Diviseur is
    Port (
			  H : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  seconde: out STD_LOGIC); 
end component;

component Secondes is
    Port (
			  seconde : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  minute: out STD_LOGIC ; 
			  comptage : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

component Minutes is
    Port (
			  minute : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  set : in STD_LOGIC_VECTOR (5 downto 0);
			  change : in STD_LOGIC;
			  heure: out STD_LOGIC ; 
			  comptage : out  STD_LOGIC_VECTOR (5 downto 0));
end component;

component Heures is
    Port (
			  heure : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  set : in STD_LOGIC_VECTOR (4 downto 0);
			  change : in STD_LOGIC;
			  comptage : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

-- SIGNAUX
signal pulse_seconde : STD_LOGIC;
signal pulse_minute : STD_LOGIC;
signal pulse_heure : STD_LOGIC;


begin

uu1 : Diviseur Port Map (
		H => H,
		reset => reset,
		seconde => pulse_seconde);
		
uu2 : Secondes Port Map (		
		seconde => pulse_seconde,
		reset => reset,
		minute => pulse_minute,
		comptage => seconde);
		
uu3 : Minutes Port Map (		
		minute => pulse_minute,
		reset => reset,
		set => set_minute,
		change => change_minute,
		heure => pulse_heure,
		comptage => minute);

uu4 : Heures Port Map (		
		heure => pulse_heure,
		reset => reset,
		set => set_heure,
		change => change_heure,
		comptage => heure);

end Behavioral;

