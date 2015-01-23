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

entity minesweeper is
  port( clk27		: in  std_logic;
		rstn, rstg	: in  std_logic; --KEY[0]

		vga_hsync, vga_vsync	: out std_logic;
		vga_r, vga_g, vga_b		: out std_logic_vector(3 downto 0);
		 
		clk24	: in std_logic;
		
		num_mines : in std_logic_vector(8 downto 0);

		ps2_dat	: inout std_logic;
		ps2_clk	: inout std_logic;
		
		led	: buffer std_logic_vector(3 downto 0);
		
		display7_0, display7_1, display7_2, display7_3 : out std_logic_vector(6 downto 0)
	);
end entity;

architecture minesweeper_logic of minesweeper is
	
	signal vga_mem_clk: std_logic;
	signal vga_mem_addr: std_logic_vector(10 downto 0);
	signal vga_mem_q : std_logic_vector(7 downto 0);
	
	signal ctrlu_clock: std_logic;
	signal ctrlu_mem_addr: std_logic_vector(10 downto 0);
	signal ctrlu_mem_d : std_logic_vector(7 downto 0);
	signal ctrlu_mem_q : std_logic_vector(7 downto 0);
	signal ctrlu_mem_wren: std_logic;
	
	signal stack_data_in : std_logic_vector(13 downto 0);
	signal stack_data_out : std_logic_vector(13 downto 0);
	signal stack_mode : std_logic_vector(1 downto 0);
	signal stack_empty : std_logic;
	
	signal rng_enable : std_logic;
	signal rng_x, rng_y : std_logic_vector(4 downto 0);
	
	signal mouse_x, mouse_y : std_logic_vector(9 downto 0);
	
	signal game_state : std_logic_vector(1 downto 0);
	
	signal mdig1, mdig2, mdig3 : std_logic_vector(3 downto 0);
	signal clock1 : std_logic;
	signal tempo, minas : std_logic_vector(9 downto 0);
	signal tdig1, tdig2, tdig3 : std_logic_vector(3 downto 0);
	signal t_en : std_logic;
--	signal m_mode, m_en : std_logic;
	signal flagcnt : std_logic_vector(10 downto 0);
	signal ddig1, ddig2, ddig3 : std_logic_vector(3 downto 0);

begin

	ctrlu_clock <= clk27;

	------------------------------
	-- Unidade de controle do jogo
CTRLU: game_ctrlunit
		port map(
			
		clock => ctrlu_clock, --clock27
		rstn => rstn and rstg,
		
		ram_wren => ctrlu_mem_wren,
		ram_addr => ctrlu_mem_addr,
		ram_data_in => ctrlu_mem_d,
		ram_data_out => ctrlu_mem_q,
		
		stack_data_in => stack_data_in,
		stack_data_out => stack_data_out,
		stack_mode => stack_mode,
		stack_empty => stack_empty,
		
		rng_enable => rng_enable,
		rng_x => rng_x,
		rng_y => rng_y,
		
		timer_enable => t_en,
		
--		minecnt_enable => m_mode,
--		minecnt_mode => m_en,
		flagcnt => flagcnt,
		
		num_mines => num_mines,
		
		game_state => game_state,
		
		mouse_pos_x => mouse_x,
		mouse_pos_y => 480 - mouse_y,
		mouse_click_l => led(0),
		mouse_click_r => led(1)
	);

	------------------------------------
	-- Decodificador do número de bombas
BOMBAS: decoder port map(
		entrada => flagcnt,
		digito1 => mdig1,
		digito2 => mdig2,
		digito3 => mdig3
	);

	--------------------
	-- Contador de minas
--MINA: counter port map(
--		clock => '1',
--		rstn => rstn,
--		enable => '0',
--		mode => '0',
--		cnt_out => minas
--	);

	-------------------------------------------
	-- Decodificador do número do tempo passado
TEMPO_IN: decoder port map(
		entrada => '0' & tempo,
		digito1 => tdig1,
		digito2 => tdig2,
		digito3 => tdig3
	);

	--------------------
	-- Contador de tempo
RELOGIO: counter port map(
		clock => clock1,
		rstn => rstn and rstg,
		enable => t_en,
--		mode => '1',
		cnt_out => tempo
	);

	-------------------------------
	-- Unidade de controle do mouse
MOUSE: ps2_mouse port map(
	
		CLOCK_24 => "0" & clk24,
		
		KEY => "000" & rstn,

		PS2_DAT => ps2_dat,
		PS2_CLK => ps2_clk,
		
		Botoes => led(2 downto 0),
		
		x_out => mouse_x,
		y_out => mouse_y
	);

	-------------------------------------------
	-- Decodificador do número inicial de minas
DISPLAY: decoder port map(
		entrada => "00" & num_mines,
		digito1 => ddig1,
		digito2 => ddig2,
		digito3 => ddig3
	);

	--------------------------
	-- Displays de 7 segmentos
DISPLAY0: bcd7seg port map(
		entrada => ddig3,
		saida => display7_0
	);
DISPLAY1: bcd7seg port map(
		entrada => ddig2,
		saida => display7_1
	);
DISPLAY2: bcd7seg port map(
		entrada => ddig1,
		saida => display7_2
	);
DISPLAY3: bcd7seg port map(
		entrada => "1111",
		saida => display7_3
	);

	---------------------------------------
	-- Gerador de numeros pseudo aleatorios
PRNG: game_lfsr port map(
		
		clock => ctrlu_clock,
		rstn => rstn and rstg,
		enabled => rng_enable,
		
		mouse_pos_x => mouse_x,
		mouse_pos_y => mouse_y,
		
		random_x => rng_x,
		random_y => rng_y
		
	);

	--------------------
	-- Memoria principal
MAINRAM: ram port map(

		address_a => ctrlu_mem_addr,
		address_b => vga_mem_addr,
		clock_a => ctrlu_clock,
		clock_b => vga_mem_clk,
		data_a => ctrlu_mem_d,
		data_b => "00000000",
		wren_a => ctrlu_mem_wren,
		wren_b => '0',
		q_a => ctrlu_mem_q,
		q_b => vga_mem_q
	);

	--------------------
	-- Pilha da recursao
STEAK: stack port map(

		enable => '1', 
		rstn => rstn, 
		clock => ctrlu_clock,
		mode => stack_mode,
		data => stack_data_in,
		empty => stack_empty,
		
		q => stack_data_out
	);

	-----------------------
	-- Controlador de video	
VGASYS: vga port map (
		
		clk_27Mhz => clk27, 
		rstn => rstn,
		
		main_mem_clk => vga_mem_clk,
		main_mem_addr => vga_mem_addr,
		main_mem_data => vga_mem_q,
		
		mouse_pos_x => mouse_x,
		mouse_pos_y => 480 - mouse_y,
		mouse_click_l => led(0),
		
		time_u => mdig3, 
		time_d => mdig2,
		time_c => mdig1,
		
		mine_u => tdig3,
		mine_d => tdig2,
		mine_c => tdig1,
		
		game_state => game_state,
		
		vga_hsync => vga_hsync,
		vga_vsync => vga_vsync,
		vga_r => vga_r,
		vga_g => vga_g,
		vga_b => vga_b
	);

	--------------------------
	-- Gerador de clock de 1Hz
CNT1HZ: game_timeclock port map (

	clk24 => clk24,
	rstn => rstn,
	clk1 => clock1
);

end;
