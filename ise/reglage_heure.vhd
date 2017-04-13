----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:40:33 11/16/2010 
-- Design Name: 
-- Module Name:    reglage_heure - Behavioral 
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

entity reglage_heure is
    Port ( H : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           selection : in  STD_LOGIC;
           heure : in  STD_LOGIC_VECTOR (4 downto 0);
           minute : in  STD_LOGIC_VECTOR (5 downto 0);
           rotation : in  STD_LOGIC_VECTOR (1 downto 0);
           set_heure : out  STD_LOGIC_VECTOR (4 downto 0);
           set_minute : out  STD_LOGIC_VECTOR (5 downto 0);
			  change_heure : out STD_LOGIC;
			  change_minute : out STD_LOGIC);
end reglage_heure;

architecture Behavioral of reglage_heure is
signal choix : std_logic; -- choix des minutes (1) ou des heures (0)
signal inter_heure :  STD_LOGIC_VECTOR (4 downto 0); -- signal intermédiaire pour set_heure
signal inter_minute :  STD_LOGIC_VECTOR (5 downto 0); -- signal intermédiaire pour set_minute
type etats is (Init,Debut, Horaire, Incre, Attente_h, Trigo, Decre, Attente_t);
signal etat_present, etat_futur : etats;
signal mem_select : std_logic;

begin

calcul_etat_futur : process(rotation, reset, enable, etat_present)
begin
	if(reset='1') then
		etat_futur <= Init;
		choix <= '0';
		inter_minute <= "000000";
		inter_heure <= "00000";
	elsif(enable = '1') then
		if(selection = '1' and mem_select = '0') then
		choix <= not(choix);
		end if;
		case etat_present is 
			when Init => if rotation = "00" then etat_futur<= Debut;
							else etat_futur<= Init;
							end if;
							
			when Debut => if rotation = "01" then etat_futur<= Horaire;
							elsif rotation = "10" then etat_futur<= Trigo;
							else etat_futur<= Debut;
							end if;
							
			when Horaire => if rotation = "01" then etat_futur<= Horaire;
								 elsif rotation = "11" then etat_futur<= Incre;
								 elsif rotation = "10" then etat_futur<= Debut;
								 elsif rotation = "00" then etat_futur<= Debut;
								 else etat_futur<= Horaire;
								 end if;
			
			when Trigo => if rotation = "10" then etat_futur<= Trigo;
								 elsif rotation = "11" then etat_futur<= Decre;
								 elsif rotation = "01" then etat_futur<= Debut;
								 elsif rotation = "00" then etat_futur<= Debut;
								 else etat_futur<= Trigo;
								 end if;
								 
			when Incre => etat_futur<= Attente_h;
			
			when Decre => etat_futur<= Attente_t;
			
		   when Attente_h => if rotation = "00" then etat_futur<= Debut;
							  elsif rotation = "01" then etat_futur<= Trigo;
							  else etat_futur<= Attente_h;
							  end if;
							  
							  
		   when Attente_t => if rotation = "00" then etat_futur<= Debut;
							  elsif rotation = "10" then etat_futur<= Horaire;
							  else etat_futur<= Attente_t;
							  end if;
		end case;
	else etat_futur <= Init;
	end if;
	mem_select <= selection;
	end process calcul_etat_futur;
	
calcul_etat_present: process(H)
begin
	if(H'event and H='1') then 
		etat_present<= etat_futur;
	end if;

end process calcul_etat_present;
	
calcul_sortie : process(etat_present)
begin	
	case etat_present is
					when Incre => if(choix = '0') then
										if (inter_heure = "10111") then inter_heure <= "00000";
										else inter_heure <= heure + 1;
										end if;
										change_heure <= '1';
										change_minute<= '0';
										inter_minute <= minute;
									else
										if (inter_minute = "111011") then inter_minute <= "000000";
										else inter_minute <= minute + 1;
										end if;
										change_heure <= '0';
										change_minute<= '1';
										inter_heure <= heure;
									end if;
					when Decre => if(choix = '0') then
										if (inter_heure = "00000") then inter_heure <= "10111";
										else inter_heure <= heure - 1;
										end if;
										change_heure <= '1';
										change_minute<= '0';
										inter_minute <= minute;
									else
										if (inter_minute = "000000") then inter_minute <= "111011";
										else inter_minute <= minute - 1;
										end if;
										change_heure <= '0';
										change_minute<= '1';
										inter_heure <= heure;
									end if;
					when others => inter_heure <= heure;
									inter_minute <= minute;
									change_heure <= '0';
									change_minute <= '0';
	end case;	
end process calcul_sortie;

set_heure <= inter_heure;
set_minute <= inter_minute;
					
end Behavioral;