library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity I2C_tb is

end I2C_tb;

architecture Behavioral of I2C_tb is
Component i2c_module 
        Port (
          ---
          CLK_sys   :in     STD_LOGIC;
          Enable    :in     STD_LOGIC;
          RW        :in     STD_LOGIC;
          ---
          SCL       :out    STD_LOGIC;
          RW_CTL    :out    STD_LOGIC;
          ---
          SDA       :inout  STD_LOGIC;
          ---
          Data_Input:in     STD_LOGIC_VECTOR(23 downto 0);
          Data_Output:out   STD_LOGIC_VECTOR(7 downto 0);
          ---
          address_sel0:in   STD_LOGIC;
          address_sel1:in   STD_LOGIC
     );
end component;
signal CLK_sys,Enable,RW,SCL,RW_CTL,SDA,address_sel0,address_sel1   :std_logic;
signal Data_Input                                                   :STD_LOGIC_VECTOR(23 downto 0);
signal Data_Output                                                  :STD_LOGIC_VECTOR(7 downto 0);
begin
i2c_module port map( 
          CLK_sys       =>  Clk_sys;
          Enable        =>  Enable;
          RW            =>  RW;
          SCL           =>  SCL;
          RW_CTL        =>  RW_CTL;
          SDA           =>  SDA;
          Data_Input    =>  Data_input;
          Data_Output   =>  Data_Output;
          address_sel0  =>  address_sel0;
          address_sel1  =>  address_sel1);
process 
variable clk_time := 10 ns;
begin
    wait for clk_time/2;
    clk_sys = '1';
    wait for clk_time/2;
    clk_sys = '0';
end process;
    

end Behavioral;
