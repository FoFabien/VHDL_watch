-------------------------------------------------------------------------------
-- Title      : package caracteres ascii
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ascii_pack.vhd
-- Author     :   <nouel@AINHOA>
-- Company    : 
-- Last update: 2006/09/25
-- Platform   : 
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2006/09/20  1.0      nouel	Created
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- ATTENTION : les identificateurs sont simplifies afin de faciliter l'ecriture
--           : il pourrait y avoir conflit avec d'autres identificateurs identiques 

-- ps rentre en conflit avec pico seconde. ps est remplace par s_min

PACKAGE ascii_pack IS
 -- minuscules
CONSTANT pa : std_logic_vector(7 DOWNTO 0) := x"61";  -- a  minuscule
CONSTANT pb : std_logic_vector(7 DOWNTO 0) := x"62";  -- b  minuscule
CONSTANT pc : std_logic_vector(7 DOWNTO 0) := x"63";  -- c  minuscule
CONSTANT pd : std_logic_vector(7 DOWNTO 0) := x"64";  -- c  minuscule
CONSTANT pe : std_logic_vector(7 DOWNTO 0) := x"65";
CONSTANT pf : std_logic_vector(7 DOWNTO 0) := x"66";
CONSTANT pg : std_logic_vector(7 DOWNTO 0) := x"67";
CONSTANT ph : std_logic_vector(7 DOWNTO 0) := x"68";
CONSTANT pi : std_logic_vector(7 DOWNTO 0) := x"69";
CONSTANT pj : std_logic_vector(7 DOWNTO 0) := x"6A";
CONSTANT pk : std_logic_vector(7 DOWNTO 0) := x"6B";
CONSTANT pl : std_logic_vector(7 DOWNTO 0) := x"6C";
CONSTANT pm : std_logic_vector(7 DOWNTO 0) := x"6D";
CONSTANT pn : std_logic_vector(7 DOWNTO 0) := x"6E";
CONSTANT po : std_logic_vector(7 DOWNTO 0) := x"6F";
CONSTANT pp : std_logic_vector(7 DOWNTO 0) := x"70";
CONSTANT pq : std_logic_vector(7 DOWNTO 0) := x"71";
CONSTANT pr : std_logic_vector(7 DOWNTO 0) := x"72";
CONSTANT s_min : std_logic_vector(7 DOWNTO 0) := x"73";  -- conflit avec ps
CONSTANT pt : std_logic_vector(7 DOWNTO 0) := x"74";
CONSTANT pu : std_logic_vector(7 DOWNTO 0) := x"75";
CONSTANT pv : std_logic_vector(7 DOWNTO 0) := x"76";
CONSTANT pw : std_logic_vector(7 DOWNTO 0) := x"77";
CONSTANT px : std_logic_vector(7 DOWNTO 0) := x"78";
CONSTANT py : std_logic_vector(7 DOWNTO 0) := x"79";
CONSTANT pz : std_logic_vector(7 DOWNTO 0) := x"7A"; -- z  minuscule
-- majuscules
CONSTANT Ga : std_logic_vector(7 DOWNTO 0) := x"41";  -- A  majuscule
CONSTANT Gb : std_logic_vector(7 DOWNTO 0) := x"42"; 
CONSTANT Gc : std_logic_vector(7 DOWNTO 0) := x"43";  
CONSTANT Gd : std_logic_vector(7 DOWNTO 0) := x"44";  
CONSTANT Ge : std_logic_vector(7 DOWNTO 0) := x"45";
CONSTANT Gf : std_logic_vector(7 DOWNTO 0) := x"46";
CONSTANT Gg : std_logic_vector(7 DOWNTO 0) := x"47";
CONSTANT Gh : std_logic_vector(7 DOWNTO 0) := x"48";
CONSTANT Gi : std_logic_vector(7 DOWNTO 0) := x"49";
CONSTANT Gj : std_logic_vector(7 DOWNTO 0) := x"4A";
CONSTANT Gk : std_logic_vector(7 DOWNTO 0) := x"4B";
CONSTANT Gl : std_logic_vector(7 DOWNTO 0) := x"4C";
CONSTANT Gm : std_logic_vector(7 DOWNTO 0) := x"4D";
CONSTANT Gn : std_logic_vector(7 DOWNTO 0) := x"4E";
CONSTANT Go : std_logic_vector(7 DOWNTO 0) := x"4F";
CONSTANT Gp : std_logic_vector(7 DOWNTO 0) := x"50";
CONSTANT Gq : std_logic_vector(7 DOWNTO 0) := x"51";
CONSTANT Gr : std_logic_vector(7 DOWNTO 0) := x"52";
CONSTANT Gs : std_logic_vector(7 DOWNTO 0) := x"53";
CONSTANT Gt : std_logic_vector(7 DOWNTO 0) := x"54";
CONSTANT Gu : std_logic_vector(7 DOWNTO 0) := x"55";
CONSTANT Gv : std_logic_vector(7 DOWNTO 0) := x"56";
CONSTANT Gw : std_logic_vector(7 DOWNTO 0) := x"57";
CONSTANT Gx : std_logic_vector(7 DOWNTO 0) := x"58";
CONSTANT Gy : std_logic_vector(7 DOWNTO 0) := x"59";
CONSTANT Gz : std_logic_vector(7 DOWNTO 0) := x"5A"; -- Z majuscule
-- chiffres
CONSTANT c0 : std_logic_vector(7 DOWNTO 0) := x"30";
CONSTANT c1 : std_logic_vector(7 DOWNTO 0) := x"31";
CONSTANT c2 : std_logic_vector(7 DOWNTO 0) := x"32";
CONSTANT c3 : std_logic_vector(7 DOWNTO 0) := x"33";
CONSTANT c4 : std_logic_vector(7 DOWNTO 0) := x"34";
CONSTANT c5 : std_logic_vector(7 DOWNTO 0) := x"35";
CONSTANT c6 : std_logic_vector(7 DOWNTO 0) := x"36";
CONSTANT c7 : std_logic_vector(7 DOWNTO 0) := x"37";
CONSTANT c8 : std_logic_vector(7 DOWNTO 0) := x"38";
CONSTANT c9 : std_logic_vector(7 DOWNTO 0) := x"39";
-- autres
CONSTANT deuxpoints : std_logic_vector(7 DOWNTO 0) := x"3A";  --    :
CONSTANT point : std_logic_vector(7 DOWNTO 0) := x"2E";  --    .
CONSTANT pointvirgule : std_logic_vector(7 DOWNTO 0) := x"3B";  --    ;
CONSTANT moins : std_logic_vector(7 DOWNTO 0) := x"2D";  --    -
CONSTANT slash : std_logic_vector(7 DOWNTO 0) := x"2F";  --    /
CONSTANT plus : std_logic_vector(7 DOWNTO 0) := x"2B";  --  + 
CONSTANT virgule : std_logic_vector(7 DOWNTO 0) := x"2B";  --    ,
CONSTANT plusgrand : std_logic_vector(7 DOWNTO 0) := x"3E";  --    >
CONSTANT pluspetit : std_logic_vector(7 DOWNTO 0) := x"3C";  --    <
CONSTANT egal : std_logic_vector(7 DOWNTO 0) := x"3D";  --    =
CONSTANT espace : std_logic_vector(7 DOWNTO 0) := x"20";  -- 
CONSTANT retour : std_logic_vector(7 DOWNTO 0) := x"0D";  -- carriage return
CONSTANT interrogation : std_logic_vector(7 DOWNTO 0) := x"3F";  --   ?
CONSTANT dollar : std_logic_vector(7 DOWNTO 0) := x"24";  --   $
CONSTANT exclamation : std_logic_vector(7 DOWNTO 0) := x"21";  --    !!
CONSTANT pard : std_logic_vector(7 DOWNTO 0) := x"29";  --   )
CONSTANT parg : std_logic_vector(7 DOWNTO 0) := x"28";  --   (


END ascii_pack;
