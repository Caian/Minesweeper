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

entity vga is
  port (
	
	-- Comum
	
	clk_27Mhz, rstn : in std_logic;
	
	-- Conexao com a memoria
	
	main_mem_clk  : out std_logic;
	main_mem_addr : out std_logic_vector(10 downto 0);
	main_mem_data : in  std_logic_vector(7 downto 0);
	
	-- Conexao com o mouse
	
	mouse_pos_x   : in  std_logic_vector(9 downto 0);
	mouse_pos_y   : in  std_logic_vector(9 downto 0);
	mouse_click_l : in  std_logic;
	
	-- Conexao com o controlador jogo
	
	time_u, time_d, time_c : in std_logic_vector (3 downto 0);
	mine_u, mine_d, mine_c : in std_logic_vector (3 downto 0);
	
	game_state : in  std_logic_vector(1 downto 0);
	
	-- Conexao com o monitor
	
	vga_hsync, vga_vsync : out std_logic;
	vga_r, vga_g, vga_b  : out std_logic_vector(3 downto 0)
	
	);
end entity;

architecture vga_logic of vga is

	signal gfx_x, gfx_y       : std_logic_vector(3 downto 0);
	signal gfx_elem           : std_logic_vector(5 downto 0);
	signal gfx_data           : std_logic_vector(3 downto 0);
	
	signal mouse_data		  : std_logic_vector(3 downto 0);
	signal mouse_visible	  : std_logic;
	
	signal vga_data			  : std_logic_vector(3 downto 0);
	
	signal h_count, h_count_d : std_logic_vector(9 downto 0);
	signal v_count, v_count_d : std_logic_vector(9 downto 0);
	
	signal vga_clk : std_logic;
	
begin

main_mem_clk  <= vga_clk;
main_mem_addr <= v_count(8 downto 4) & h_count(9 downto 4);

ELEMDEC: vga_elem_dec port map (main_mem_data, 
		v_count_d(3 downto 0), h_count_d(3 downto 0),
		time_u, time_d, time_c, mine_u, mine_d, mine_c,
		mouse_click_l, game_state, gfx_x, gfx_y, gfx_elem);
		
MOUSEDEC: vga_mouse_dec port map (h_count_d, v_count_d,
		mouse_pos_x, mouse_pos_y, mouse_data, mouse_visible);
		
COMPOSER: vga_data <= mouse_data when mouse_visible = '1' else gfx_data;

GFXROM: gfx port map (gfx_elem & gfx_y & gfx_x, vga_clk, gfx_data);

VGACOUNT: vga_counter port map (clk_27Mhz, rstn, vga_data, 
		vga_hsync, vga_vsync, vga_r, vga_g, vga_b, vga_clk,
		h_count, h_count_d, v_count, v_count_d);
		
end architecture;
