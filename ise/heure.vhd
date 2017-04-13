library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Heures is
    Port ( H : in STD_LOGIC;
			  heure : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  set : in STD_LOGIC_VECTOR (4 downto 0);
			  change : in STD_LOGIC;
			  comptage : out  STD_LOGIC_VECTOR (4 downto 0));
end Heures;

architecture Compt of Heures is
signal mem : STD_LOGIC;
signal compt : STD_LOGIC_VECTOR (4 downto 0);
begin

	PROCESS(H)
			begin 
				if (change = '1') then 
					    compt <= set;
				elsif (mem = '0' and heure='1') then 
				    if (reset = '1') then 
					    compt <= "00000";
				    else if (compt = "10111") then 
								compt <= "00000";					
					 else compt <= compt + 1;
					 end if ;
					end if;
				end if;
				
				mem <= heure;
				
		end process;
		
		comptage <= compt;		
end Compt;

