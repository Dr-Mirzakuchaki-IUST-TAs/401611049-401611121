
-- VHDL Instantiation Created from source file spi_data.vhd -- 18:16:48 12/02/2022
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT spi_data
	PORT(
		clk : IN std_logic;
		next_data : IN std_logic;          
		finish : OUT std_logic;
		all_data : OUT std_logic_vector(23 downto 0)
		);
	END COMPONENT;

	Inst_spi_data: spi_data PORT MAP(
		clk => ,
		next_data => ,
		finish => ,
		all_data => 
	);


