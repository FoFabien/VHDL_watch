library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity Minutes is
    Port ( H : in STD_LOGIC;
			  minute : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  set : in STD_LOGIC_VECTOR (5 downto 0);
			  change : in STD_LOGIC;
			  heure: out STD_LOGIC; 
			  comptage : out  STD_LOGIC_VECTOR (5 downto 0));
end Minutes;

architecture Compt of Minutes is
signal mem : STD_LOGIC;
signal compt : STD_LOGIC_VECTOR (5 downto 0);
begin

	PROCESS(H)
			begin 
				if (reset = '1') then 
					    compt <= "000000";
				elsif (change = '1') then  
					    compt <= set;
				elsif (mem = '0' and minute= '1') then 
					   if (compt = "111011") then 
								compt <= "000000";					
								else compt <= compt + 1;
						end if ;
				end if;
				
				mem <= minute;
				
		end process;
		
		comptage <= compt;		
		heure <= '0' when (compt="111011")
					else '1';
end Compt;

