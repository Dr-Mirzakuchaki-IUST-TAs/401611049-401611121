library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ram is
port (
		
		clk      : IN  STD_LOGIC; 
		next_data: IN  STD_logic;
		enable   : IN  STD_LOGIC;
		finish   : OUT STD_LOGIC;
		all_data : OUT std_logic_vector(22 downto 0)
	   );
end ram;

architecture Behavioral of ram is
--
type t_Data is array (0 to 1) of std_logic_vector(22 downto 0);
--
signal finish_int : std_logic := '0';
signal data_int : std_logic_vector(22 downto 0) ;
signal enable_int   : std_logic := '0';
signal r_data : t_Data := ((others => '0'),(others => '1'));

--control
signal new_data_flag : std_logic := '0';
signal counter : integer := 0;
begin
	all_data <= data_int;
	finish <= finish_int;
	process(clk)
		begin
		 if(rising_edge(clk)) then
			  enable_int <= enable;
			 if (enable_int = '1') then
				if(next_data = '1' and new_data_flag = '0' and finish_int = '0') then 
					data_int <= r_data(counter);
					counter <= counter + 1;
					new_data_flag <= '1';
				elsif(next_data = '0' and new_data_flag ='1') then
					new_data_flag <= '0';
				end if;
				if(counter = 2) then
					data_int <= "11110000111100001111000";
					counter <=0;
					finish_int <= '1';
				end if;
             else 
                 data_int   <= (others => 'Z');
			 end if;
		 end if;
	end process;
end Behavioral;

