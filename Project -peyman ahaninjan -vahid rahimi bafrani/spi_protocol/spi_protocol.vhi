
-- VHDL Instantiation Created from source file spi_protocol.vhd -- 18:16:07 12/02/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

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

	Inst_spi_protocol: spi_protocol PORT MAP(
		CLK_SYS => ,
		START => ,
		SCK => ,
		FINISH => ,
		DATA_INPUT => ,
		CHIP_SELECT => ,
		NEXT_DATA => ,
		MOSI => 
	);


