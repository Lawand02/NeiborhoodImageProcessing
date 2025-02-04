----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2024 01:31:06 PM
-- Design Name: 
-- Module Name: lineBuffer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lineBuffer is
    Port (
        clk : in std_logic;
        rst_n : in std_logic;
        pixel_in : in std_logic_vector(7 downto 0);
        pixel_vin : in std_logic;
        read_pixel : in std_logic;
        pixel_out : out std_logic_vector(23 downto 0)
     );
end lineBuffer;

architecture Behavioral of lineBuffer is
-- line buffer
type line_array is array(0 to 511) of std_logic_vector(7 downto 0);
signal line : line_array := (others => (others => '0'));
signal wrIndx : integer range 0 to 511 := 0;
signal rdIndx : integer range 0 to 511 := 0;
-- signal data_out : std_logic_vector(23 downto 0);
begin
process(clk)
begin
	if rising_edge(clk) then
		if rst_n = '0' then
			wrIndx <= 0;
			rdIndx <= 0;
			line <=  (others => (others=>'0')); 
			--pixel_out <= (others => '0');
		elsif pixel_vin = '1' then
			line(wrIndx) <= pixel_in;
			if wrIndx = 511 then
				wrIndx <= 0;
			else
				wrIndx <= wrIndx + 1;
			end if;
		elsif read_pixel  = '1' then 
			if rdIndx = 511 then
				rdIndx <= 0;
			else
				rdIndx <= rdIndx + 1;
			end if;
		--else 
			--pixel_out <= (others =>'0');
		end if;
	end if;
end process;
pixel_out <= line(rdIndx) & line((rdIndx + 1) mod 512) & line((rdIndx + 2) mod 512);
end Behavioral;
