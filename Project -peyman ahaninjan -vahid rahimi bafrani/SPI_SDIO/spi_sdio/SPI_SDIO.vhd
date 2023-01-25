library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SPI_SDIO is
port (
	--	INPUT --
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
end SPI_SDIO;

architecture Behavioral of SPI_SDIO is
--in/out regestring--
signal CHIP_SELECT_int : std_logic 							:= '1';
signal RW_INT			  : std_logic 							:= '0';
signal Data_In_INT	  : std_logic_vector(7 downto 0) := (others => '0');
signal start_int		  : std_logic							:= '0';
signal Clk_bit         : std_logic							:= '0';
signal SCLK_INT		  : std_logic							:= '0';
signal FINISH_WRITE_Int : std_logic							:= '0';
signal FINISH_READ_Int  : std_logic							:= '0';
signal enable_int		: std_logic                         := '0';
-- spi counter--
signal bit_counter	  :  unsigned( 4 downto 0)			:= "01111";
signal data_counter	  :  unsigned( 4 downto 0)			:= "00111";
-- internal signals--
signal Rx_data 		 	 : std_logic_vector(7 downto 0)  := (others => '0');
signal instruction_bits	 : std_logic_vector(15 downto 0) := (others => '0');
signal TX				 	 : std_logic 							:= 'Z';

-- spi state--
type FSM is (idle,instruction,write_st,read_st,delay_instruction,delay_read);
signal state			: FSM									:= idle;
begin

	CHIP_SELECT <= CHIP_SELECT_int;
	RW          <= RW_INT;
	SCLK        <= SCLK_INT;
	SDIO        <= Tx when RW_INT ='0' else 'Z';
   FINISH_READ <= FINISH_READ_Int;
	FINISH_WRITE <= FINISH_WRITE_Int;
process (CLK_SYS)
   begin
     if(falling_edge(CLK_SYS)) then
            if(clk_bit = '0') then
					SCLK_INT <= '0';
				else
					SCLK_INT <= '1';
				end if;
				clk_bit	<= not clk_bit;
     end if;
end process;

	process(CLK_SYS)
	begin
	
	if rising_edge(CLK_SYS) then
	 if (clk_bit = '1') then
		Data_In_INT <= Data_IN(7 downto 0);
		instruction_bits <= Data_IN(23 downto 8);
		start_int <= Start;
		enable_int <= enable;
	  if (enable_int = '1') then
		case state is
			when  idle =>
				RW_int <= '0';
				bit_counter <= "01111";
				Tx <= 'Z';
				RX_data <= (others => '0');
				FINISH_READ_Int <= '0';
				FINISH_WRITE_int    <= '0';
				if start_int = '1' then
					state <= delay_instruction;
					CHIP_SELECT_int <= '0';
					
			  else 
					state <= idle;
					CHIP_SELECT_int <= '1';
			  end if;
		  when delay_instruction =>
				
				state           <= instruction;
				RW_Int			 <= '0';
				FINISH_READ_Int <= '0';
				FINISH_WRITE_int    <= '0';
				CHIP_SELECT_int <= '0';
				Tx					 <= instruction_bits(to_integer(bit_counter));
				bit_counter 	 <= bit_counter -1;
				RX_data         <= (others => '0');
				
		 when instruction =>
				RW_int			 <= '0';
				FINISH_READ_Int <= '0';
				FINISH_WRITE_int    <= '0';
				CHIP_SELECT_int <= '0';
				Tx					 <= instruction_bits(to_integer(bit_counter));
				RX_data         <= (others => '0');
				--
				if bit_counter /= 0 then
					state 			 <= instruction;
					bit_counter 	 <= bit_counter -1;
				else
				--
					bit_counter 	 <= "01111";
					
					if instruction_bits(15) = '0'  then
						state <= write_st;
					else
						state <= delay_read;
					end if;
					
			  end if;
				
		 when write_st =>
					RW_int			 <= '0';
					CHIP_SELECT_int <= '0';
					Tx					 <= Data_In_INT(to_integer(data_counter));
					RX_data         <= (others => '0');
					if data_counter /= 0 then
						state 		 <= write_st;
						data_counter <= data_counter -1;
					else
					state 			     <= idle;
				    FINISH_WRITE_int    <= '1';
					data_counter 	     <= "00111";
					end if;
		when	delay_read =>
					state 		   								   <= read_st;
					RW_INT		   							      <= '1';
					CHIP_SELECT_int								  	<= '0';
					Tx					 									<= 'Z';
					bit_counter 									   <= bit_counter -1;
					RX_data(to_integer(data_counter))			<= SDIO;
		when read_st =>
		
					RW_INT											   <= '1';
					CHIP_SELECT_int 									<= '0';
					Tx					 									<= 'Z';
					RX_data(to_integer(data_counter))			<= SDIO;
					if (data_counter /= 0) then
					   state 		 <= read_st;
					   data_counter <= data_counter -1;
					else
					   state 			 <= idle;
					   data_output      <= RX_data;
					   FINISH_READ_Int  <= '1';
					   data_counter 	 <= "00111";
					
					end if;
		 end case;
		 else
		      sdio <= 'Z';
		      data_output <= (others => 'Z');
     end if;
    end if;
    end if;
end process;

end Behavioral;

