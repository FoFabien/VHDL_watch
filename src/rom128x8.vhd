-------------------------------------------------------------------------------
-- Title      : rom 128 octets
-- Project    : 
-------------------------------------------------------------------------------
-- File       : rom128x8.vhd
-- Author     :   <nouel@AINHOA>
-- Company    : 
-- Last update: 2006/10/13
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006/09/19  1.0      nouel	Created
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom128x8 IS  
  PORT (
    adresse : IN  std_logic_vector(6 DOWNTO 0);
    donnees : OUT std_logic_vector(7 DOWNTO 0));
END rom128x8;

USE work.ascii_pack.ALL;

ARCHITECTURE par_constante OF rom128x8 IS

  TYPE tableau IS ARRAY (0 TO 127) OF std_logic_vector(7 DOWNTO 0);

  CONSTANT rom : tableau := 
     -- Nombre de messages
     ( X"06",
     -- Affichage de l'Heure
     X"17", Ga, pf, pf, pi, pc, ph, pa, pg, pe, espace, pd, pe, espace, espace, espace, espace, pl, espace, Gh, pe, pu, pr, pe,
     -- Affichage de l'Alarme
     X"18", Ga, pf, pf, pi, pc, ph, pa, pg, pe, espace, pd, pe, espace, espace, espace, espace, pl, espace, Ga, pl, pa, pr, pm, pe,
     -- Mode Chronometre
     X"10", Gm, po, pd, pe, espace, Gc, ph, pr, po, pn, po, pm, pe, pt, pr, pe,
     -- Reglage Heure
     X"0D", Gr, pe, pg, pl, pa, pg, pe, espace, Gh, pe, pu, pr, pe,
	  -- Reglage Alarme
     X"0E", Gr, pe, pg, pl, pa, pg, pe, espace, Ga, pl, pa, pr, pm, pe,
	  -- Initialisation
	  X"0E", Gi, pn, pi, pt, pi, pa, pl, pi, s_min, pa, pt, pi, po, pn,
     OTHERS => x"00");
  
  SIGNAL adr : natural;
  
BEGIN  -- par_table
  
  adr <= to_integer(unsigned(adresse));
  
  donnees <= rom(adr);
 
 
END par_constante;
