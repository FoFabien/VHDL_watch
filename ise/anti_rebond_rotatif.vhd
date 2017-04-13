----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:23:35 09/13/2010 
-- Design Name: 
-- Module Name:    filtre_antirebonds - Behavioral 
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

entity filtre_antirebonds is
Port ( e0 : in  STD_LOGIC;
      e1 : in  STD_LOGIC;
		reset : in  STD_LOGIC ; --actif sur front montant de l'horloge
	   H : in STD_LOGIC;
      s0 : out  STD_LOGIC;
      s1 : out  STD_LOGIC);
end filtre_antirebonds;

architecture Behavioral of filtre_antirebonds is

signal rot0 : STD_LOGIC;
signal rot1 : STD_LOGIC;

begin

filtre: process(H)
BEGIN
	if (H'event and H='1')
		then if (reset='1')
			then rot0<='0';
			     rot1<='0';
			elsif  (e0='0' and e1='0')
			then rot0<='0';
			     rot1<=rot1;
			elsif  (e0='0' and e1='1')
			then rot0<=rot0;
				  rot1<='1';
			elsif  (e0='1' and e1='0')
			then rot0<=rot0;
			     rot1<='0';
			elsif  (e0='1' and e1='1')
			then  rot0<='1';
				   rot1<=rot1;
			end if;
	end if;

end process filtre;	

s0 <= rot0;
s1 <= rot1;
	
end Behavioral;

