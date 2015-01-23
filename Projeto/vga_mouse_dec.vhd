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
use ieee.std_logic_signed.all;

entity vga_mouse_dec is
	port(
			-- Pixel atual a ser desenhado
			
			vga_x, vga_y      : in  std_logic_vector(9 downto 0);
			
			-- Posicao atual do mouse
			
			mouse_pos_x, mouse_pos_y  : in  std_logic_vector(9 downto 0);
			
			-- Indice da cor do mouse na paleta de cores 
			
			mouse_color_index : out std_logic_vector(3 downto 0);
			
			-- Indica se o pixel pertence ao mouse
			
			mouse_visible     : out std_logic
	 );
end entity;

architecture vga_mouse_dec_logic of vga_mouse_dec is
	signal subx, suby : std_logic_vector(10 downto 0);
begin

	subx <= ('0' & vga_x) - ('0' & mouse_pos_x);
	suby <= ('0' & vga_y) - ('0' & mouse_pos_y);

	process (subx, suby)
	begin

		if subx >= 0 and subx < 12 and suby >= 0 and suby < 20 then

			case subx(3 downto 0) & suby(4 downto 0) is
				when "000000000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000000001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000100001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000000010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000100010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001000010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000000011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000100011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001000011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001100011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000000100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000100100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001000100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001100100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010000100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000000101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000100101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001000101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001100101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010000101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010100101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000000110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000100110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001000110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001100110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010000110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010100110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011000110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000000111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000100111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001000111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001100111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010000111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010100111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011000111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011100111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000001000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000101000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001001000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001101000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010001000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010101000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011001000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011101000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100001000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000001001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000101001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001001001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001101001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010001001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010101001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011001001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011101001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100001001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100101001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000001010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000101010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001001010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001101010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010001010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010101010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011001010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011101010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "100001010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "100101010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "101001010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000001011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000101011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001001011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001101011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "010001011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "010101011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011001011" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000001100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000101100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "001001100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "010001100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "010101100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011001100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011101100" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000001101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000101101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "010001101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "010101101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011001101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011101101" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "000001110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "010101110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011001110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011101110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100001110" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "010101111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011001111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "011101111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100001111" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011010000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011110000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100010000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100110000" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011010001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011110001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100010001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1011";
				when "100110001" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "011110010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when "100010010" =>
					mouse_visible <= '1';
					mouse_color_index <= "1110";
				when others =>
					mouse_visible <= '0';
					mouse_color_index <= "1111";
			end case;

		else
			mouse_visible <= '0';
			mouse_color_index <= "1111";
		end if;

	end process;

end architecture;
