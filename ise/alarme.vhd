----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:08 11/23/2010 
-- Design Name: 
-- Module Name:    alarme - Behavioral 
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

entity alarme is
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
end alarme;

architecture Behavioral of alarme is
signal active : std_logic := '0'; -- 1 activer, 0 désactiver
signal inter_alarme : std_logic := '0'; -- signal intermédiaire pour signal_alarme
signal inter_selection : std_logic := '0';
begin

process(H)
begin
	if(reset = '1') then
		active <= '0';
		inter_alarme <= '0';
		inter_selection <= '0';
	else
		if(enable = '1' and selection = '1' and inter_selection = '0') then
			active <= not(active);
		end if;
		
		if(active = '1' and set_heure = heure and set_minute = minute) then
			inter_alarme <= '1';
		else
			inter_alarme <= '0';
		end if;
	end if;
	inter_selection <= selection;
end process;

signal_alarme <= inter_alarme;
alarme_active <= active;

end Behavioral;

