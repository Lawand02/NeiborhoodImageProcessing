----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/16/2024 07:31:55 AM
-- Design Name: 
-- Module Name: conv - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity conv is
    Port(
        clk : in std_logic;
        pixel_buff_valid : in std_logic;
        pixel_buff : in std_logic_vector(71 downto 0); -- 9 pixels * 8 bits each
        pixel_out : out std_logic_vector(7 downto 0);
        pixel_out_valid : out std_logic  
    );
end conv;

architecture Behavior of conv is
type kernel is array(0 to 8 )of std_logic_vector(7 downto 0);
signal blur_kernel : kernel :=  (others => "00000001");
type multiplication_array is array(0 to 8) of unsigned(15 downto 0);
signal multiplication_results : multiplication_array;
signal result_sum : unsigned(15 downto 0) := (others => '0');

--signal divisor : unsigned(7 downto 0) := to_unsigned(9, 8);
-- signal out_pixel : unsigned(7 downto 0);

begin
process(clk)
variable i : integer := 0;
variable division_result : unsigned(15 downto 0);

begin
    if rising_edge(clk) then
        if pixel_buff_valid = '1' then
            multiplication_results(8) <= unsigned(blur_kernel(8)) * unsigned(pixel_buff(71 downto 64));
            multiplication_results(7) <= unsigned(blur_kernel(7)) * unsigned(pixel_buff(63 downto 56));
            multiplication_results(6) <= unsigned(blur_kernel(6)) * unsigned(pixel_buff(55 downto 48));
            multiplication_results(5) <= unsigned(blur_kernel(5)) * unsigned(pixel_buff(47 downto 40));
            multiplication_results(4) <= unsigned(blur_kernel(4)) * unsigned(pixel_buff(39 downto 32));
            multiplication_results(3) <= unsigned(blur_kernel(3)) * unsigned(pixel_buff(31 downto 24));
            multiplication_results(2) <= unsigned(blur_kernel(2)) * unsigned(pixel_buff(23 downto 16));
            multiplication_results(1) <= unsigned(blur_kernel(1)) * unsigned(pixel_buff(15 downto 8));
            multiplication_results(0) <= unsigned(blur_kernel(0)) * unsigned(pixel_buff(7 downto 0));

    end if;
        end if;
  end process;
  process(clk)
  variable i : integer := 0;
  variable sum : unsigned(15 downto 0):= (others => '0'); 

  begin         
    if rising_edge(clk) then
        if pixel_buff_valid = '1' then
        sum := (others => '0');
         for i in 0 to 8 loop
            sum := sum + multiplication_results(i);
         end loop; 
         result_sum <= sum;       
    end if;
        end if;
    end process;  
    
     process(clk)
     begin         
       if rising_edge(clk) then
           if pixel_buff_valid = '1' then
                 pixel_out <= std_logic_vector(to_unsigned(to_integer(result_sum)/9,8));
                 pixel_out_valid <= '1';
            else 
                 pixel_out_valid <= '0';
            end if;
       end if;
       end process;  
end Behavior;
