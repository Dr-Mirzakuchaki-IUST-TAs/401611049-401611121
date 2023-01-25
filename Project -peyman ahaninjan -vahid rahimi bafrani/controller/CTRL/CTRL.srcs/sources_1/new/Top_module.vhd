library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Top_module is
Port (--- system inputs 
      M4            :in     std_logic;
      M5            :in     std_logic;
      M6            :in     std_logic;
      clk_sys_in    :in     std_logic;
      data_in       :in     std_logic_vector(7 downto 0);
      address_in    :in     std_logic_vector(14 downto 0);
      RW_in         :in     std_logic;
      ACP           :in     std_logic; -- Atonomus Configure Pin
      start_pin     :in     std_logic;
      reset         :in     std_logic;
      spi_mode      :in     std_logic;
      --- system outputs
      configdone    :out    std_logic;
      data_output   :out    std_logic_vector(7 downto 0);
      ---I2C pins
      SCL           :out    STD_LOGIC;
      RW_CTL        :out    STD_LOGIC;
      SDA           :inout  STD_LOGIC;
      ---SPI 4wire pins
      MISO					: IN STD_LOGIC;
      CHIP_SELECT_SPI 	    : OUT STD_LOGIC;
      SCK_SPI	  				: OUT STD_LOGIC;
      MOSI					: OUT STD_LOGIC;
      RW_out_spi   :out    std_logic;
      ---SPI 3wire pins
      CHIP_SELECT_SDIO : out std_logic;
      SCK_SDIO	   	: out std_logic;
      RW_out_sdio   :out    std_logic;
      SDIO			: inout std_logic
 );
end Top_module;

architecture Structural of Top_module is
component controller 
Port (M4            :in     std_logic;
      M5            :in     std_logic;
      M6            :in     std_logic;
      ACP           :in     std_logic; -- Atonomus Configure Pin
      address_in    :in     std_logic_vector(14 downto 0);
      RW_in         :in     std_logic;
      data_in       :in     std_logic_vector(7 downto 0);
      clk_sys_in    :in     std_logic;
      write_finish  :in     std_logic;
      read_finish   :in     std_logic;
      start_pin     :in     std_logic;
      reset         :in     std_logic;
      spi_mode      :in     std_logic;
      ram_finish    :in     std_logic;
      data_from_i2c  :in std_logic_vector(7 downto 0);
      data_from_spi  :in std_logic_vector(7 downto 0);
      data_from_sdio :in std_logic_vector(7 downto 0);
      ---
      ram_enable    :out    std_logic;
      ram_nextdata  :out    std_logic;
      configdone    :out    std_logic;
      data_output   :out    std_logic_vector(7 downto 0);
      address_i2c   :out    std_logic_vector(1 downto 0);
      RW_out        :out    std_logic;
      SPI_3wire     :out    std_logic;
      SPI_4wire     :out    std_logic;
      I2C_sel       :out    std_logic;
      CLK_sys_out   :out    std_logic;
      data_to_module:out    std_logic_vector(22 downto 0));
end component;

component i2c_module
Port (
      ---
      CLK_sys   :in     STD_LOGIC;
      Enable    :in     STD_LOGIC;
      RW        :in     STD_LOGIC;
      ---
      SCL           :out    STD_LOGIC;
      RW_CTL        :out    STD_LOGIC;
      write_finish  :out    std_logic;
      read_finish   :out    std_logic;
      ---
      SDA       :inout  STD_LOGIC;
      ---
      Data_Input:in     STD_LOGIC_VECTOR(22 downto 0);
      Data_Output:out   STD_LOGIC_VECTOR(7 downto 0);
      ---
      address_sel :in   STD_LOGIC_VECTOR(1 downto 0)
 );
end component;
component spi_protocol
port (
    -- input--
    CLK_SYS 				: IN STD_LOGIC;
    START   				: IN STD_LOGIC;
    DATA_INPUT			    : IN STD_LOGIC_VECTOR(23 downto 0);
    MISO					: IN STD_LOGIC;
    enable					: IN std_logic;
    --output--
    FINISH_WRITE 			: OUT STD_LOGIC;
    FINISH_READ 			: OUT STD_LOGIC;
    CHIP_SELECT 			: OUT STD_LOGIC;
    SCK	  					: OUT STD_LOGIC;
    RW						: OUT STD_LOGIC;
    Read_8bit				: OUT STD_LOGIC_VECTOR (7 downto 0);
    MOSI					: OUT STD_LOGIC
    );
