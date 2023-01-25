LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_spi_protocol IS
END tb_spi_protocol;
 
ARCHITECTURE behavior OF tb_spi_protocol IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_protocol
    PORT(
         CLK_SYS : IN  std_logic;
         START : IN  std_logic;
         SCK : OUT  std_logic;
         DATA_INPUT : IN  std_logic_vector(23 downto 0);
         RW: OUT  std_logic;
         FINISH_WRITE : OUT  std_logic;
         FINISH_READ : OUT  std_logic;
         CHIP_SELECT : OUT  std_logic;
         Read_8bit : OUT  std_logic_vector(7 downto 0);
         MOSI : OUT  std_logic;
         MISO : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_SYS : std_logic := '0';
   signal START : std_logic := '0';
   signal SCK : std_logic := '0';
   signal DATA_INPUT : std_logic_vector(23 downto 0) := (others => '0');
   signal MISO : std_logic := '0';
 	--Outputs
   signal FINISH_WRITE : std_logic;
   signal FINISH_READ : std_logic;
   signal CHIP_SELECT : std_logic;
	signal RW: std_logic;
   signal MOSI : std_logic;
	signal Read_8bit : std_logic_vector(7 downto 0);
  -- signal register_read : std_logic_vector(7 downto 0);
	signal counter_new : UNSIGNED(4 downto 0)				     		   := "10111";
	signal counter_2clk : UNSIGNED(1 downto 0)				     		   := "00";
   -- Clock period definitions
   constant CLK_SYS_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_protocol PORT MAP (
          CLK_SYS => CLK_SYS,
          START => START,
          SCK => SCK,
          DATA_INPUT => DATA_INPUT,
          RW=> RW,
          FINISH_WRITE => FINISH_WRITE,
          FINISH_READ => FINISH_READ,
          CHIP_SELECT => CHIP_SELECT,
          Read_8bit => Read_8bit,
          MOSI => MOSI,
          MISO => MISO
        );

   -- Clock process definitions
	
	CLK_SYS_process :process
   begin
		CLK_SYS <= '0';
		wait for CLK_SYS_period/2;
		CLK_SYS <= '1';
		wait for CLK_SYS_period/2;
   end process;
 

   -- Stimulus process
   process(CLK_SYS)
   begin		
      -- hold reset state for 100 ns.
      
		
      -- insert stimulus here 
		start <= '1';
		DATA_INPUT <= "111110000101010010010101";
	   if CHIP_SELECT = '0' then
		 counter_2clk <= counter_2clk+1;
		 if counter_2clk = 3 then
		  counter_new <= counter_new-1;
		  counter_2clk <= "00";
		 end if;
		 if counter_new = 0 then
			counter_new <= "10111";
			miso <= 'Z';
		 end if;
		 if counter_new <= 7 then
			miso <= DATA_INPUT(to_integer(counter_new));
		 end if;
		
	   end if;
    --  wait;
   end process;
--		miso <= 							'1' 					      			,	'0' after CLK_SYS_period ,
--											'1' after CLK_SYS_period*2 	   ,  '0' after CLK_SYS_period*6 ,
--											'1' after CLK_SYS_period*8       ,  '0' after CLK_SYS_period*10 ,
--										   '0' after CLK_SYS_period*12			,  '1' after CLK_SYS_period*16;

	
--process ( CLK_SYS)
--begin
-- if rising_edge(CLK_SYS) then
--    	start <= '1';
--		DATA_INPUT <= "111110000101010010010101";
--	if CHIP_SELECT = '0' then
--	    --counter_new <= counter_new-1;
--		 if  RW = '1' then
--			 miso <= DATA_INPUT(to_integer(counter_new));
--		 end if;
--		 if RW = '0' then
--			 miso <= 'Z';
--		 end if;
--	end if;
--end if;
--end process;

END;
