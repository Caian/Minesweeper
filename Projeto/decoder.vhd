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
use ieee.numeric_std.all;

entity decoder is
port( entrada : in std_logic_vector(10 downto 0);
	  digito1 : out std_logic_vector(3 downto 0);
	  digito2 : out std_logic_vector(3 downto 0);
	  digito3 : out std_logic_vector(3 downto 0)
	 );
end;

architecture logica of decoder is
	signal temp : std_logic_vector(10 downto 0);
begin
	temp <= (others => '0') when (to_integer(signed(entrada)) < 0) else entrada;
	digito1 <= std_logic_vector(to_unsigned(to_integer(unsigned(temp))/100,4));
	digito2 <= std_logic_vector(to_unsigned(((to_integer(unsigned(temp)) rem 100)-(to_integer(unsigned(temp)) rem 10))/10,4));
	digito3 <= std_logic_vector(to_unsigned(to_integer(unsigned(temp)) rem 10,4));
end architecture;
