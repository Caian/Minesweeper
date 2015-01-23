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

entity counter is
port(	clock : in std_logic;
		rstn : in std_logic;
		enable : in std_logic;
--		mode : in std_logic;
		cnt_out : out std_logic_vector(9 downto 0)
	 );
end;

architecture logica of counter is
	signal count : std_logic_vector(9 downto 0);
begin
	process(clock, rstn, enable)
	begin
		if rstn = '0' then
			count <= (others => '0');
		elsif rising_edge(clock) and enable = '1' then
--			case mode is
--				when '1' =>
					case count is
						when "1111100111" => count <= "1111100111";
						when OTHERS => count <= count+1;
					end case;
--				when '0' =>
--					case count is
--						when "0000000000" => count <= "0000000000";
--						when OTHERS => count <= count-1;
--					end case;
--			end case;
		end if;
	end process;
	cnt_out <= count;
end architecture;
