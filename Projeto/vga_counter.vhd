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

entity vga_counter is
  port ( 
         -- Sinais de entrada
         
         clk_27M, rstn         : in  std_logic;
         color_index		   : in  std_logic_vector(3 downto 0);
         
         -- Sinais de saida para a VGA
         
         vga_hsync, vga_vsync  : out std_logic;
         vga_r, vga_g, vga_b   : out std_logic_vector(3 downto 0);
         vga_clk               : buffer std_logic; -- 25.175 MHz
         
         -- Sinais de saida para outros modulos
         
         h_count, h_count_d    : buffer std_logic_vector (9 downto 0);
         v_count, v_count_d    : buffer std_logic_vector (9 downto 0)
	);
end entity;

architecture vga_counter_logic of vga_counter is
  
  signal h_count_d2 : std_logic_vector (9 downto 0);
  signal v_count_d2 : std_logic_vector (9 downto 0);
  signal h_drawarea, v_drawarea, drawarea : std_logic;
  signal pixel : std_logic_vector (11 downto 0);
  
begin

  -- Gera o clock de 25.1 MHz pra VGA
  
  divider: work.vga_pll port map (clk_27M, vga_clk);

  -- Contador horizontal de pixels
  
  horz_counter: process (vga_clk, rstn)
  begin
    if rstn = '0' then
      h_count <= "0000000000";
      h_count_d <= "0000000000";
      h_count_d2 <= "0000000000";
    elsif vga_clk'event and vga_clk = '1' then
      h_count_d2 <= h_count_d;
      h_count_d <= h_count;
      if h_count = 799 then
        h_count <= "0000000000";
      else
        h_count <= h_count + 1;
      end if;
    end if;
  end process horz_counter;

  -- Area horizontal da tela
  
  horz_sync: process (h_count_d2)
  begin  -- process horz_sync
    if h_count_d2 < 640 then
      h_drawarea <= '1';
    else
      h_drawarea <= '0';
    end if;
  end process horz_sync;

  -- Contador vertical de pixels
  
  vert_counter: process (vga_clk, rstn)
  begin  -- process vert_counter
    if rstn = '0' then
      v_count <= "0000000000";
      v_count_d <= "0000000000";
      v_count_d2 <= "0000000000";
    elsif vga_clk'event and vga_clk = '1' then  -- rising clock edge
	  v_count_d2 <= v_count_d;
      v_count_d <= v_count;             -- 1 clock cycle delayed counter
      if h_count = 699 then
        if v_count = 524 then
          v_count <= "0000000000";
        else
          v_count <= v_count + 1;  
        end if;          
      end if;
    end if;
  end process vert_counter;

  -- Area vertical da tela
  
  vert_sync: process (v_count_d2)
  begin  -- process vert_sync
    if v_count_d2 < 480 then
      v_drawarea <= '1';
    else
      v_drawarea <= '0';
    end if;
  end process vert_sync;

  -- Sinais de sincronizacao
  
  sync: process (v_count_d2, h_count_d2)
  begin  -- process sync
    if (h_count_d2 >= 659) and (h_count_d2 <= 755) then
      vga_hsync <= '0';
    else
      vga_hsync <= '1';
    end if;
    if (v_count_d2 >= 493) and (v_count_d2 <= 494) then
      vga_vsync <= '0';
    else
      vga_vsync <= '1';
    end if;
  end process sync;
  
  -- Gera a cor a partir do indice
  
PALETTE: vga_palette port map (color_index, pixel);

  -- Manda as cores para a VGA

  drawarea <= v_drawarea and h_drawarea;
  
  vga_r <= pixel(11 downto 8) and (vga_r'range => drawarea);
  vga_g <= pixel(7 downto 4)  and (vga_g'range => drawarea);
  vga_b <= pixel(3 downto 0)  and (vga_b'range => drawarea);
  
end architecture;
