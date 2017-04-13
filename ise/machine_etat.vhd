----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:13:14 11/09/2010 
-- Design Name: 
-- Module Name:    machine_etat - Behavioral 
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

entity machine_etat is
    Port ( H : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           adjust : in  STD_LOGIC;
           R : in  STD_LOGIC;
           state : out  STD_LOGIC_VECTOR (2 downto 0);
           enable_alarme : out  STD_LOGIC;
			  enable_chrono : out  STD_LOGIC;
           enable_reglage_h : out  STD_LOGIC;
           enable_reglage_a : out  STD_LOGIC);
end machine_etat;

architecture Behavioral of machine_etat is

type etats is (Init, Heure, Alarme, Chrono, Reglage_h, Reglage_a);
signal etat_present, etat_futur : etats;
signal signal_etat : STD_LOGIC_VECTOR (2 downto 0);
signal signal_enable : STD_LOGIC_VECTOR (3 downto 0);

begin

calcul_etat_futur : process(R, mode, adjust)
begin

	if R = '1' then
		etat_futur<=Init;
	else
		case etat_present is
			when Init => etat_futur <= Heure;
			when Heure => if adjust = '1' then
									etat_futur <= Reglage_h;
							  elsif mode = '1' then
									etat_futur <= Alarme;
							  else etat_futur <= Heure;
							  end if;
			when Alarme => if adjust = '1' then
									etat_futur <= Reglage_a;
							  elsif mode = '1' then
									etat_futur <= Chrono;
							  else etat_futur <= Alarme;
							  end if;
			when Chrono => if mode = '1' then
									etat_futur <= Heure;
							  else etat_futur <= Chrono;
							  end if;
			when Reglage_h => if adjust = '1' then
									etat_futur <= Heure;
							  else etat_futur <= Reglage_h;
							  end if;	
			when Reglage_a => if adjust = '1' then
									etat_futur <= Alarme;
							  else etat_futur <= Reglage_a;
							  end if;
		end case;
	end if;
end process calcul_etat_futur;


calcul_etat_present: process(etat_futur, H)
begin
	if(H'event and H='1') then 
				etat_present <= etat_futur;
	end if;
end process calcul_etat_present;

calcul_sortie : process (etat_present)
begin
	case etat_present is
		when Init => signal_etat <= "000";
						 signal_enable <= "0000";
		when Heure => signal_etat <= "001";
						  signal_enable <= "0000";
		when Alarme => signal_etat <= "010";
						  signal_enable <= "0001";
		when Chrono => signal_etat <= "011";
						  signal_enable <= "0010";
		when Reglage_h => signal_etat <= "100";
						  signal_enable <= "0100";
		when Reglage_a => signal_etat <= "101";
						  signal_enable <= "1000";
	end case;

end process calcul_sortie;

state <= signal_etat;
enable_alarme <= signal_enable(0);
enable_chrono <= signal_enable(1);
enable_reglage_h <= signal_enable(2);
enable_reglage_a <= signal_enable(3);

end Behavioral;

