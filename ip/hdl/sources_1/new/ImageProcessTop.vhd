----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2024 01:28:10 PM
-- Design Name: 
-- Module Name: ImageProcessTop - Behavioral
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

entity ImageProcessTop is
  Port ( 
    axi_clk : in std_logic;
    axi_rst_n : in std_logic;
   
    -- slave Interface
    pixel_in : in std_logic_vector(7 downto 0);
    pixel_vin : in std_logic;
    slave_ready : out std_logic;
    -- Master Interface
    pixel_out : out std_logic_vector(7 downto 0);
    pixel_vout : out std_logic;
    master_ready : in std_logic;
    
    intr : out std_logic  
  );
end ImageProcessTop;

architecture Behavioral of ImageProcessTop is
component ControlUnit is
  Port ( 
    clk : in std_logic;
    rst_n : in std_logic;
    pixel_in : in std_logic_vector(7 downto 0);
    pixel_in_valid : in std_logic;
    pixel_buffer_out : out std_logic_vector(71 downto 0);
    pixel_buff_valid : out std_logic;
    intr     : out std_logic               
  );
end component;
component conv is
    Port(
        clk : in std_logic;
        pixel_buff_valid : in std_logic;
        pixel_buff : in std_logic_vector(71 downto 0); -- 9 pixels * 8 bits each
        pixel_out : out std_logic_vector(7 downto 0);
        pixel_out_valid : out std_logic
    );
end component;
COMPONENT outputBuffer
  PORT (
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC;
    s_aclk : IN STD_LOGIC;
    s_aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    --s_axis_tuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    --m_axis_tuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    axis_prog_full : OUT STD_LOGIC
  );
END COMPONENT;
signal pixel_data : std_logic_vector(71 downto 0);
signal pixel_data_valid : std_logic;
signal axis_prog_full : std_logic;
signal convolved_pixel : std_logic_vector(7 downto 0);
signal convolved_pixel_valid : std_logic; 
-- signal intr_out : std_logic;
-- signal axi_rst_n : std_logic;

begin

CU : ControlUnit
 port map(
    clk => axi_clk,
    rst_n => axi_rst_n,
    pixel_in => pixel_in,
    pixel_in_valid => pixel_vin,
    pixel_buffer_out => pixel_data,
    pixel_buff_valid => pixel_data_valid,
    intr => intr
);

Convolution : conv
 port map(
    clk => axi_clk,
    pixel_buff => pixel_data,
    pixel_buff_valid => pixel_data_valid,
    pixel_out => convolved_pixel,
    pixel_out_valid => convolved_pixel_valid
    
 );

 FIFO : outputBuffer
   PORT MAP (

     wr_rst_busy => open,
     rd_rst_busy => open,
     s_aclk => axi_clk,
     s_aresetn => axi_rst_n,
     s_axis_tvalid => convolved_pixel_valid,
     s_axis_tready => open,
     s_axis_tdata => convolved_pixel,
     m_axis_tvalid => pixel_vout,
     m_axis_tready => master_ready,
     m_axis_tdata => pixel_out,
     --m_axis_tuser => (others => '0'),
     --s_axis_tuser => (others => '0'),
     axis_prog_full => axis_prog_full
   );
slave_ready <= not axis_prog_full;
 -- intr <= intr_out;
end Behavioral;
