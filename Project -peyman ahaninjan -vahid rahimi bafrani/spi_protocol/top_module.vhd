library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity top_module is
port (
		CLK_SYS 		: IN  STD_LOGIC;
		START   		: IN  STD_LOGIC;
		SCK	  		: IN  STD_LOGIC;
		mosi			: OUT std_logic;
		CHIP_SELECT : OUT STD_LOGIC
);
end top_module;

architecture Behavioral of top_module is
SIGNAL CLK_SYS_INT     		: STD_LOGIC									      := '0';
signal NEXT_DATA_INT			: STD_LOGIC											:= '0';
SIGNAL DATA_INPUT_INT		: STD_LOGIC_VECTOR(23 downto 0)			   := (others => '0');
signal finish_int				: STD_LOGIC;
signal start_int 				: STD_logic;
signal chip_select_int 		: std_logic;

--- components---

	COMPONENT spi_protocol
	PORT(
		CLK_SYS : IN std_logic;
		START : IN std_logic;
		SCK : IN std_logic;
		FINISH : IN std_logic;
		DATA_INPUT : IN std_logic_vector(23 downto 0);          
		CHIP_SELECT : OUT std_logic;
		NEXT_DATA : OUT std_logic;
		MOSI : OUT std_logic
		);
	END COMPONENT;
	
  COMPONENT spi_data
	PORT(
		clk : IN std_logic;
		next_data : IN std_logic;          
		finish : OUT std_logic;
		all_data : OUT std_logic_vector(23 downto 0)
		);
	END COMPONENT;
	
begin
chip_select <= chip_select_int;
start_int <= start;
CLK_SYS_INT <= CLK_SYS;

Inst_spi_data: spi_data PORT MAP(
		clk => CLK_SYS_INT,
		next_data => NEXT_DATA_INT,
		finish =>finish_int ,
		all_data => DATA_INPUT_INT
	);


Inst_spi_protocol: spi_protocol PORT MAP(
		CLK_SYS => CLK_SYS_INT,
		START => START_int ,
		SCK => SCK,
		FINISH => finish_int,
		DATA_INPUT => DATA_INPUT_INT,
		CHIP_SELECT => chip_select_int,
		NEXT_DATA => NEXT_DATA_INT,
		MOSI => mosi
	);
end Behavioral;

