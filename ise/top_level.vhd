----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:02:05 12/07/2010 
-- Design Name: 
-- Module Name:    top_level - Behavioral 
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

entity top_level is
    Port ( H : in  STD_LOGIC;
			  reset : in STD_LOGIC;
           adjust : in  STD_LOGIC;
           selection : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           rot : in  STD_LOGIC_VECTOR (1 downto 0);
			  -- LIAISON SERIE
			  tx_female : out std_logic;
           rx_female : in  std_logic;
           leds : out std_logic_vector(7 downto 0);
           lcd_rw : out std_logic;
           lcd_e : out std_logic;
			  -- LCD
			  lcd_rs : OUT  std_ulogic;  -- command 0; data 1
			  --leds : OUT std_logic_vector(2 DOWNTO 0);
			  lcd : INOUT std_logic_vector(3 DOWNTO 0);  -- lcd en lecture/ecriture
			  strataflash_oe : OUT std_ulogic;  -- signaux flash
			  strataflash_we : OUT std_ulogic;  -- en paralelle
			  strataflash_ce : OUT std_ulogic);  -- sur lcd
end top_level;

architecture Behavioral of top_level is

component horloge is
    Port ( H : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  seconde : out  STD_LOGIC_VECTOR (5 downto 0);
			  minute : out STD_LOGIC_VECTOR (5 downto 0);
			  set_minute : in  STD_LOGIC_VECTOR (5 downto 0);
			  heure : out STD_LOGIC_VECTOR (4 downto 0);
			  set_heure : in  STD_LOGIC_VECTOR (4 downto 0);
			  H_seconde : out STD_LOGIC;
			  change_heure : in STD_LOGIC;
			  change_minute : in STD_LOGIC);
end component;

component alarme is
	Port ( H : in  STD_LOGIC;
			  reset : in STD_LOGIC;
           enable : in  STD_LOGIC;
           heure : in  STD_LOGIC_VECTOR (4 downto 0);
           minute : in  STD_LOGIC_VECTOR (5 downto 0);
           set_heure : in  STD_LOGIC_VECTOR (4 downto 0);
           set_minute : in  STD_LOGIC_VECTOR (5 downto 0);
           selection : in  STD_LOGIC;
			  alarme_active : out STD_LOGIC;
           signal_alarme : out  STD_LOGIC);
end component;

component chronometre is
	Port ( H : in  STD_LOGIC;
			 reset : in STD_LOGIC;
          enable : in  STD_LOGIC;
			 pulse_seconde : in  STD_LOGIC;
          heure_ecoule : out  STD_LOGIC_VECTOR (4 downto 0);
          minute_ecoule : out  STD_LOGIC_VECTOR (5 downto 0);
			 seconde_ecoule : out  STD_LOGIC_VECTOR (5 downto 0);
          selection : in  STD_LOGIC;
			 adjust : in STD_LOGIC;
			 etat_chrono : out STD_LOGIC);
end component;

component filtre_anti_rebond is
	port(
		entree, H, R : in std_logic;
		sortie : out std_logic
		);
end component;

component filtre_antirebonds is
	Port ( e0 : in  STD_LOGIC;
      e1 : in  STD_LOGIC;
		reset : in  STD_LOGIC ; --actif sur front montant de l'horloge
	   H : in STD_LOGIC;
      s0 : out  STD_LOGIC;
      s1 : out  STD_LOGIC);
end component;

component machine_etat is
    Port ( H : in  STD_LOGIC;
           mode : in  STD_LOGIC;
           adjust : in  STD_LOGIC;
           R : in  STD_LOGIC;
           state : out  STD_LOGIC_VECTOR (2 downto 0);
           enable_alarme : out  STD_LOGIC;
			  enable_chrono : out  STD_LOGIC;
           enable_reglage_h : out  STD_LOGIC;
           enable_reglage_a : out  STD_LOGIC);
end component;

component reglage_heure is
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
end component;

component Affichage_ROM_Indexee is
	PORT (
    reset : IN std_logic;     -- bouton reset
    clk : IN std_logic ;      -- Horloge carte 50 MHz
    switches : IN std_logic_vector(2 DOWNTO 0);  -- état sur 3 bits
    lcd_rs : OUT  std_ulogic;  -- command 0; data 1
    lcd_rw : OUT  std_ulogic;  -- read 1; write 0
    lcd_e : OUT  std_ulogic;  -- enable
    lcd : INOUT std_logic_vector(3 DOWNTO 0);  -- lcd en lecture/ecriture
    strataflash_oe : OUT std_ulogic;  -- signaux flash
    strataflash_we : OUT std_ulogic;  -- en paralelle
    strataflash_ce : OUT std_ulogic);  -- sur lcd
end component;

component DSP_Suite_Math_32Bits is
	Port (  tx_female : out std_logic;
           rx_female : in  std_logic;
           leds : out std_logic_vector(7 downto 0);
		     signal_reset : in  std_logic;
           clk : in  std_logic;
				-- Signaux externes
				-- Etat actuel
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
			  alarme_active : in STD_LOGIC);	
end component;

