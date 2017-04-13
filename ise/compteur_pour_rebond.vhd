library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity compteur is
	port(
	comptage, H : in std_logic;
	fin_comptage : out std_logic
	);
end compteur;

architecture compte of compteur is
	signal AUX : std_logic_vector (16 downto 0);
	begin
		process (H)
			begin

			if H'event and H = '1'
				then fin_comptage <= '0';
				if comptage = '1'
				then AUX <= AUX + 1;
					if AUX = 100000;
						then AUX <= "0000000000000000";
						fin_comptage <= '1';
					end if;
				else AUX <= "0000000000000000";
				end if;
			end if;
		end process;
end compte;