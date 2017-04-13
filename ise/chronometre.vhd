----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:29:07 11/23/2010 
-- Design Name: 
-- Module Name:    chronometre - Behavioral 
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

entity chronometre is
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
end chronometre;

architecture Behavioral of chronometre is
signal inter_heure :  STD_LOGIC_VECTOR (4 downto 0) := "00000"; -- intermediaire heure
signal inter_minute :  STD_LOGIC_VECTOR (5 downto 0)  := "000000"; -- intermediaire minute
signal inter_seconde :  STD_LOGIC_VECTOR (5 downto 0)  := "000000"; -- intermediaire seconde
signal etat : STD_LOGIC := '0'; -- 1 démarré, 0 arrêté
signal mem : STD_LOGIC;
signal mem_select : STD_LOGIC;
signal mem_adjust : STD_LOGIC;

begin

process(H)
begin
	if(reset = '1') then
		inter_heure <= "00000";
		inter_minute <= "000000";
		inter_seconde <= "000000";
		etat <= '0';
	elsif(enable = '1') then
		if(etat = '1') then -- Chronomètre démarré ------------------------------
			--if(mem_select = '0' and selection = '1') then
				-- MEMORISATION DES TEMPS
			--end if;
			if(mem_adjust = '0' and adjust = '1') then
				etat <= '0'; -- STOP
			end if;
		else -- Chronomètre arrêté ----------------------------------------------
			if(mem_select = '0' and selection = '1') then
				etat <= '1'; -- START
			end if;
			if(mem_adjust = '0' and adjust = '1') then
				inter_heure <= "00000"; -- RESET
				inter_minute <= "000000";
				inter_seconde <= "000000";
			end if;
		end if;
	end if;
	
	if(etat = '1' and mem = '0' and pulse_seconde = '1') then
		if (inter_seconde = "111011") then 
				inter_seconde <= "000000";
					if (inter_minute = "111011") then 
						inter_minute <= "000000";
						if (inter_heure = "10111") then
							inter_heure <= "00000";
							else inter_heure <= inter_heure + 1;
						end if;
						else inter_minute <= inter_minute + 1;
					end if;
				else inter_seconde <= inter_seconde + 1;
			end if;
	end if;
	
	mem <= pulse_seconde;
	mem_select <= selection;
	mem_adjust <= adjust;
	
end process;

etat_chrono <= etat;
heure_ecoule <= inter_heure;
minute_ecoule <= inter_minute;
seconde_ecoule <= inter_seconde;
end Behavioral;

