-------------------------------------------------------------------------------
-- Title      : Interface LCD utilisant Picoblaze
-- Project    : 
-------------------------------------------------------------------------------
-- File       : topdesign2.vhd
-- Author     :   <nouel@AINHOA>
-- Company    : 
-- Last update: 2006/10/13
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006/07/18  1.0      nouel	Created
-------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
--
------------------------------------------------------------------------------------
--
--
ENTITY Affichage_ROM_Indexee IS
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
END Affichage_ROM_Indexee;
--
-------------------------------------------------------------------------------
ARCHITECTURE simple OF Affichage_ROM_Indexee IS

  
  COMPONENT embedded_kcpsm3 IS
      PORT (      port_id : OUT std_logic_vector(7 DOWNTO 0);
                  write_strobe : OUT std_logic;
                  read_strobe : OUT std_logic;
                  out_port : OUT std_logic_vector(7 DOWNTO 0);
                  in_port : IN std_logic_vector(7 DOWNTO 0);
                  interrupt : IN std_logic;
                  interrupt_ack : OUT std_logic;
                  reset : IN std_logic;
                  clk : IN std_logic);
  END COMPONENT;


  COMPONENT rom128x8
    PORT (
      adresse : IN  std_logic_vector(6 DOWNTO 0);
      donnees : OUT std_logic_vector(7 DOWNTO 0));
  END COMPONENT;

-------------------------------------------------------------------------------

-- Signals used to connect embedded_KCPSM3
--
  SIGNAL port_id :  std_logic_vector(7 DOWNTO 0);  -- sortie adresses picoblaze
  SIGNAL write_strobe : std_ulogic;     -- validation des ecrirures sen sortie
  SIGNAL read_strobe : std_ulogic; 
  SIGNAL out_port : std_logic_vector(7 DOWNTO 0);
  SIGNAL in_port :  std_logic_vector(7 DOWNTO 0);
  SIGNAL interrupt : std_ulogic;
  SIGNAL interrupt_ack : std_ulogic;
  SIGNAL lcd_in : std_logic_vector(7 DOWNTO 0);
  SIGNAL lcd_out : std_logic_vector(3 DOWNTO 0);
  SIGNAL lcd_reg : std_logic_vector(7 DOWNTO 0);
  SIGNAL lcd_drive : std_ulogic;
  SIGNAL rom_data :  std_logic_vector(7 DOWNTO 0);  -- sortie donnees rom
  SIGNAL autres_entrees : std_logic_vector(7 DOWNTO 0);  -- lcd et switches
  SIGNAL code_switche :  std_logic_vector(2 DOWNTO 0); -- code binaire correspondant au switche actif

--------------------------------------------------------------------------------
BEGIN

  -- eviter les conflits entre lcd et flash
  strataflash_oe <= '1';
  strataflash_we <= '1';  
  strataflash_ce <= '1';

  -- picoblaze avec rom
  p1 : embedded_KCPSM3 PORT MAP (
    port_id       => port_id,
    write_strobe  => write_strobe,
    read_strobe   => read_strobe,
    out_port      => out_port,
    in_port       => in_port,
    interrupt     => interrupt,
    interrupt_ack => interrupt_ack,
    reset         => reset,
    clk           => clk);


  -- NEW rom messages
  r1 : rom128x8 PORT MAP (
    adresse => port_id(6 DOWNTO 0),
    donnees => rom_data);
  
  
-- decouplage des entrees/sortie bidirectionnelles 

  lcd_in <= "0000" & lcd;

  lcd_e <= lcd_reg(0);
  lcd_rw <= lcd_reg(1);
  lcd_rs <= lcd_reg(2);
  lcd_drive <= lcd_reg(3);
  lcd <= lcd_reg(7 DOWNTO 4) WHEN lcd_drive = '1' ELSE "ZZZZ";

-------------------------
-- PARTIES A COMPLETER --
-------------------------
 
  -- 1) décodage des switches => code_switche
  -- seules les combinaisons de switches : 0000 , 0001,0010,0100,1000 sont possibles sinon on envois le message n°5
  
  code_switche <= switches;


  -- 3) multiplexage des entrées du picoblaze
  -- rom adresse 00 - 7F (port_id(7)='0')
  -- lcd_in adresse 80 - BF (port_id(7)='1' & port_id(6)='0')
  -- switch adresse C0 - FF (port_id(7)='1' & port_id(6)='1')
  in_port <= rom_data when port_id(7) = '0' else
				 lcd_in when (port_id(7) = '1' and port_id(6)='0') else
				 "00000" & code_switche when (port_id(7) = '1' and port_id(6)='1');


-----------------------------
-- FIN PARTIES A COMPLETER --
-----------------------------
  
  -- registre de sortie du lcd
  -- adresse A0
  regout: PROCESS
  BEGIN  -- PROCESS regin
    WAIT UNTIL rising_edge(clk);
    IF reset = '1'  THEN
      lcd_reg <= (OTHERS => '0');
    ELSIF write_strobe = '1' AND port_id = x"A0" THEN
      lcd_reg <= out_port;
    END IF;
  END PROCESS regout;
  


END simple;

