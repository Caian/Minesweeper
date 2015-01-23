---------------------------------------------------------
-- MC613 - UNICAMP
--
---------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ps2_mouse is
	port
	(
		------------------------	Clock Input	 	------------------------
		CLOCK_24 		: 	in STD_LOGIC_VECTOR (1 downto 0);	--	24 MHz
		
		------------------------	Push Button		------------------------
		KEY 			:	in STD_LOGIC_VECTOR (3 downto 0);		--	Pushbutton[3:0]

		------------------------	PS2		--------------------------------
		PS2_DAT 		:	inout STD_LOGIC;	--	PS2 Data
		PS2_CLK 		:	inout STD_LOGIC;	--	PS2 Clock
		
		Botoes			:	out STD_LOGIC_VECTOR (2 DOWNTO 0);
		
		x_out, y_out 	: 	out std_logic_vector(9 downto 0)
	);
end;

architecture struct of ps2_mouse is
	component mouse_ctrl
		generic(
			clkfreq : integer
		);
		port(
			ps2_data	:	inout	std_logic;
			ps2_clk		:	inout	std_logic;
			clk			:	in 	std_logic;
			en			:	in 	std_logic;
			resetn		:	in 	std_logic;
			newdata		:	out	std_logic;
			bt_on		:	out	std_logic_vector(2 downto 0);
			ox, oy		:	out std_logic;
			dx, dy		:	out	std_logic_vector(8 downto 0);
			wheel		: out	std_logic_vector(3 downto 0)
		);
	end component;
	
	signal signewdata, resetn 	: std_logic;
	signal dx, dy 				: std_logic_vector(8 downto 0);
	signal x, y 				: std_logic_vector(10 downto 0);
	signal x2, y2 				: std_logic_vector(10 downto 0);
	signal vazio				: std_logic_vector(5 downto 0);
	
	constant SENSIBILITY : integer := 2; -- Rise to decrease sensibility
begin 
	-- KEY(0) Reset
	resetn <= KEY(0);
	
	mousectrl : mouse_ctrl generic map (24000) port map(
		PS2_DAT, PS2_CLK, CLOCK_24(0), '1', KEY(0),
		signewdata, Botoes, vazio(5), vazio(4), dx, dy, vazio(3 downto 0)
	);
	
	-- Read new mouse data	
	process(signewdata, resetn)
		variable xacc, yacc : integer range -10000 to 10000;
	begin
		if(rising_edge(signewdata)) then
			x <= std_logic_vector(to_signed(to_integer(signed(x)) + ((xacc + to_integer(signed(dx))) / SENSIBILITY), 11));
			y <= std_logic_vector(to_signed(to_integer(signed(y)) + ((yacc + to_integer(signed(dy))) / SENSIBILITY), 11));
			xacc := ((xacc + to_integer(signed(dx))) rem SENSIBILITY);
			yacc := ((yacc + to_integer(signed(dy))) rem SENSIBILITY);
			if ((to_signed(to_integer(signed(x)), 11)) < 0) then
				x <= "00000000000";
			elsif ((to_signed(to_integer(signed(x)), 11)) > 640) then
				x <= "01010000000";
			else
				x2 <= x;
			end if;
			if ((to_signed(to_integer(signed(y)), 11)) < 0) then
				y <= "00000000000";
			elsif ((to_signed(to_integer(signed(y)), 11)) > 480) then
				y <= "00111100000";
			else
				y2 <= y;
			end if;
		end if;
		if resetn = '0' then
			xacc := 0;
			yacc := 0;
			x <= "00101000000";
			y <= "00011110000";
			x2 <= "00101000000";
			y2 <= "00011110000";
		end if;
	end process;
	
	x_out <= x2(9 downto 0);
	y_out <= y2(9 downto 0);
end struct;
