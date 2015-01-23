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

entity vga_elem_dec is
  port (
		 -- Tipo do elemento e posicao relativa
		 
		 element : in  std_logic_vector (7 downto 0);
		 vmod    : in  std_logic_vector (3 downto 0);
		 hmod    : in  std_logic_vector (3 downto 0);
	     
	     -- Contador de minas e tempo
	     
	     time_u, time_d, time_c : in std_logic_vector (3 downto 0);
	     mine_u, mine_d, mine_c : in std_logic_vector (3 downto 0);
	     
	     -- Estado do mouse
	     
	     mouse_click_l : in  std_logic;
	     
	     -- Estado do jogo
	     
	     game_state : in  std_logic_vector(1 downto 0);
	     
		 -- Posicao relativa e indice do elemento na ROM
		 
	     offsetx : out std_logic_vector (3 downto 0);
	     offsety : out std_logic_vector (3 downto 0);
	     elemidx : out std_logic_vector (5 downto 0)
	);
end entity;

architecture vga_elem_dec_logic of vga_elem_dec is
	signal struct, num, face, game : std_logic_vector (5 downto 0);
begin
	
STRDEC:	struct <= element(5 downto 0);
	
NUMDEC: vga_num_dec port map (time_u, time_d, time_c,
	mine_u, mine_d, mine_c, element, num);
	
FACEDEC: vga_face_dec port map (mouse_click_l, 
	game_state, element, face);

GAMEDEC: vga_game_dec port map (game_state, element, game);

	with element(7 downto 6) select
		elemidx <=
			struct when "00",
			game   when "01",
			face   when "10",
			num    when "11";
	
	offsetx	<= hmod;
	offsety	<= vmod;
end;
