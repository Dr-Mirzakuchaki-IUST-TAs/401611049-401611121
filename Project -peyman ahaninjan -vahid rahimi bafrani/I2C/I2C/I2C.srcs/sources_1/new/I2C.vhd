library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_module is
    Port (
          ---
          CLK_sys   :in     STD_LOGIC;
          Enable    :in     STD_LOGIC;
          RW        :in     STD_LOGIC;
          ---
          SCL           :out    STD_LOGIC;
          RW_CTL        :out    STD_LOGIC;
          write_finish  :out    std_logic;
          read_finish   :out    std_logic;
          ---
          SDA       :inout  STD_LOGIC;
          ---
          Data_Input:in     STD_LOGIC_VECTOR(22 downto 0);
          Data_Output:out   STD_LOGIC_VECTOR(7 downto 0);
          ---
          address_sel :in   STD_LOGIC_VECTOR(1 downto 0)
     );
end i2c_module;

architecture Behavioral of i2c_module is
--- In/Out internal signals
    signal Enable_int       :STD_LOGIC      :='0';
    signal SCL_int          :STD_LOGIC      :='0';
    signal RW_int           :STD_LOGIC      :='0';
    signal RW_CTL_int       :STD_LOGIC      :='0';
    signal Data_Input_int   :STD_LOGIC_VECTOR(23 downto 0)  :=(others => '0');
    signal address_int      :STD_LOGIC_vector(1 downto 0)   :="00";
    signal write_finish_int :std_logic;
    signal read_finish_int  :std_logic;
    signal data_output_int  :std_logic_vector(7 downto 0);
--- Internal signals
    signal SCL_Ena      :STD_LOGIC      :='0';
    signal SDA_CLK      :STD_LOGIC      :='0';
    signal SDA_CLK_prv  :STD_LOGIC      :='0';
    signal Tx           :STD_LOGIC      :='1';
    signal Address_RW   :STD_LOGIC_VECTOR(7 downto 0)   := (others =>'0');
    signal Data_Rx      :STD_LOGIC_VECTOR(7 downto 0)   := (others =>'0');
--- Counter 
    signal Bit_CNT      :unsigned (2 downto 0)  :=(others => '1');
    signal Byte_CNT     :unsigned (1 downto 0)  :="10";
    signal Count        :integer  := 0;
--- State Machine
    type FSM is (idle,start,write_s,read_s,slv_ack1,slv_ack2,mas_ack,mack_del,sack1_del,sack2_del,command,stop);
    signal State    :FSM    :=idle;
--- Constants
    constant Address0   :STD_LOGIC_VECTOR(6 downto 0) := "1001000";
    constant Address1   :STD_LOGIC_VECTOR(6 downto 0) := "1001001";
    constant Address2   :STD_LOGIC_VECTOR(6 downto 0) := "1001010";
    constant Address3   :STD_LOGIC_VECTOR(6 downto 0) := "1001011";
    
    
begin
---
    SCL             <=  '0' when (SCL_Ena='1' AND SCL_Int = '0') else '1';
    RW_CTL          <=  RW_CTL_int;
    address_int     <=  address_sel;
    Data_Input_Int  <=  '0' & Data_Input;
    SDA             <=  Tx when RW_CTL_Int = '0' else 'Z';
    write_finish    <=  write_finish_int;
    read_finish     <=  read_finish_int;
    data_output      <=  data_output_int;
---
SCL_SDA_CLK_Gen: process (CLK_SYS)
    ---
    ---
    begin 
       if(rising_edge(CLK_SYS)) then
            SDA_CLK_Prv <= SDA_CLK;
            if (Count = 799) then
                Count <= 0;
            else
                Count <= Count + 1;
            end if;
            ---
            case Count is
                ---
                when 0 to 199   =>
                    SCL_Int <='0';
                    SDA_CLK <='0';
                when 200 to 399 =>
                    SCL_Int <='0';
                    SDA_CLK <='1';
                when 400 to 599 =>
                    SCL_Int <='1';
                    SDA_CLK <='1';
                when others =>
                    SCL_Int <='1';
                    SDA_CLK <='0';
            end case;
        end if;
    end process SCL_SDA_CLK_Gen;
