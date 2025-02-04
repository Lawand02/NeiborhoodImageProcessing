----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/18/2024 07:31:55 AM
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
Port ( 
clk : in std_logic;
rst_n : in std_logic;
pixel_in : in std_logic_vector(7 downto 0);
pixel_in_valid : in std_logic;
pixel_buffer_out : out std_logic_vector(71 downto 0);
pixel_buff_valid : out std_logic;
intr     : out std_logic               
);
end ControlUnit;

architecture Behavioral of ControlUnit is
signal line_buffer0_out : std_logic_vector(23 downto 0);
signal line_buffer1_out : std_logic_vector(23 downto 0);
signal line_buffer2_out : std_logic_vector(23 downto 0);
signal line_buffer3_out : std_logic_vector(23 downto 0);


signal pixelCounter : unsigned(8 downto 0) := (others => '0');
signal currentLineBuffer : unsigned(1 downto 0) := (others => '0');
signal lineBufferDataValid : std_logic_vector(3 downto 0) := (others => '0');
signal currentRdLineBuffer : unsigned(1 downto 0) := (others => '0');
signal currentWrLineBuffer : unsigned(1 downto 0) := "00";
signal LineBufferRdData : std_logic_vector(3 downto 0):= (others => '0');
signal rd_line_buffer : std_logic := '0';
signal rd_counter : unsigned(8 downto 0) := (others => '0');
signal totalPixelCounter : unsigned(11 downto 0) := (others => '0'); -- 2047
type state is (IDLE,RD_BUFFER);
signal rdState : state := IDLE;
signal pixel_out : std_logic_vector(71 downto 0);

component lineBuffer is
Port (
    clk : in std_logic;
    rst_n : in std_logic;
    pixel_in : in std_logic_vector(7 downto 0);
    pixel_vin : in std_logic;
    read_pixel : in std_logic;
    pixel_out : out std_logic_vector(23 downto 0) 
 );
 end component;
begin    
lb0 : lineBuffer 
port map(
    clk => clk,
    rst_n => rst_n,
    pixel_in => pixel_in,
    pixel_vin => lineBufferDataValid(0),
    read_pixel => LineBufferRdData(0),
    pixel_out => line_buffer0_out
    );
lb1 : lineBuffer 
port map(
    clk => clk,
    rst_n => rst_n,
    pixel_in => pixel_in,
    pixel_vin => lineBufferDataValid(1),
    read_pixel => LineBufferRdData(1),
    pixel_out => line_buffer1_out
    );
lb2 : lineBuffer 
port map(
    clk => clk,
    rst_n => rst_n,
    pixel_in => pixel_in,
    pixel_vin => lineBufferDataValid(2),
    read_pixel => LineBufferRdData(2),
    pixel_out => line_buffer2_out
    ); 
lb3 : lineBuffer 
port map(
    clk => clk,
    rst_n => rst_n,
    pixel_in => pixel_in,
    pixel_vin => lineBufferDataValid(3),
    read_pixel => LineBufferRdData(3),
    pixel_out => line_buffer3_out
    );


-- Pixel Counter Process
process(clk)
begin     
if rising_edge(clk) then
    if rst_n = '0' then
        pixelCounter <= (others => '0');
        --intr <= '0';
    else
        -- Increment pixelCounter on valid input
        if pixel_in_valid = '1' then
            if pixelCounter = 511 then
                pixelCounter <= (others => '0');
                --intr <= '1';
            else
                pixelCounter <= pixelCounter + 1;
                --intr <= '0';
            end if;
        end if;
    end if;
end if;
end process;

-- Write Line Buffer Selector Process
process(clk)
begin
    if rising_edge(clk) then
        if rst_n = '0' then
            currentWrLineBuffer <= (others => '0');
        elsif pixelCounter = 511 and pixel_in_valid = '1' then
            currentWrLineBuffer <= currentWrLineBuffer + 1;
        end if;
    end if;
end process;
-----
-- Line Buffer Data Valid Signal
process(currentWrLineBuffer, pixel_in_valid)
begin
    lineBufferDataValid <= (others => '0');
    lineBufferDataValid(to_integer(currentWrLineBuffer)) <= pixel_in_valid;
end process;
------------------- Reading --------------------------------------------------

process (clk)
begin
if rising_edge(clk) then
  if rst_n = '0' then
    totalPixelCounter <= (others => '0');
  elsif (pixel_in_valid = '1' and rd_line_buffer = '0') then
    totalPixelCounter <= totalPixelCounter + 1;
  elsif (pixel_in_valid = '0' and rd_line_buffer = '1') then
    totalPixelCounter <= totalPixelCounter - 1;
  end if;
end if;
end process;

-- Read State Machine Process
process(clk)
begin
    if rising_edge(clk) then
        if rst_n = '0' then
            rdState <= IDLE;
            rd_line_buffer <= '0';
            --currentRdLineBuffer <= (others => '0');
            intr <= '0';
        else
            case rdState is
                when IDLE =>
                    intr <= '0';
                    if totalPixelCounter >= 1536 then
                        rd_line_buffer <= '1';
                        rdState <= RD_BUFFER;
                    end if;
                when RD_BUFFER =>
                    if rd_counter = 511 then
                        rdState <= IDLE;
                        rd_line_buffer <= '0';
                        intr <= '1';
                        --currentRdLineBuffer <= currentRdLineBuffer + 1;                    
                    end if;
                when others =>
                        rdState <= IDLE; 
            end case;
        end if;
    end if;
end process;

--pixel_buff_valid <= rd_line_buffer;
process (clk)
  begin
    if rising_edge(clk) then
      pixel_buff_valid <= rd_line_buffer;
    end if;
 end process;

-- Read Counter Process
process(clk)
begin
    if rising_edge(clk) then
        if rst_n = '0' then
            rd_counter <= (others => '0');
        elsif rd_line_buffer = '1' then
            rd_counter <= rd_counter + 1;
        end if;
    end if;
end process;

  -- Current Read Line
process (clk)
begin
    if rising_edge(clk) then
      if rst_n = '0' then
        currentRdLineBuffer <= (others => '0');
      elsif (rd_counter = 511 and rd_line_buffer = '1') then
        currentRdLineBuffer <= currentRdLineBuffer + 1;
      end if;
    end if;
end process;
       
-- Output Pixel Data Multiplexing
process(currentRdLineBuffer, line_buffer0_out, line_buffer1_out, line_buffer2_out, line_buffer3_out)
begin
    case currentRdLineBuffer is
        when "00" =>
            pixel_out <= line_buffer2_out & line_buffer1_out & line_buffer0_out;
        when "01" =>
            pixel_out <= line_buffer3_out & line_buffer2_out & line_buffer1_out;
        when "10" =>
            pixel_out <= line_buffer0_out & line_buffer3_out & line_buffer2_out;
        when "11" =>
            pixel_out <= line_buffer1_out & line_buffer0_out & line_buffer3_out;
        when others =>
            pixel_out <= (others => '0');
    end case;
end process;

-- Line buffer read data signals
--process(currentRdLineBuffer)
--begin
--    case currentRdLineBuffer is
--        when "00" => LineBufferRdData <= "1110";
--        when "01" => LineBufferRdData <= "0111";
--        when "10" => LineBufferRdData <= "1011";
--        when others => LineBufferRdData <= "1101";
--    end case;
--end process;

-- Assign Output Signals
LineBufferRdData <= (others => rd_line_buffer);
pixel_buffer_out <= pixel_out;

end Behavioral;