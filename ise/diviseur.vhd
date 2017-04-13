library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Diviseur is
    Port (
			  H : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  seconde: out STD_LOGIC); 
end Diviseur;

architecture Behavior of Diviseur is

signal compt : STD_LOGIC_VECTOR (25 downto 0);
begin

	PROCESS(H)
			begin 
			
				if (H'event and H='1') then 
				
				 if (reset = '1') then 
					    compt <= "00000000000000000000000000";
					
					else if (compt = "10111110101111000001111111") then 
								compt <= "00000000000000000000000000";							
								else compt <= compt + 1;
						end if ;
					end if;
				end if;
				
		end process;
			
		seconde <= '0' when (compt="10111110101111000001111111")
					else '1';
end Behavior;

