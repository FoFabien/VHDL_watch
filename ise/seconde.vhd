library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Secondes is
    Port ( H : in STD_LOGIC;
			  seconde : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  minute: out STD_LOGIC ; 
			  comptage : out  STD_LOGIC_VECTOR (5 downto 0));
end Secondes;

architecture Compt of Secondes is
signal mem : STD_LOGIC;
signal compt : STD_LOGIC_VECTOR (5 downto 0);
begin

	PROCESS(H)
			begin 
				if (mem = '0' and seconde= '1') then 
				   if (reset = '1') then 
					    compt <= "000000";
					else if (compt = "111011") then 
								compt <= "000000";					
								else compt <= compt + 1;
						end if ;
					end if;
				end if;
				
			mem <= seconde;
		end process;
		
		comptage <= compt;		
		minute <= '0' when (compt="111011")
					else '1';
end Compt;

