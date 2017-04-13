
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity filtre_anti_rebond is
	port(
		entree, H, R : in std_logic;
		sortie : out std_logic
		);
end filtre_anti_rebond;
				
architecture structurelle of filtre_anti_rebond is
	component sequenceur
		port(
			fin_comptage, entree, H, R : in std_logic;
			comptage, sortie : out std_logic
			);
	end component;
	
	component compteur
		port(
			comptage, H : in std_logic;
			fin_comptage : out std_logic
			);
	end component;
	
	signal comptage : std_logic;
	signal fin_comptage : std_logic;
	
	begin
		U0:sequenceur
			port map(entree=>entree, H=>H, R=>R, fin_comptage=>fin_comptage, comptage=>comptage, sortie=>sortie);
		U1:compteur
			port map(H=>H, fin_comptage=>fin_comptage, comptage=>comptage);
			
end structurelle;