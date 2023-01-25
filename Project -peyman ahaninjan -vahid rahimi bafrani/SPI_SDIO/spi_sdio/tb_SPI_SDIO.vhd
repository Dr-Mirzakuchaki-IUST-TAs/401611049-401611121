LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_SPI_SDIO IS
END tb_SPI_SDIO;
 
ARCHITECTURE behavior OF tb_SPI_SDIO IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SPI_SDIO
    PORT(
         CLK_SYS : IN  std_logic;
         Data_IN : IN  std_logic_vector(23 downto 0);
         Start : IN  std_logic;
         CHIP_SELECT : OUT  std_logic;
         RW : OUT  std_logic;
			SCLK : OUT  std_logic;
         SDIO : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_SYS : std_logic := '0';
   signal Data_IN : std_logic_vector(23 downto 0) := (others => '0');
   signal Start : std_logic := '0';
	--BiDirs
   signal SDIO : std_logic;

 	--Outputs
   signal CHIP_SELECT : std_logic;
   signal RW : std_logic;
   signal SCLK : std_logic := '0';
   -- Clock period definitions
   constant CLK_SYS_period : time := 10 ns;
   --constant SCLK_period 	: time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPI_SDIO PORT MAP (
          CLK_SYS => CLK_SYS,
          SCLK => SCLK,
          Data_IN => Data_IN,
          Start => Start,
          CHIP_SELECT => CHIP_SELECT,
          RW => RW,
          SDIO => SDIO
        );

   -- Clock process definitions
   CLK_SYS_process :process
   begin
		CLK_SYS <= '0';
		wait for CLK_SYS_period/2;
		CLK_SYS <= '1';
		wait for CLK_SYS_period/2;
   end process;
 
--   SCLK_process :process
--   begin
--		SCLK <= '0';
--		wait for SCLK_period/2;
--		SCLK <= '1';
--		wait for SCLK_period/2;
--   end process;
 

   -- Stimulus process
   all_data: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_SYS_period*10;

      -- insert stimulus here 
		start <= '1';
		Data_in <= "111100001111101011001011";
      wait;
   end process all_data;
SDIO <= 'Z' when RW = '0' else 	'1' 					      			,	'0' after CLK_SYS_period ,
											'1' after CLK_SYS_period*2 	   ,  '0' after CLK_SYS_period*6 ,
											'1' after CLK_SYS_period*8       ,  '0' after CLK_SYS_period*10 ;
END;
