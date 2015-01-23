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
use ieee.numeric_std.all;

library work;
use work.all;

entity game_ctrlunit is
  port(
		-- Comum
		
		clock, rstn : in  std_logic;
		
		-- Conexao com a memoria principal
		
		ram_data_out : in std_logic_vector(7 downto 0);
		ram_wren : out std_logic;
		ram_data_in : out std_logic_vector(7 downto 0);
		ram_addr : buffer std_logic_vector(10 downto 0);
		
		-- Conexao com a pilha

		stack_data_out : in std_logic_vector(13 downto 0);
		stack_empty : in std_logic;
		stack_mode : out std_logic_vector(1 downto 0);
		stack_data_in : buffer std_logic_vector(13 downto 0);
		
		-- Conexao com o RNG
		
		rng_x, rng_y : in std_logic_vector(4 downto 0);
		rng_enable : out std_logic;
		
		-- Conexao com o contador de tempo
		
		timer_enable : out std_logic;
		
		-- Conexao com o contador de minas
		
--		minecnt_enable : out std_logic;
--		minecnt_mode : out std_logic;
		flagcnt : buffer std_logic_vector(10 downto 0);
		
		num_mines : in std_logic_vector(8 downto 0);
		
		-- Estado do jogo
		
		game_state : buffer std_logic_vector(1 downto 0);
		
		-- Estado do mouse
		
		mouse_pos_x, mouse_pos_y : in std_logic_vector(9 downto 0);
		mouse_click_l, mouse_click_r : in std_logic
	);
end entity;

architecture game_ctrlunit_logic of game_ctrlunit is
	
	type State_type IS (
		S_0, 											-- Estado inicial
		S_IClr, S_IRng, S_IRdM, S_IChkM, S_IWrM, 		-- Geracao de minas
		S_IRdN, S_IChkN, S_IIncN, S_IWrN,				-- Geracao de vizinhos
		S_MW, S_MHL, S_MHR, S_MR, S_ML, S_MOpen,				-- Botoes do mouse
		S_SAmPush, S_SAmProc, S_SAmUpdate, S_SAmOpen,	-- SAm
		S_GameOver										-- Fim de jogo
	); 
	
	signal st : State_type;
	signal buttons_state : std_logic_vector(1 downto 0);
	
	--constant num_mines : natural := 20;
	constant num_field : natural := 672;
	
begin

	process(clock, rstn)
		
		variable lin : std_logic_vector(4 downto 0);
		variable col : std_logic_vector(5 downto 0);
		
		variable mines : integer range 0 to num_field;
		variable free  : integer range 0 to num_field;
		
		variable cnt : natural range 0 to 7;
		
	begin
	
	---------------------------------------------------------------------------
	-- Reset
	---------------------------------------------------------------------------
		if rstn = '0' then
			
			st 				<= S_0;
			ram_wren 		<= '0';
			ram_addr 		<= (others => '0');
			ram_data_in 	<= (others => '0');
			stack_mode 		<= "00";
			stack_data_in 	<= (others => '0');
			
			buttons_state	<= "00";
			game_state		<= "00";
			
			rng_enable		<= '0';
			timer_enable	<= '0';
--			minecnt_enable	<= '0';
--			minecnt_mode	<= '0';
			flagcnt <= "00" & num_mines;
			
			lin	:= "00111";
			col	:= "000100";
			
			mines := to_integer(unsigned(num_mines));
			free := num_field;
			
			cnt := 0;
	
	---------------------------------------------------------------------------
	-- Clock
	---------------------------------------------------------------------------		
		elsif rising_edge(clock) then
	
			ram_wren 		<= '0';
			ram_data_in 	<= (others => '0');
			
			stack_mode 		<= "00";
			stack_data_in 	<= (others => '0');
			
