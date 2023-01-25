LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY spi_data_tb IS
END spi_data_tb;
 
ARCHITECTURE behavior OF spi_data_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_data
    PORT(
         clk : IN  std_logic;
         next_data : IN  std_logic;
         finish : OUT  std_logic;
         all_data : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal next_data : std_logic := '0';

 	--Outputs
   signal finish : std_logic;
   signal all_data : std_logic_vector(23 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_data PORT MAP (
          clk => clk,
          next_data => next_data,
          finish => finish,
          all_data => all_data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
      wait for clk_period*10;
		
      -- insert stimulus here 
		next_data <= '0';
		wait for 100 ns;
		next_data <= '1';
		wait for 20 ns;
		next_data <= '0';
		wait for 20 ns;
		next_data <= '1';
		wait for 20 ns;
		next_data <= '0';
      wait;
   end process;

END;
