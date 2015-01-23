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

entity vga_palette is
	port( index : in  std_logic_vector(3 downto 0);
		  pixel : out std_logic_vector(11 downto 0) );
end entity;

architecture vga_palette_logic of vga_palette is
begin
	with index select
		pixel <= 
			"111100001111" when "0000",
			"011100000111" when "0001",
			"000000001111" when "0010",
			"000000000111" when "0011",
			"000001110111" when "0100",
			"000001110000" when "0101",
			"111111110000" when "0110",
			"011101110000" when "0111",
			"111100000000" when "1000",
			"011100000000" when "1001",
			"011100000000" when "1010",
			"111111111111" when "1011",
			"101110111011" when "1100",
			"011101110111" when "1101",
			"000000000000" when "1110",
			"000000000000" when others; -- ?????
end;
