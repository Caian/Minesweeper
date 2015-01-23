---------------------------------------------------------
-- MC613 - UNICAMP
--
-- Minesweeper
--
-- Caian Benedicto
-- Brunno Rodrigues Arangues
---------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity vga_num_dec is
  port( 
		-- Digitos do contador de tempo
	
		time_u, time_d, time_c : in std_logic_vector (3 downto 0);
		
		-- Digitos do contador de minas
		
		mine_u, mine_d, mine_c : in std_logic_vector (3 downto 0);
		
		-- Tipo do elemento e indice na ROM
		
		element : in std_logic_vector (7 downto 0);
		elemidx : out std_logic_vector (5 downto 0)
	);
end entity;

architecture vga_num_dec_logic of vga_num_dec is
	signal src : std_logic_vector (3 downto 0);
begin

	with element(2 downto 0) select
		src <=
			time_u  when "000",
			time_d  when "001",
			time_c  when "010",
			
			mine_u  when "011",
			mine_d  when "100",
			mine_c  when "101",
			"0000" when others;
			
	elemidx <= "1" & src & element(3);
end;