end component;
component SPI_SDIO
Port (
	CLK_SYS           : in std_logic;
    Data_IN           : in std_logic_vector(23 downto 0);
    Start	          : in std_logic;
    enable			  : in std_logic;
	-- OUTPUT --
	CHIP_SELECT       : out std_logic;
    RW				  : out std_logic;
	SCLK	   	      : out std_logic;
    FINISH_WRITE      : OUT STD_LOGIC;
	FINISH_READ 	  : OUT STD_LOGIC;
	data_output       : out STD_logic_vector(7 downto 0);
  -- INOUT --
    SDIO			  : inout std_logic
);
end component;
component ram
port (
    clk      : IN  STD_LOGIC; 
    next_data: IN  STD_logic;
    enable   : IN  STD_LOGIC;
    finish   : OUT STD_LOGIC;
    all_data : OUT std_logic_vector(22 downto 0)
	  );
end component;
--- buses
signal data_to_module_bus_22     :std_logic_vector(22 downto 0);
signal data_to_module_bus_23     :std_logic_vector(23 downto 0);
signal  data_from_i2c_int    :std_logic_vector(7 downto 0)   := (others  => '0');
signal  data_from_spi_int    :std_logic_vector(7 downto 0)   := (others  => '0');
signal  data_from_sdio_int    :std_logic_vector(7 downto 0)   := (others  => '0');
--- status signals
signal RW           :std_logic;
signal write_finish :std_logic;
signal read_finish  :std_logic;
signal write_finish_1 :std_logic;
signal write_finish_2 :std_logic;
signal write_finish_3 :std_logic;
signal read_finish_1  :std_logic;
signal read_finish_2  :std_logic;
signal read_finish_3  :std_logic;
signal ram_finish   :std_logic;
signal i2c_address  :std_logic_vector(1 downto 0);
--- enable signals
signal spi_3wire    :std_logic;
signal spi_4wire    :std_logic;
signal I2C_sel      :std_logic;
signal ram_enable   :std_logic;
---
signal ram_next_data:std_logic;
---
signal clk          :std_logic;

begin
data_to_module_bus_23 <= RW & data_to_module_bus_22;
read_finish <= read_finish_1 or read_finish_2 or read_finish_3;
write_finish <=  write_finish_1 or write_finish_2 or write_finish_3;
CNT: controller Port Map
     (M4 => M4,
      M5 => M5,
      M6 => M6,
      ACP => ACP,
      address_in => address_in,
      RW_in => RW_in,
      data_in => data_in,
      clk_sys_in => clk_sys_in,
      write_finish => write_finish,
      read_finish => read_finish,
      start_pin => start_pin,
      reset => reset,
      spi_mode => spi_mode,
      ram_finish => ram_finish,
      data_from_i2c => data_from_i2c_int,
      data_from_spi => data_from_spi_int,
      data_from_sdio => data_from_sdio_int,
      --- 
      ram_enable => ram_enable,
      ram_nextdata => ram_next_data,
      configdone => configdone,
      data_output => data_output,
      address_i2c => i2c_address,
      RW_out => RW,
      SPI_3wire => spi_3wire,
      SPI_4wire => spi_4wire,
      I2C_sel => I2C_sel,
      CLK_sys_out => clk,
      data_to_module =>data_to_module_bus_22
      );
i2c:  i2c_module Port Map (
      ---
      CLK_sys       => clk,
      Enable        => I2C_sel,
      RW            => RW,
      ---
      SCL           => SCL,
      RW_CTL        => RW_CTL,
      write_finish  => write_finish_1,
      read_finish   => read_finish_1,
      ---
      SDA           => SDA,
      ---
      Data_Input    => data_to_module_bus_22,
      Data_Output   => data_from_i2c_int,
      ---
      address_sel   => i2c_address
 );
 
spi4:spi_protocol port map (
    -- input--
    CLK_SYS 		=> clk,
    START   		=> spi_4wire,
    DATA_INPUT		=> data_to_module_bus_23,
    MISO			=> MISO,
    enable			=> spi_4wire,
    --output--
    FINISH_WRITE 	=> write_finish_2,
    FINISH_READ 	=> read_finish_2,
    CHIP_SELECT 	=> CHIP_SELECT_SPI,
    SCK	  			=> SCK_SPI,
    RW				=> RW_out_spi,
    Read_8bit		=> data_from_spi_int,
    MOSI			=> MOSI
    );
spi3:SPI_SDIO Port Map (
	CLK_SYS         => clk,
    Data_IN         => data_to_module_bus_23,
    Start	        => spi_3wire,
    enable			=> spi_3wire,
	-- OUTPUT --
	CHIP_SELECT     => CHIP_SELECT_SDIO,
    RW				=> RW_out_sdio,
	SCLK	   	    => SCK_SDIO,
    FINISH_WRITE    => write_finish_3,
	FINISH_READ 	=> read_finish_3,
	data_output     => data_from_sdio_int,
  -- INOUT --
    SDIO			=> SDIO
);
data:ram Port Map(
    clk      => clk, 
    next_data=> ram_next_data,
    enable   => ram_enable,
    finish   => ram_finish,
    all_data => data_to_module_bus_22
   );
	
end Structural;