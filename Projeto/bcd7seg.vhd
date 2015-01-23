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

entity bcd7seg is
port( entrada : in std_logic_vector(3 downto 0);
	  saida : out std_logic_vector(6 downto 0) );
end entity;

architecture logic of bcd7seg is
begin
	with entrada select
		saida <= not "0111111" when "0000", -- 0
				 not "0000110" when "0001", -- 1
				 not "1011011" when "0010", -- 2
				 not "1001111" when "0011", -- 3
				 not "1100110" when "0100", -- 4
				 not "1101101" when "0101", -- 5
				 not "1111101" when "0110", -- 6
				 not "0000111" when "0111", -- 7
				 not "1111111" when "1000", -- 8
				 not "1100111" when "1001", -- 9
				 not "0000000" when others; -- apagado
end architecture;