Data_Transfering_pro:process(CLK_SYS)
    begin
        if(rising_edge(CLK_SYS)) then
            Enable_Int  <= Enable;
            RW_Int      <= RW;
            if(SDA_CLK_Prv = '0' AND SDA_CLK = '1') then 
                case State is
                    when idle   =>
                        RW_CTL_Int  <= '0';
                        Bit_CNT     <=(others => '1');
                        Byte_CNT    <="10";
                        Data_Rx     <=(others => '0');
                        data_output_int <= (others  => 'Z');
                        write_finish_int    <= '0';
                        read_finish_int     <= '0';
                        if(Enable_Int = '1') then
                            State       <=  start;
                            Tx          <=  '0';
                            case address_int is
                                when "00" => Address_RW <= Address0 & RW_int;
                                when "01" => Address_RW <= Address1 & RW_int;
                                when "10" => Address_RW <= Address2 & RW_int;
                                when "11" => Address_RW <= Address3 & RW_int;
                                when others =>  Address_RW <= (others   =>  '0');
                            end case;
                        else 
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                        end if;
                    when start  =>
                        if(Enable_Int = '1') then
                            State       <= command;
                            RW_CTL_Int  <= '0';
                            Byte_CNT    <="10";
                            Tx          <= Address_RW(to_integer(Bit_CNT));
                            Bit_CNT     <= Bit_CNT - 1;
                            Address_RW  <= Address_RW;
                            Data_Rx     <= (others => '0');
                        else
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            data_output_int <= (others  => 'Z');
                        end if;
                    when command  =>
                        if(Enable_int = '1') then
                            RW_CTL_Int  <= '0';
                            Byte_CNT    <="10";
                            Tx          <= Address_RW(to_integer(Bit_CNT));
                            Address_RW  <= Address_RW;
                            Data_Rx     <= (others => '0');
                            if(Bit_CNT = 0) then
                                State   <= slv_ack1;
                                Bit_CNT <= (others => '1');
                            else
                                State   <= command;
                                Bit_CNT <= Bit_CNT - 1;
                            end if;
                        else
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            data_output_int <= (others  => 'Z');
                        end if;
                    when slv_ack1  =>
                        if(Enable_int = '1') then
                            State       <=  sack1_del;
                            RW_CTL_Int  <=  '1';
                            Tx          <=  '1';
                            Bit_CNT     <=  (others => '1');
                            Byte_CNT    <="10";
                            Address_RW  <=  Address_RW;
                            Data_Rx     <=  (others => '0');    
                        else
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            data_output_int <= (others  => 'Z');
                        end if;
                    when sack1_del  =>
                        if(Enable_int = '1' and SDA = '0') then
                            --- acknowledged
                            write_finish_int    <=  '0';
                            RW_CTL_INT          <= '0';
                            Bit_CNT     <=  Bit_CNT - 1;
                            Address_RW  <=  Address_RW;
                            if (Address_RW(0)='0') then
                                State       <=  write_s;
                                RW_CTL_Int  <=  '0';
                                Tx          <=  Data_Input_Int(8 * to_integer(Byte_CNT)+ to_integer(Bit_CNT));
                                Data_Rx     <=  (others => '0');
                            else
                                State   <=  read_s;
                                RW_CTL_Int  <=  '1';
                                Tx          <=  '1';
                                Data_Rx(to_integer(Bit_CNT)) <= SDA;
                            end if;
                        else
                        
                            State       <=  Stop;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            Byte_CNT    <= "10";
                            BIt_CNT     <= (others => '1');
                            write_finish_int <= '0';
                            data_output_int <= (others  => 'Z');
                            Data_RX     <= (others => '0');
                        end if;
                    when write_s    =>
                        if(enable_int = '1') then
                            write_finish_int    <=  '0';
                            RW_CTL_Int  <=  '0';
                            Tx          <=  Data_Input_Int(8 * to_integer(Byte_CNT)+ to_integer(Bit_CNT));
                            Address_RW  <=  Address_RW;
                            Data_RX     <=  (others => '0');
                            if (Bit_CNT = 0) then
                                State   <=  slv_ack2;
                                Bit_CNT <=  (others => '1');
                            else
                                State   <=  write_s;
                                Bit_CNT <=  Bit_CNT -1;
                            end if;
                        else
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            data_output_int <= (others  => 'Z');
                        end if;
                    when slv_ack2   =>
                        if(Enable_int = '1') then
                            RW_CTL_Int  <=  '1';
                            Tx          <=  '1';
                            write_finish_int <= '1';
                            Byte_CNT    <= Byte_CNT - 1;
                            Bit_CNT     <=  (others =>  '1');
                            Address_RW  <=  Address_RW;
                            Data_Rx     <=  (others =>  '0');
                            State       <=  sack2_del;
                           
                        else
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            data_output_int <= (others  => 'Z');
                        end if;
                    when sack2_del  =>
                        write_finish_int    <=  '0';
                        Data_Rx     <=  (others => '0');
                        if (Enable_int = '1' and SDA = '0') then
                            case address_int is
                                when "00" => Address_RW <= Address0 & RW_int;
                                when "01" => Address_RW <= Address1 & RW_int;
                                when "10" => Address_RW <= Address2 & RW_int;
                                when "11" => Address_RW <= Address3 & RW_int;
                                when others =>  Address_RW <= (others   =>  '0');
                            end case;
                            if(Address_RW = Address0 & RW_Int or Address_RW = Address1 & RW_Int or Address_RW = Address2 & RW_Int or Address_RW = Address3 & RW_Int) then
                                State       <= write_s;
                                RW_CTL_Int  <= '0';
                                Tx          <= Data_Input_Int(8 * to_integer(Byte_CNT)+ to_integer(Bit_CNT));
                                Bit_CNT     <= Bit_CNT - 1;
                            else 
                                State       <=  Start;
                                RW_CTL_Int  <=  '0';
                                Tx          <=  '1';
                                Bit_CNT     <= (others  => '1');
                            end if;
                        else
                            State       <=  stop;
                            RW_CTL_Int  <= '0';
                            Bit_CNT     <= (others => '1');
                            Address_RW  <= (others => '0');
                            Data_RX     <= (others => '0');
                            data_output_int <= (others  => 'Z');
                        end if;
                    when read_s     =>
                        if(Enable_int = '1') then
                            RW_CTL_Int                      <= '1';
                            TX                              <= '1';
                            Address_RW                      <=  Address_RW;
                            Data_Rx(to_integer(Bit_CNT))    <=  SDA;
                            if (Bit_CNT = 0) then
                                State   <= mas_ack;
                                Bit_CNT <= (others => '1');
                            else
                                State   <=  read_s;
                                BIt_CNT <=  Bit_CNT - 1;
                            end if;
                        else
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            data_output_int <= (others  => 'Z');
                        end if;
                     when mas_ack   =>
                        if(enable_int = '1') then
                            State           <=  mack_del;
                            data_output_int <=  Data_rx;
                            read_finish_int <=  '1';
                            RW_CTL_Int      <=  '0';
                            Tx              <=  '0';
                            Bit_CNT         <=  (others => '1');
                            Address_RW      <=  Address_RW;
                            Data_RX         <=  Data_Rx;
                        else
                            State       <=  idle;
                            Tx          <= '1';
                            Address_RW  <= (others =>'0');
                            data_output_int <= (others  => 'Z');
                        end if;
                    when mack_del   =>
                        if(Enable_Int = '1' AND (Address_RW = Address0 & RW_Int or Address_RW = Address1 & RW_Int or Address_RW = Address2 & RW_Int or Address_RW = Address3 & RW_Int)) then
                            State                           <=  read_s;
                            read_finish_int                 <=  '0';
                            RW_CTL_Int                      <=  '1';
                            Tx                              <=  '1';
                            Bit_CNT                         <=  Bit_CNT -1;
                            Data_Rx(to_integer(Bit_CNT))    <=  SDA;
                        elsif(Enable_Int = '1' AND (Address_RW /= Address0 & RW_Int or Address_RW /= Address1 & RW_Int or Address_RW /= Address2 & RW_Int or Address_RW /= Address3 & RW_Int)) then
                            State       <=  start;
                            read_finish_int <=  '0';
                            RW_CTL_Int  <=  '0';
                            Tx          <=  '0';
                            Bit_CNT     <=  (others => '1');
                            Data_Rx     <=  (others => '0');
                        else
                            State       <=  stop;
                            read_finish_int <=  '0';
                            RW_CTL_Int  <=  '0';
                            Tx          <=  '0';
                            Bit_CNT     <=  (others =>  '1');
                            Address_RW  <=  (others =>  '0');
                            Data_Rx     <=  (others =>  '0');
                        end if;
                    when    stop    =>  
                        State   <=  idle;
                        read_finish_int <=  '0';
                        data_output_int <= (others  => 'Z');
                        Bit_CNT     <=  (others =>  '1');
                        Address_RW  <=  (others =>  '0');
                        Data_Rx     <=  (others =>  '0');
                end case;
            elsif (SDA_CLK_Prv = '1' and SDA_CLK = '0') then
                case State is
                    when start  =>
                        if(SCL_Ena = '0') then
                            SCL_Ena <= '1';
                        else    
                            NULL;
                        end if;
                    when stop   => 
                        SCL_Ena     <=  '0';
                        RW_CTL_Int  <=  '0';
                        Tx          <=  '1';
                    when others =>  
                        NULL;
                 end case;
             end if;
         end if;
     end process Data_Transfering_pro;                       
end Behavioral;
