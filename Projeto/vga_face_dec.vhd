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

library work;
use work.all;  

entity vga_face_dec is
  port( 
		-- Estado do botao esquerdo do mouse
		
		mouse_click_l : in  std_logic;
		
		-- Estado do jogo
		
		game_state : in  std_logic_vector(1 downto 0);
		
		-- Tipo do elemento e indice na ROM
	
		element : in std_logic_vector (7 downto 0);
		elemidx : out std_logic_vector (5 downto 0)
	);
end entity;

architecture vga_face_dec_logic of vga_face_dec is
	signal sel : std_logic_vector (2 downto 0);
	signal mode : std_logic_vector (1 downto 0);
begin

	sel <= game_state & mouse_click_l;
	with sel select
		mode <=
			"01" when "001",
			
			"10" when "100",
			"10" when "101",
			
			"11" when "110",
			"11" when "111",
			
			"00" when others;

	elemidx <= "01" & element(1 downto 0) & mode;

end;
