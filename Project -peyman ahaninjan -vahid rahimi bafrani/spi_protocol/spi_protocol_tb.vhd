LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 USE ieee.numeric_std.ALL;
 
ENTITY spi_protocol_tb IS
END spi_protocol_tb;
 
ARCHITECTURE behavior OF spi_protocol_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_protocol
    PORT(
         CLK_SYS : IN  std_logic;
         START : IN  std_logic;
         SCK : IN  std_logic;
         FINISH : IN  std_logic;
         DATA_INPUT : IN  std_logic_vector(23 downto 0);
         CHIP_SELECT : OUT  std_logic;
         NEXT_DATA : OUT  std_logic;
         MOSI : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_SYS : std_logic := '0';
   signal START : std_logic := '0';
   signal SCK : std_logic := '0';
   signal FINISH : std_logic := '0';
   signal DATA_INPUT : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal CHIP_SELECT : std_logic;
   signal NEXT_DATA : std_logic;
   signal MOSI : std_logic;

   -- Clock period definitions
   constant CLK_SYS_period : time := 40 ns;
	constant SCK_period : time := 40 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_protocol PORT MAP (
          CLK_SYS => CLK_SYS,
          START => START,
          SCK => SCK,
          FINISH => FINISH,
          DATA_INPUT => DATA_INPUT,
          CHIP_SELECT => CHIP_SELECT,
          NEXT_DATA => NEXT_DATA,
          MOSI => MOSI
        );

   -- Clock process definitions
   CLK_SYS_process :process
   begin
		CLK_SYS <= '0';
		wait for CLK_SYS_period/2;
		CLK_SYS <= '1';
		wait for CLK_SYS_period/2;
   end process;
	
	 SCK_process :process
		begin
			SCK <= '0';
			wait for SCK_period/2;
			SCK <= '1';
			wait for SCK_period/2;
		end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_SYS_period*10;

      -- insert stimulus here 
			data_input <= "101010101010101010101010";
			start <= '1';
			finish <= '0';
			wait until next_data = '1';
			data_input <= "000000000000111100001111";
			wait until next_data = '1';
			finish <= '1';
			data_input <= "111111111111111111111111";
		wait;
   end process;

END;