--			minecnt_enable	<= '0';
--			minecnt_mode	<= '0';
	
			case st is
			
	---------------------------------------------------------------------------
	-- Estado inicial
	---------------------------------------------------------------------------
	
				when S_0 =>
				
					st <= S_IClr;
					
	---------------------------------------------------------------------------
	--
	--
	-- Inicializacao do Campo
	--
	--
	---------------------------------------------------------------------------
					
	---------------------------------------------------------------------------
	-- Limpa o campo
	---------------------------------------------------------------------------
	
				when S_IClr =>

					st <= S_IClr;				

					ram_wren <= '1';
					ram_addr <= lin & col;
					ram_data_in <= "01000000";
					
					if col = 35 then
						
						if lin = 27 then
						
							st <= S_IRng;
							rng_enable <= '1';
		
						else
						
							lin := lin + 1;
							
						end if;
						
						col := "000100";
						
					else
						
						col := col + 1;
			
					end if;

	---------------------------------------------------------------------------
	-- Gera posicoes aleatorias (ou quase)
	---------------------------------------------------------------------------
	
				when S_IRng =>
				
					st <= S_IRdM;
					
					if free = (num_field - mines) then
				
						st <= S_MW;
						
					else
				
						if rng_y > 20 then
							
							st <= S_IRng;
							
						else
						
							ram_addr <= (rng_y + 7) & (('0' & rng_x) + 4);
							
						end if;
					
					end if;
					
	---------------------------------------------------------------------------
	-- Le a posicao da memoria
	---------------------------------------------------------------------------
	
				when S_IRdM =>
				
					st <= S_IChkM;
				
	---------------------------------------------------------------------------
	-- Verifica se ja nao eh uma mina
	---------------------------------------------------------------------------
	
				when S_IChkM =>
				
					st <= S_IWrM;
				
					if ram_data_out(7 downto 6) = "01" and
					   ram_data_out(3 downto 0) /= "1111" then
					   
						--mines := mines - 1;
						free := free - 1;
						cnt := 0;
					   
						ram_data_in <= "01001111";
						ram_wren <= '1';
					   
					else
					
						st <= S_IRng;
			
					end if;
					
	---------------------------------------------------------------------------
	-- Escreve posicao de memoria
	---------------------------------------------------------------------------
	
				when S_IWrM =>
				
					st <= S_IChkN;
					
	---------------------------------------------------------------------------
	-- Calcula endereco do vizinho
	---------------------------------------------------------------------------				
				
				when S_IChkN => 
				
					case cnt is
					
						when 0 => ram_addr <= (ram_addr(10 downto 6) + 1) & 
											  (ram_addr( 5 downto 0)    );
											 
						when 1 => ram_addr <= (ram_addr(10 downto 6)    ) & 
											  (ram_addr( 5 downto 0) + 1);
											 
						when 2 => ram_addr <= (ram_addr(10 downto 6) - 1) & 
											  (ram_addr( 5 downto 0)    );
											 
						when 3 => ram_addr <= (ram_addr(10 downto 6) - 1) & 
											  (ram_addr( 5 downto 0)    );
											 
						when 4 => ram_addr <= (ram_addr(10 downto 6)    ) & 
											  (ram_addr( 5 downto 0) - 1);
											 
						when 5 => ram_addr <= (ram_addr(10 downto 6)    ) & 
										      (ram_addr( 5 downto 0) - 1);
											 
						when 6 => ram_addr <= (ram_addr(10 downto 6) + 1) & 
									          (ram_addr( 5 downto 0)    );
											 
						when 7 => ram_addr <= (ram_addr(10 downto 6) + 1) & 
										      (ram_addr( 5 downto 0)    );
					end case;
				
					cnt := cnt + 1;
					st <= S_IRdN;
					
	---------------------------------------------------------------------------
	-- Le o vizinho
	---------------------------------------------------------------------------					
					
				when S_IRdN => 
				
					st <= S_IIncN;
				
	---------------------------------------------------------------------------
	-- Verifica se eh um quadrado normal e incrementa o contador de minas
	---------------------------------------------------------------------------				
				
				when S_IIncN => 
				
					st <= S_IWrN;
				
					if ram_data_out(7 downto 6) = "01" and
						ram_data_out(3 downto 0) /= "1111" then
					   
						ram_wren <= '1';
						ram_data_in <= ram_data_out(7 downto 4) &
							(ram_data_out(3 downto 0) + 1);
							
					end if;
				
	---------------------------------------------------------------------------
	-- Escreve o novo numero de minas vistas pelo campo
	---------------------------------------------------------------------------				
				
				when S_IWrN =>
				
					if cnt = 0 then
						
						st <= S_IRng;
						
					else
			
						st <= S_IChkN;
						
					end if;
					
	---------------------------------------------------------------------------
	--
	--
	-- Tratamento de Botoes
	--
	--
	---------------------------------------------------------------------------
					
	---------------------------------------------------------------------------
	-- Aguarda botoes
	---------------------------------------------------------------------------

				when S_MW =>
				
						
				
					if free = 0 then
			
						game_state <= "11";
						st <= s_GameOver;
						
					else
				
						buttons_state(1) <= mouse_click_l;
						buttons_state(0) <= mouse_click_r;
						
						--ram_addr <= (others => '0');
						ram_addr <= mouse_pos_y(8 downto 4) & mouse_pos_x(9 downto 4);
					
						if (buttons_state(1) = '1') then
							st <= S_MHL;
						elsif (buttons_state(0) = '1') then
							st <= S_MHR;
						end if;

