
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY top_module_tb IS
END top_module_tb;
 
ARCHITECTURE behavior OF top_module_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_module
    PORT(
         CLK_SYS : IN  std_logic;
         START : IN  std_logic;
         SCK : IN  std_logic;
         mosi : OUT  std_logic;
         CHIP_SELECT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_SYS : std_logic := '0';
   signal START : std_logic := '0';
   signal SCK : std_logic := '0';

 	--Outputs
   signal mosi : std_logic;
   signal CHIP_SELECT : std_logic;

   -- Clock period definitions
   constant CLK_SYS_period : time := 40 ns;
	constant SCK_period : time := 40 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_module PORT MAP (
          CLK_SYS => CLK_SYS,
          START => START,
          SCK => SCK,
          mosi => mosi,
          CHIP_SELECT => CHIP_SELECT
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
		start <= '1';
		wait for 20000 ns;
		start <= '0';
		wait for 20 ns;
		start <= '0';
      wait;
   end process;

END;
