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

entity game_lfsr is
  port(
		-- Comum
		
		clock, rstn, enabled : in  std_logic;
		
		-- Estado do mouse
		
		mouse_pos_x, mouse_pos_y : in std_logic_vector(9 downto 0);
		
		-- Saida
		
		random_x, random_y : out std_logic_vector(4 downto 0)
	);
end entity;

architecture game_lfsr_logic of game_lfsr is
	
	signal seed : std_logic_vector(31 downto 0) := 
		"10101100011111110100010011010110";
	signal mix : std_logic_vector(31 downto 0);
	
	signal reg0 : std_logic_vector(3 downto 0);
	signal reg1 : std_logic;
	signal reg2 : std_logic;
	signal reg3 : std_logic_vector(24 downto 0);
	signal reg4 : std_logic;
	
begin

	random_x <= reg0(3) & reg3(15) & reg3(18) & reg3(9) & reg4;
	random_y <= reg3(23) & reg3(17) & reg3(7) & reg3(1) & reg1;

	mix(0)  <= mouse_pos_x(7) xor mouse_pos_y(2);
	mix(1)  <= mouse_pos_x(6) xor mouse_pos_y(6);
	mix(2)  <= mouse_pos_x(2) xor mouse_pos_y(7);
	mix(3)  <= mouse_pos_x(4) xor mouse_pos_y(4);
	mix(4)  <= mouse_pos_x(3) xor mouse_pos_y(8);
	mix(5)  <= mouse_pos_x(4) xor mouse_pos_y(2);
	mix(6)  <= mouse_pos_x(5) xor mouse_pos_y(5);
	mix(7)  <= mouse_pos_x(7) xor mouse_pos_y(3);
	mix(8)  <= mouse_pos_x(8) xor mouse_pos_y(6);
	mix(9)  <= mouse_pos_x(2) xor mouse_pos_y(3);
	mix(10) <= mouse_pos_x(3) xor mouse_pos_y(2);
	mix(11) <= mouse_pos_x(5) xor mouse_pos_y(1);
	mix(12) <= mouse_pos_x(7) xor mouse_pos_y(1);
	mix(13) <= mouse_pos_x(2) xor mouse_pos_y(9);
	mix(14) <= mouse_pos_x(3) xor mouse_pos_y(0);
	mix(15) <= mouse_pos_x(1) xor mouse_pos_y(7);
	mix(16) <= mouse_pos_x(1) xor mouse_pos_y(8);
	mix(17) <= mouse_pos_x(3) xor mouse_pos_y(6);
	mix(18) <= mouse_pos_x(5) xor mouse_pos_y(4);
	mix(19) <= mouse_pos_x(7) xor mouse_pos_y(3);
	mix(20) <= mouse_pos_x(5) xor mouse_pos_y(6);
	mix(21) <= mouse_pos_x(3) xor mouse_pos_y(8);
	mix(22) <= mouse_pos_x(7) xor mouse_pos_y(1);
	mix(23) <= mouse_pos_x(9) xor mouse_pos_y(2);
	mix(24) <= mouse_pos_x(2) xor mouse_pos_y(3);
	mix(25) <= mouse_pos_x(3) xor mouse_pos_y(6);
	mix(26) <= mouse_pos_x(4) xor mouse_pos_y(7);
	mix(27) <= mouse_pos_x(6) xor mouse_pos_y(5);
	mix(28) <= mouse_pos_x(8) xor mouse_pos_y(4);
	mix(29) <= mouse_pos_x(3) xor mouse_pos_y(8);
	mix(30) <= mouse_pos_x(6) xor mouse_pos_y(9);
	mix(31) <= mouse_pos_x(1) xor mouse_pos_y(3);

	process(clock, rstn)
	begin
		
		if rstn = '0' then

			reg0  <= seed(3 downto 0);
			reg1  <= seed(4);
			reg2  <= seed(5);
			reg3  <= seed(30 downto 6);
			reg4  <= seed(31);

		elsif rising_edge(clock) then
		
			seed <= seed + mix;
		
			if enabled = '1' then
			
				reg4 <= reg0(0);
				reg3 <= (reg4 xor reg0(0)) & reg3(24 downto 1);
				reg2 <= (reg3(0) xor reg0(0));
				reg1 <= (reg2 xor reg0(0));
				reg0 <= (reg1 xor reg0(0)) & reg0(3 downto 1);
			
			else
				
				reg0  <= seed(3 downto 0);
				reg1  <= seed(4);
				reg2  <= seed(5);
				reg3  <= seed(30 downto 6);
				reg4  <= seed(31);
				
			end if;
			
		end if;
		
	end process;

end architecture;
