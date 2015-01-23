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

entity vga_game_dec is
  port( 
		-- Estado do jogo
		
		game_state : in  std_logic_vector (1 downto 0);
		
		-- Tipo do elemento e indice na ROM
		
		element    : in  std_logic_vector (7 downto 0);
		elemidx    : out std_logic_vector (5 downto 0)
	);
end entity;

architecture vga_game_dec_logic of vga_game_dec is
	signal w, e, f, c, m : std_logic;
begin

	-- Vitoria
	w <= game_state(0);
	
	-- Fim do jogo
	e <= game_state(1);
	
	-- Elemento mina
	m <= '1' when element(3 downto 0) = "1111" else '0';
	
	f <= element(4);
	c <= element(5);

	process (w, e, f, c, m)
	begin
	
		if ((not c and not e and not f and not w) or 
		    (not c and not f and not m and not w)) = '1' then
		
			-- Bloco fechado
			elemidx <= "001001";
		
		elsif ((c and e and not f and not m) or 
		       (c and not f and not m and not w)) = '1' then
	
			-- Bloco de numero
			elemidx <= "00" & element(3 downto 0);
		
		elsif (c and not f and m and not w) = '1' then
		
			-- Explosao
			elemidx <= "001101";
		
		elsif ((not c and e and f and m) or
			   (not c and e and m and w) or
			   (not c and not e and f and not w)) = '1' then
	
			-- Bandeira
			elemidx <= "001010";
		
		elsif (not c and e and not f and m and not w) = '1' then
	
			-- Mina
			elemidx <= "001011";
		
		elsif (not c and e and f and not m and not w) = '1' then
	
			-- Bandeira errada
			elemidx <= "001100";
		
		else
				
			-- Situacao de erro
			elemidx <= "001110";
			
		end if;
	
	end process;
	
end architecture;
