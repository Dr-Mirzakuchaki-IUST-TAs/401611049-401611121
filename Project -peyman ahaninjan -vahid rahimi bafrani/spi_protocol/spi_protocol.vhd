library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_protocol is
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
end spi_protocol;

architecture Behavioral of spi_protocol is

-- IN/OUT

SIGNAL CLK_SYS_INT     				: STD_LOGIC									      := '0';
SIGNAL CHIP_SELECT_INT 				: STD_LOGIC										   := '1';
SIGNAL MOSI_INT		  				: STD_LOGIC    		  						   := '0';
signal MISO_INT						: STD_LOGIC											:= '0';
SIGNAL START_INT		  				: std_logic 										:= '0';
SIGNAL DATA_INPUT_INT				: STD_LOGIC_VECTOR(23 downto 0)			   := (others => '0');
signal enable_int					: std_logic								   := '0';
--signal complete_data					: STD_LOGIC_VECTOR(23 downto 0)			   := (others => '0');
signal Read_8bit_Int					: STD_LOGIC_VECTOR(7 downto 0)			   := (others => '0');
signal finish_write_int				: STD_LOGIC											:='0';
signal finish_read_int				: STD_LOGIC											:='0';
signal SCK_int	  						: STD_LOGIC											:='0';
signal RW_INT							: STD_LOGIC											:='0';
signal SCK_int_PRV					:STD_LOGIC											:='0';
--signal read_register				   :STD_LOGIC_VECTOR (7 downto 0)				:= (others => '0');
--signal data_chapter					:STD_LOGIC_VECTOR (7 downto 0)				:= (others => '0');

-- control signal	
signal COUNTER 		  : UNSIGNED(4 downto 0)				     		   := "10111";
signal Clk_bit         : std_logic								     		   := '0';
-- state--
type FSM is (IDLE,instruction,write_st,delay_instruction,delay_cs,delay_finish,read_st);
signal	STATE		: FSM														      := IDLE;	
--
begin
---
CHIP_SELECT  <= CHIP_SELECT_INT;
MOSI 			 <= MOSI_INT;
FINISH_WRITE <= finish_write_int;
FINISH_READ  <= finish_read_int;
Read_8bit    <= Read_8bit_Int;
SCK			 <= SCK_Int;
RW			 <=RW_INT;
---
process (CLK_SYS)
    begin
       if(falling_edge(CLK_SYS)) then
            if(clk_bit = '0') then
					sck_int <= '0';
				else
					sck_int <= '1';
				end if;
				clk_bit	<= not clk_bit;
        end if;
end process;

process(clk_sys)
begin
  IF(RISING_EDGE(CLK_SYS)) THEN
	 if ( clk_bit = '1') then
		DATA_INPUT_INT <= DATA_INPUT;
		MISO_INT <= MISO;
		START_INT <= START;
		enable_int <= enable;
	    if (enable_int = '1') then
			case state is
				when idle =>
					mosi_int <= '0';
					counter  <= "10111";
					RW_INT   <= DATA_INPUT_INT(23);
					finish_read_int  <= '0';
					finish_write_int <= '0';
					
					if (start_int = '1') then 
						state <= delay_instruction;
						chip_select_int <= '0';
					else 
						state <= idle;
						chip_select_int <= '1';
					end if;
				when delay_instruction =>
						state <= instruction;
						chip_select_int <= '0';
						mosi_int <= DATA_INPUT_INT(to_integer(counter));
						counter <= counter - 1;
						RW_INT   <= DATA_INPUT_INT(23);
						Read_8bit_Int <= (others => '0');
				when instruction =>
					chip_select_int <= '0';
					mosi_int <= DATA_INPUT_INT(to_integer(counter));
					RW_INT	 <= DATA_INPUT_INT(23);
					Read_8bit_Int <= (others => '0');
					if (counter /= 8) then
						state <= instruction;
						counter <= counter-1;
					else
						
						if DATA_INPUT_INT(23) ='0' then
							state		<= write_st;
							counter     <= "00111";
							
						else
							state    <= read_st;
							counter  <= "01000" ;
						end if;  
					end if;
				when write_st =>
					   chip_select_INT <= '0';
						mosi_int <= DATA_INPUT_INT(to_integer(counter));
						miso_int <= 'Z';
						RW_INT	 <= DATA_INPUT_INT(23);
						Read_8bit_Int <= (others => '0');
					if( counter /= 0) then 
						state <= write_st;
						counter <= counter - 1;
					else 
						state <= delay_cs;
						counter <= "10111";
					end if;
				when read_st =>
						chip_select_INT <= '0';
						mosi_int <= 'Z';
						
						Read_8bit_Int <= Read_8bit_Int(6 downto 0) & miso_int;
						if( counter /= 0) then 
						state <= read_st;
						counter <= counter - 1;
					   else 
						state <= delay_cs;
						counter <= "10111";
					   end if;
						
				when delay_cs =>
					---
					state 			 <= delay_finish;
					chip_select_int <= '1';
					mosi_int 		 <= '0';
					counter 			 <= "10111";
					---	
				when delay_finish =>
					chip_select_int <= '1';
					state<= idle;
					if DATA_INPUT_INT(23) = '0' then
						finish_write_int <= '1';
					else 
						finish_read_int <= '1';
					end if;
		  end case;
		  else
		      read_8bit_int   <= (others => 'Z');
		      chip_select_int <= '1';
		end if;
	 end if;
  end if;
	end process;
end Behavioral;

