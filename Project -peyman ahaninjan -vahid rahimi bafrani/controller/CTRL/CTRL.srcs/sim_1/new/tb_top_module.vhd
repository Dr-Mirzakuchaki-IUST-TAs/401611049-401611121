LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_Top_module IS
END tb_Top_module;
 
ARCHITECTURE behavior OF tb_Top_module IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top_module
    PORT(
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
      MISO			: IN STD_LOGIC;
      CHIP_SELECT_SPI: OUT STD_LOGIC;
      SCK_SPI	  	: OUT STD_LOGIC;
      MOSI			: OUT STD_LOGIC;
      RW_out_spi   :out    std_logic;
      ---SPI 3wire pins
      CHIP_SELECT_SDIO : out std_logic;
      SCK_SDIO	   	: out std_logic;
      RW_out_sdio   :out    std_logic;
      SDIO			: inout std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal M4 : std_logic := '0';
   signal M5 : std_logic := '0';
   signal M6 : std_logic := '0';
   signal clk_sys_in : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');
   signal address_in : std_logic_vector(14 downto 0) := (others => '0');
   signal RW_in : std_logic := '0';
   signal ACP : std_logic := '0';
   signal start_pin : std_logic := '0';
   signal reset : std_logic := '0';
   signal spi_mode : std_logic := '0';
   signal MISO : std_logic := '0';

	--BiDirs
   signal SDA : std_logic;
   signal SDIO : std_logic;

 	--Outputs
   signal configdone : std_logic;
   signal data_output : std_logic_vector(7 downto 0);
   signal SCL : std_logic;
   signal RW_CTL : std_logic;
   signal CHIP_SELECT_SPI : std_logic;
   signal SCK_SPI : std_logic;
   signal MOSI : std_logic;
   signal CHIP_SELECT_SDIO : std_logic;
   signal SCK_SDIO : std_logic;
   signal RW_out_sdio :std_logic;
   signal RW_out_spi  :std_logic;
   -- Clock period definitions
   constant clk_sys_in_period : time := 10 ns;
   constant sck_period : time := 20 ns;
   signal clknum :unsigned(10 downto 0) := (others => '0');
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Top_module PORT MAP (
          M4 => M4,
          M5 => M5,
          M6 => M6,
          clk_sys_in => clk_sys_in,
          data_in => data_in,
          address_in => address_in,
          RW_in => RW_in,
          ACP => ACP,
          start_pin => start_pin,
          reset => reset,
          spi_mode => spi_mode,
          configdone => configdone,
          data_output => data_output,
          SCL => SCL,
          RW_CTL => RW_CTL,
          SDA => SDA,
          MISO => MISO,
          CHIP_SELECT_SPI => CHIP_SELECT_SPI,
          SCK_SPI => SCK_SPI,
          MOSI => MOSI,
          RW_out_spi => RW_out_spi,
          CHIP_SELECT_SDIO => CHIP_SELECT_SDIO,
          SCK_SDIO => SCK_SDIO,
          RW_out_sdio => RW_out_sdio,
          SDIO => SDIO
        );

   -- Clock process definitions
   clk_sys_in_process :process
   
   begin
		clk_sys_in <= '0';
		wait for clk_sys_in_period/2;
		clk_sys_in <= '1';
		clknum <= clknum +1;
		wait for clk_sys_in_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_sys_in_period*10;
		--- write with 3 wire spi
--		M4 <= '0';    -- spi mode
--		spi_mode <= '0'; -- 3-wire
--		RW_in    <= '0'; -- write mode
--		ACP <= '0';   -- atomatice configure off
--		data_in <= "11001010";
--		address_in <= "110010101101111";
--		reset <= '1'; -- reset is actice low
--		start_pin <= '1', '0' after 20ns;
--		wait for 1000 ns;
		
		--- read with 3 wire spi
--		M4 <= '0';    -- spi mode
--		spi_mode <= '0'; -- 3-wire
--		RW_in    <= '1'; -- read mode
--		ACP <= '0';   -- atomatice configure off
--		address_in <= "110010101101101";
--		reset <= '1'; -- reset is actice low
--		start_pin <= '1','0' after 20 ns;
--        wait for 1000 ns;
		 
		--- write with 4 wire spi
--		M4 <= '0';    -- spi mode
--		spi_mode <= '1'; -- 4-wire
--		RW_in    <= '0'; -- write mode -- with starting configuration
--		ACP <= '0';   -- atomatice configure off
--		data_in <= "11001010";
--		address_in <= "110010101101111";
--		reset <= '1'; -- reset is actice low
--		start_pin <= '1', '0' after 20ns;
--		wait for 1000 ns;
		

--		--- read with 4 wire spi
--		M4 <= '0';    -- spi mode
--		spi_mode <= '1'; -- 4-wire
--		RW_in    <= '1'; -- read mode -- with starting configuration
--		ACP <= '0';   -- atomatice configure off
--		address_in <= "110010101101111";
--		reset <= '1'; -- reset is actice low
--		start_pin <= '1', '0' after 20ns;
				
		
		--- write with i2c
--		M4 <= '1';    -- I2C mode
--		M5 <= '0';    -- Address selection bit 
--		M6 <= '0';    -- Address selection bit 
--		RW_in    <= '0'; -- write mode 
--		ACP <= '0';   -- atomatice configure off
--		data_in <= "11001010";
--		address_in <= "110010101101111";
--		reset <= '1'; -- reset is actice low
--		start_pin <= '1', '0' after 20ns;		
		
		
		
		--- read with i2c
--		M4 <= '1';    -- I2C mode
--		M5 <= '0';    -- Address selection bit 
--		M6 <= '0';    -- Address selection bit 
--		RW_in    <= '1'; -- read mode 
--		ACP <= '0';   -- atomatice configure off
--		address_in <= "110010101101111";
--		reset <= '1'; -- reset is actice low
--		start_pin <= '1', '0' after 20ns;
		
		
		
		--- atomatic configure process
--		M4 <= '0';    -- SPI mode
--		RW_in    <= '0'; -- write mode 
--		ACP <= '1';   -- atomatice configure off
--		spi_mode <= '0'; -- 3-wire		
--		reset <= '1'; -- reset is actice low
--		start_pin <= '1', '0' after 20ns;
--		SDA   <= '1' after 235 ns,'0' after 280 ns;
		
      -- insert stimulus here 

      wait;
   end process;
   SDIO <= 'Z' when RW_out_sdio = '0' else  '1' after  sck_period   ,  '0' after sck_period*2,
											'1' after sck_period*3  ,  '0' after sck_period*4,
											'1' after sck_period*5  ,  '0' after sck_period*6,
											'1' after sck_period*7  ,  '0' after sck_period*8;
   MISO <= 'Z' when RW_out_spi = '0' else   '1' after sck_period*17 ,  '0' after sck_period*18,
											'1' after sck_period*19 ,  '0' after sck_period*20,
											'1' after sck_period*21 ,  '0' after sck_period*22,
											'1' after sck_period*23 ,  '0' after sck_period*24;
   SDA  <= 'Z' when RW_CTL = '0' else '0';
   

END;