-- SIGNAUX
signal seconde : STD_LOGIC_VECTOR (5 downto 0);
signal minute : STD_LOGIC_VECTOR (5 downto 0);
signal heure : STD_LOGIC_VECTOR (4 downto 0);
signal set_minute : STD_LOGIC_VECTOR (5 downto 0);
signal set_heure : STD_LOGIC_VECTOR (4 downto 0);
signal H_seconde : STD_LOGIC;
signal enable_alarme : STD_LOGIC;
signal enable_chrono : STD_LOGIC;
signal enable_reglage_h : STD_LOGIC;
signal enable_reglage_a : STD_LOGIC;
signal alarme_minute : STD_LOGIC_VECTOR (5 downto 0);
signal alarme_heure : STD_LOGIC_VECTOR (4 downto 0);
signal seconde_ecoule : STD_LOGIC_VECTOR (5 downto 0);
signal minute_ecoule : STD_LOGIC_VECTOR (5 downto 0);
signal heure_ecoule : STD_LOGIC_VECTOR (4 downto 0);
signal selection_rebond : STD_LOGIC;
signal adjust_rebond : STD_LOGIC;
signal mode_rebond : STD_LOGIC;
signal rot_rebond : STD_LOGIC_VECTOR (1 downto 0);
signal alarme_active : STD_LOGIC;
signal signal_alarme : STD_LOGIC;
signal etat_chrono : STD_LOGIC;
signal state : STD_LOGIC_VECTOR (2 downto 0);
signal change_heure : STD_LOGIC;
signal change_minute : STD_LOGIC;
signal change_heure_a : STD_LOGIC;
signal change_minute_a : STD_LOGIC;

begin


uu1 : horloge 
    Port Map ( H => H,
			  reset => reset,
			  seconde => seconde,
			  minute => minute,
			  set_minute => set_minute,
			  heure => heure,
			  set_heure => set_heure,
			  H_seconde => H_seconde,
			  change_heure => change_heure,
			  change_minute => change_minute);
			  
uu2 : alarme
	Port Map ( H => H,
			  reset => reset,
           enable => enable_alarme,
           minute => minute,
			  set_minute => alarme_minute,
			  heure => heure,
			  set_heure => alarme_heure,
           selection => selection_rebond,
			  alarme_active => alarme_active,
           signal_alarme => signal_alarme);
			  
uu3 :  chronometre
	Port Map ( H => H,
			 reset => reset,
          enable => enable_chrono,
			 pulse_seconde => H_seconde,
          heure_ecoule => heure_ecoule,
          minute_ecoule => minute_ecoule,
			 seconde_ecoule => seconde_ecoule,
          selection => selection_rebond,
			 adjust => adjust_rebond,
			 etat_chrono => etat_chrono);
			 
uu4 : filtre_anti_rebond -- anti rebond poussoir pour MODE
	port map (
		entree => mode,
		H => H,
		R => reset,
		sortie => mode_rebond);
		
uu5 : filtre_anti_rebond -- anti rebond poussoir pour SELECT
	port map (
		entree => selection,
		H => H,
		R => reset,
		sortie => selection_rebond);
		
uu6 : filtre_anti_rebond -- anti rebond poussoir pour ADJUST
	port map (
		entree => adjust,
		H => H,
		R => reset,
		sortie => adjust_rebond);
		
uu7 : filtre_antirebonds -- anti rebond bouton ROTATIF
	Port Map (
		e0 => rot(0),
      e1 => rot(1),
		reset => reset,
	   H => H,
      s0 => rot_rebond(0),
      s1 => rot_rebond(1));
		
uu8 : machine_etat
    Port Map(
			H => H,
         mode => mode_rebond,
         adjust => adjust_rebond,
         R => reset,
         state => state,
         enable_alarme => enable_alarme,
			enable_chrono => enable_chrono,
         enable_reglage_h => enable_reglage_h,
         enable_reglage_a => enable_reglage_a);
			
uu9 : reglage_heure -- REGLAGE HEURE
    Port Map(
			H => H,
			reset => reset,
         enable => enable_reglage_h,
         selection => selection_rebond,
         heure => heure,
         minute => minute,
         rotation => rot_rebond,
         set_heure => set_heure,
         set_minute => set_minute,
			change_heure => change_heure,
			change_minute => change_minute);
			
uu10 : reglage_heure -- REGLAGE ALARME
    Port Map(
			H => H,
			reset => reset,
         enable => enable_reglage_a,
         selection => selection_rebond,
         heure => heure,
         minute => minute,
         rotation => rot_rebond,
         set_heure => alarme_heure,
         set_minute => alarme_minute,
			change_heure => change_heure_a,
			change_minute => change_minute_a);
			
uu11 : Affichage_ROM_Indexee
	PORT MAP(
    reset => reset,
    clk => H,
    switches => state,
    lcd_rs => lcd_rs,
    lcd_rw => lcd_rw,
    lcd_e => lcd_e,
    lcd => lcd,
    strataflash_oe => strataflash_oe,
    strataflash_we => strataflash_we,
    strataflash_ce => strataflash_ce);
	 
uu12 :  DSP_Suite_Math_32Bits
	Port Map(
			tx_female => tx_female,
         rx_female => rx_female,
         leds => leds,
		   signal_reset => reset,
         clk => H,
			state => state,
			reglage_heure_alarme => alarme_heure,
         reglage_minute_alarme => alarme_minute,
         heure => heure,
         minute => minute,
			seconde => seconde,
			chrono_heure => heure_ecoule,
         chrono_minute => minute_ecoule,
			chrono_seconde => seconde_ecoule,
			alarme_active => alarme_active);	
		
end Behavioral;

