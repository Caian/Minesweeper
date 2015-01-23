---------------------------------------------------------
-- MC613 - UNICAMP
--
-- Minesweeper
--
-- Caian Benedicto
-- Brunno Rodrigues Arangues
---------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity game_timeclock is
	port( clk24, rstn : in  std_logic;
		  clk1        : out std_logic
	);
end;

architecture game_timeclock_logic of game_timeclock is
begin 
	
	process(clk24, rstn)
		constant F_HZ : integer := 1;
		constant DIVIDER : integer := 24000000/F_HZ;
		variable count : integer range 0 to DIVIDER := 0;		
	begin
		if rstn = '0' then
			count := 0;
			clk1 <= '0';
		elsif rising_edge(clk24) then
			if count < DIVIDER / 2 then
				clk1 <= '1';
			else 
				clk1 <= '0';
			end if;
			if count = DIVIDER then
				count := 0;
			end if;
			count := count + 1;			
		end if;
	end process;
	
end architecture;
