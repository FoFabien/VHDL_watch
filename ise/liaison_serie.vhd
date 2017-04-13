----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:56 10/19/2010 
-- Design Name: 
-- Module Name:    Suite_Mathematique - Behavioral 
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
use IEEE.numeric_std.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity affichage_liaison_serie is
    Port ( -- Etat actuel
			  state : in STD_LOGIC_VECTOR (2 downto 0);
			  -- Sortie Réglage Alarme
			  reglage_heure_alarme : in  STD_LOGIC_VECTOR (4 downto 0);
           reglage_minute_alarme : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Heure actuelle
			  heure : in  STD_LOGIC_VECTOR (4 downto 0);
           minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  seconde : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Temps écoulé
			  chrono_heure : in  STD_LOGIC_VECTOR (4 downto 0);
           chrono_minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  chrono_seconde : in  STD_LOGIC_VECTOR (5 downto 0);
			  -- Alarme On / Off
			  alarme_active : in STD_LOGIC;
			  
           CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
		START : in  STD_LOGIC;
           Y : out  STD_LOGIC_VECTOR (31 downto 0));
end affichage_liaison_serie;

architecture Behavioral of affichage_liaison_serie is
signal a : integer;
begin

calcul : process(CLOCK)
	begin
		if(CLOCK'event and CLOCK = '1')
			then if(RESET = '1')
				then a <= 0;
			elsif(START = '1') then
				case state is
					when "001" => a <= TO_INTEGER(UNSIGNED(seconde)) + TO_INTEGER(UNSIGNED(minute)) * 100 + TO_INTEGER(UNSIGNED(heure)) * 10000;
					when "010" => if(alarme_active = '1') then a <= 1;
										else a <= 0;
										end if;
					when "011" => a <= TO_INTEGER(UNSIGNED(chrono_seconde)) + TO_INTEGER(UNSIGNED(chrono_minute)) * 100 + TO_INTEGER(UNSIGNED(chrono_heure)) * 10000;
					when "100" => a <= TO_INTEGER(UNSIGNED(seconde)) + TO_INTEGER(UNSIGNED(minute)) * 100 + TO_INTEGER(UNSIGNED(heure)) * 10000;
					when "101" => a <= TO_INTEGER(UNSIGNED(reglage_minute_alarme)) + TO_INTEGER(UNSIGNED(reglage_heure_alarme)) * 100;
					when others => a <= 0;
				end case;
			end if;
		end if;
end process;

Y <= STD_LOGIC_VECTOR(TO_UNSIGNED(a, 32));

end Behavioral;