--						if (buttons_state(1) or buttons_state(0)) = '1' then
--							st <= S_MH;
--						else
--							st <= S_MW;
--						end if;
						
					end if;

	---------------------------------------------------------------------------
	-- Load and Wait
	---------------------------------------------------------------------------
					
				when S_MHL =>
				
					ram_addr <= mouse_pos_y(8 downto 4) & 
						mouse_pos_x(9 downto 4);
					
					if (not mouse_click_l) = '1' then
						st <= S_ML;
					else
						st <= S_MHL;
					end if;

	---------------------------------------------------------------------------
	-- Load and Wait
	---------------------------------------------------------------------------
					
				when S_MHR =>
				
					ram_addr <= mouse_pos_y(8 downto 4) & 
						mouse_pos_x(9 downto 4);
					
					if (not mouse_click_r) = '1' then
						st <= S_MR;
					else
						st <= S_MHR;
					end if;

	---------------------------------------------------------------------------
	-- Right Mouse
	---------------------------------------------------------------------------
				
				when S_MR =>
					
					st <= S_MW;
				
					buttons_state(0) <= '0';
				
					if ram_data_out(7 downto 6) = "01" and
						ram_data_out(5) = '0' then
					
						if (ram_data_out(4) = '1') then
							flagcnt <= flagcnt + 1;
						elsif (ram_data_out(4) = '0') then
							flagcnt <= flagcnt - 1;
						end if;
					
						ram_wren <= '1';
						ram_data_in(4) <= not ram_data_out(4);
						ram_data_in(7 downto 5) <= ram_data_out(7 downto 5);
						ram_data_in(3 downto 0) <= ram_data_out(3 downto 0);
					
					end if;

	---------------------------------------------------------------------------
	-- Left Mouse
	---------------------------------------------------------------------------
			
				when S_ML =>
				
					st <= S_MOpen;
				
				
	---------------------------------------------------------------------------
	-- Left Mouse
	---------------------------------------------------------------------------
	
				when S_MOpen =>
				
					st <= S_MW;
					
					buttons_state(1) <= '0';
				
					if ram_data_out(7 downto 6) = "01" and
						ram_data_out(5 downto 4) = "00" then
					
						-- Inicia a contagem de tempo
					
						timer_enable <= '1';

						-- Atualiza a memoria principal
						
						ram_wren <= '1';
						ram_data_in(5) <= '1';
						ram_data_in(7 downto 6) <= ram_data_out(7 downto 6);
						ram_data_in(4 downto 0) <= ram_data_out(4 downto 0);
			
						if ram_data_out(3 downto 0) = "1111" then
							
							-- Fim do jogo
							
							game_state <= "10";
							st <= S_GameOver;
							
						else
							
							-- Decrementar contador de campos
							
							free := free - 1;
							
							if ram_data_out(3 downto 0) = "0000" then
							
								-- Inicializa o SAm
							
								stack_mode <= "01";
								stack_data_in <= "000" & ram_addr;
								
								st <= S_SAmPush;
								
							end if;
							
						end if;

					end if;
					
	---------------------------------------------------------------------------
	--
	--
	-- SAm
	--
	--
	---------------------------------------------------------------------------
					
	---------------------------------------------------------------------------
	-- SAm Push
	---------------------------------------------------------------------------
					
				when S_SAmPush =>
				
					-- Aguarda a atualizacao da pilha
					
					st <= S_SAmProc;
					
	---------------------------------------------------------------------------
	-- SAm Process
	---------------------------------------------------------------------------
	
				when S_SAmProc =>
	
					if stack_empty = '1' then
						
						-- Fim do processo de abertura recursiva

						st <= S_MW;
						
					else
					
						st <= S_SAmUpdate;
				
						-- Calcula o endereco do proximo elemento a ser empilhado
						-- relativo ao elemento atual e seu contador na pilha
					
						case stack_data_out(13 downto 11) is
							when "000" => ram_addr <= (stack_data_out(10 downto 6) + 1) & 
												 (stack_data_out(5 downto 0));
												 
							when "001" => ram_addr <= (stack_data_out(10 downto 6) + 1) & 
												 (stack_data_out(5 downto 0) + 1);
												 
							when "010" => ram_addr <= (stack_data_out(10 downto 6)) & 
												 (stack_data_out(5 downto 0) + 1);
												 
							when "011" => ram_addr <= (stack_data_out(10 downto 6) - 1) & 
												 (stack_data_out(5 downto 0) + 1);
												 
							when "100" => ram_addr <= (stack_data_out(10 downto 6) - 1) &
												 (stack_data_out(5 downto 0));
												 
							when "101" => ram_addr <= (stack_data_out(10 downto 6) - 1) &
												 (stack_data_out(5 downto 0) - 1);
												 
							when "110" => ram_addr <= (stack_data_out(10 downto 6)) & 
												 (stack_data_out(5 downto 0) - 1);
												 
							when "111" => ram_addr <= (stack_data_out(10 downto 6) + 1) &
												 (stack_data_out(5 downto 0) - 1);
						end case;
						
							
							if stack_data_out(13 downto 11) = "111" then
								
								-- Remove o elemento atual da pilha ao percorrer todos
								-- os elementos a sua volta
						
								stack_mode <= "10";
								
							else
							
								-- Sobrescreve o elemento atual na pilha com o novo
								-- contador de direcao
						
								stack_mode <= "11";
								stack_data_in <= (stack_data_out(13 downto 11) + 1) & 
									stack_data_out(10 downto 0);
							
							end if;

					end if;
					
	---------------------------------------------------------------------------
	-- SAm Update
	---------------------------------------------------------------------------
	
				when S_SAmUpdate =>
				
					-- Aguarda a atualizacao da pilha (contador atual)
					-- e a RAM (informacao sobre o elemento vizinho)
				
					st <= S_SAmOpen;
				
	---------------------------------------------------------------------------
	-- SAm Open and Stack
	---------------------------------------------------------------------------
	
				when S_SAmOpen =>
				
					st <= S_SAmPush;
			
					if ram_data_out(7 downto 6) = "01" and
						ram_data_out(5 downto 4) = "00" then
					
						-- Decrementa contador de campos
						
						free := free - 1;
					
						-- Abre o elemento vizinho se for valido
					
						ram_wren <= '1';
						ram_data_in(5) <= '1';
						ram_data_in(7 downto 6) <= ram_data_out(7 downto 6);
						ram_data_in(4 downto 0) <= ram_data_out(4 downto 0);
					
						if ram_data_out(3 downto 0) = "0000" then
						
							-- Empilha o elemento vizinho se for vazio para
							-- continuar a abrir os vizinhos dos outros
							-- elementos vazios
						
							stack_mode <= "01";
							stack_data_in <= "000" & ram_addr;
							
						end if;
					
					end if;
					
	---------------------------------------------------------------------------
	--
	--
	-- Estado Final
	--
	--
	---------------------------------------------------------------------------

	---------------------------------------------------------------------------
	-- Fim do jogo
	---------------------------------------------------------------------------
					
				when S_GameOver =>
				
					st <= S_GameOver;
					
					-- Para a contagem de pontos
					if game_state = "11" then
						flagcnt <= (others => '0');
					end if;
					timer_enable <= '0';
					
	---------------------------------------------------------------------------
	-- ?
	---------------------------------------------------------------------------
	
				when others =>
					st <= S_0;

			end case;
		end if;
	end process;

end;
