library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller is
    Port (M4            :in     std_logic;
          M5            :in     std_logic;
          M6            :in     std_logic;
          ACP           :in     std_logic; -- Atonomus Configure Pin
          address_in    :in     std_logic_vector(14 downto 0);
          RW_in         :in     std_logic;
          data_in       :in     std_logic_vector(7 downto 0);
          clk_sys_in    :in     std_logic;
          write_finish  :in     std_logic;
          read_finish   :in     std_logic;
          start_pin     :in     std_logic;
          reset         :in     std_logic;
          spi_mode      :in     std_logic;
          ram_finish    :in     std_logic;
          data_from_i2c  :in std_logic_vector(7 downto 0);
          data_from_spi  :in std_logic_vector(7 downto 0);
          data_from_sdio :in std_logic_vector(7 downto 0);
          ---
          ram_enable    :out    std_logic;
          ram_nextdata  :out    std_logic;
          configdone    :out    std_logic;
          data_output   :out    std_logic_vector(7 downto 0);
          address_i2c   :out    std_logic_vector(1 downto 0);
          RW_out        :out    std_logic;
          SPI_3wire     :out    std_logic;
          SPI_4wire     :out    std_logic;
          I2C_sel       :out    std_logic;
          CLK_sys_out   :out    std_logic;
          data_to_module:out    std_logic_vector(22 downto 0)
          );
end controller;

architecture Behavioral of controller is
--- input internal signals
signal  M4_int          :std_logic;
signal  M5_int          :std_logic;
signal  M6_int          :std_logic;
signal  acp_int         :std_logic;
signal  Address_in_int  :std_logic_vector(14 downto 0)  := (others => '0');
signal  RW_in_int       :std_logic;
signal  data_in_int     :std_logic_vector(7 downto 0)   := (others => '0');
signal  read_finish_int :std_logic;
signal  write_finish_int:std_logic;
signal  reset_int       :std_logic;
signal  spi_mode_int    :std_logic;
signal  ram_finish_int  :std_logic;
signal  data_from_i2c_int    :std_logic_vector(7 downto 0)   := (others  => '0');
signal  data_from_spi_int    :std_logic_vector(7 downto 0)   := (others  => '0');
signal  data_from_sdio_int    :std_logic_vector(7 downto 0)   := (others  => '0');
--- output internal signals
signal  ram_enable_int  :std_logic  := '0';
signal  ram_nextdata_int:std_logic  := '0';
signal  configdone_int  :std_logic  := '0';
signal  dataout_int     :std_logic_vector(7 downto 0)  := (others => '0');
signal  RW_int          :std_logic;
signal  Address_i2c_int :std_logic_vector(1 downto 0);
signal  spi_3wire_int   :std_logic;
signal  spi_4wire_int   :std_logic;
signal  i2c_int         :std_logic;
signal  start_int       :std_logic;
signal  data_to_module_int  :std_logic_vector(22 downto 0)  :=(others => '0');
--- state machine declaration
type    FSM     is (idle,start,I2C,I2c_Write,I2C_read,I2C_recive,SPI,SPI_write,spi_read,spi_recive,ram_next);
signal  State   :FSM    := idle;
--- i2c counter
signal  I2c_counter   :unsigned(1 downto 0)   :=(others => '1');  
---spi flag
signal  address_sent:std_logic  :='0';
signal  spi_flag    :std_logic  := '0';
signal  i2c_flag_write    :std_logic  := '0';
signal  i2c_flag_read   :std_logic  := '0';
begin
    clk_sys_out     <= clk_sys_in;
    data_output     <= dataout_int;
    reset_int       <= reset;
    RW_out          <= RW_int;
    M4_int          <= M4;
    M5_int          <= M5;
    M6_int          <= M6;
    ACP_int         <= ACP;
    Address_in_int  <= Address_in;
    data_in_int     <= data_in;
    read_finish_int <= read_finish;
    write_finish_int<= write_finish;
    RW_in_int       <= RW_in;
    Address_i2c     <= Address_i2c_int;
    spi_3wire       <= spi_3wire_int;
    spi_4wire       <= spi_4wire_int;
    I2C_sel         <= I2C_int;
    start_int       <= start_pin;
    spi_mode_int    <= spi_mode;
    ram_finish_int  <= ram_finish;
    data_to_module  <= data_to_module_int;
    data_from_i2c_int    <=  data_from_i2c;
    data_from_spi_int    <=  data_from_spi;
    data_from_sdio_int    <=  data_from_sdio;
    configdone      <= configdone_int;
    ram_nextdata    <= ram_nextdata_int;
    ram_enable      <= ram_enable_int;
    process(clk_sys_in)
    begin
    if(rising_edge(clk_sys_in)) then
        case    State   is
            -------------
            when    idle    =>
                if (reset_int = '1' ) then
                    if(start_int='1') then
                        State <= start;
                    else
                        State   <=  idle;
                    end if;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= dataout_int;
                    data_to_module_int  <= (others => 'Z');
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2c_counter     <= "10";
                    I2C_int         <= '0';
                    i2c_flag_write    <= write_finish_int;
                    i2C_flag_read <= read_finish_int;
                    SPI_flag        <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => 'Z');
                end if;
           ------------- 
            when    start   =>
                if(reset_int = '1') then
                    if(M4_int = '0') then
                        State   <= SPI ;
                    else
                        State   <=  I2C;
                        i2c_flag_write    <= write_finish_int; 
                        i2C_flag_read <= read_finish_int;
                    end if; 
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => 'Z');
                end if;
            -------------
            when    i2C =>
                if(reset_int = '1') then
                    if(ACP_int = '1' and configdone_int = '0')then
                        ---atomatic configuration
                        spi_3wire_int   <= '0';
                        spi_4wire_int   <= '0';
                        data_to_module_int  <=  (others => 'Z');
                        RW_int  <= '0';
                        i2c_counter <= "10";
                        ram_Enable_int  <= '1';
                        State   <= i2C_write;
                    else
                        ---normal comunication 
                        --- preparing I2C module input
                        data_to_module_int  <=  address_in_int & data_in_int;
                        Address_I2C_int <=  M6_int & M5_int;
                        if(RW_in_int = '0') then
                            ---I2C wirte seueqnce
                            State   <= I2C_Write;
                            RW_int  <= '0';
                            i2c_flag_write    <= write_finish_int;
                            i2c_counter <= "10";
                        else
                            ---I2C read sequence
                            if(address_sent = '0')then
                                State   <=  I2C_write;
                                RW_int  <=  '0';
                                i2C_flag_read <= read_finish_int;
                                i2c_counter <=  "01";
                                address_sent    <= '1';
                            else
                                State <= I2C_Read;
                                RW_int  <=  '1';
                                I2C_flag_read   <= read_finish_int;
                            end if;
                        end if;
                    end if;
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    i2c_flag_write    <= write_finish_int;
                    i2C_flag_read <= read_finish_int;
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => 'Z');
                end if;
           -------------
            when    I2C_write   =>
                if(reset_int = '1') then
                    RW_int  <= '0';
                    if(ACP_int  = '1')then
                        I2c_int <= '1';
                        if(write_finish_int = '1' and i2c_counter /= 0) then
                            State <= I2C_write;
                            i2c_counter <= i2c_counter - 1;
                        elsif(write_finish_int = '1' and i2c_counter = 0) then
                            State <= ram_next;
                            ram_nextdata_int    <= '1';
                        else
                            State   <=  I2C_write;
                        end if;
                    else
                        i2C_int     <= '1';
                        if(write_finish_int = '1' and i2c_flag_write = '0' and i2c_counter /= 0) then
                            State   <=  I2C_write;
                            i2c_counter <= i2c_counter - 1;
                            i2c_flag_write    <= write_finish_int;
                        elsif(write_finish_int = '1'and i2c_flag_write = '0' and i2c_counter = 0) then
                            I2C_int <= '0';
                            State   <= idle;
                            if(RW_in_int = '0')then
                                State   <=  idle;
                            else
                                State   <= Start;
                            end if;
                        else
                            State   <=  I2C_write;
                            i2c_flag_write    <= write_finish_int;
                        end if;
                    end if;
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => '0');
                end if;
            -------------
            when    I2C_read    =>
                if(reset_int = '1') then
                    i2C_int     <= '1';
                    if(read_finish_int = '1' and I2C_flag_read = '0' and i2c_counter /= 0) then
                        State   <=  I2C_read;
                        i2c_counter <= i2c_counter - 1;
                        i2C_flag_read <= read_finish_int;
                    elsif(read_finish_int = '1' and I2C_flag_read = '0' and i2c_counter = 0) then
                        State   <=  I2C_recive;
                        address_sent    <= '0';
                        RW_int  <=  '1';
                    else
                        State   <=  I2C_read;
                        i2C_flag_read <= read_finish_int;
                    end if;
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => '0');
                end if;
            -------------
            when    I2C_recive  =>
                if(reset_int = '1') then
                    if(read_finish_int  =   '1') then
                        address_sent <= '0';
                        dataout_int <=  data_from_i2c_int;
                        State       <=  Idle;
                    else
                        State   <=  I2c_recive;
                    end if;
                else
                   State   <=  idle;
                   spi_3wire_int   <= '0';
                   spi_4wire_int   <= '0';
                   I2C_int         <= '0';
                   dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => '0');
                end if;
            -------------
            when    SPI =>
                if(reset_int = '1') then
                    if(ACP_int  = '1' and configdone_int = '0') then
                        data_to_module_int  <=  (others => 'Z');
                        RW_int  <= '0';
                        ram_Enable_int  <= '1';
                        State   <= SPI_write;
                        
                    else
                        ---preparing spi module input
                        ---data_to_module_int  <=  address_in_int & data_in_int;
                        if(spi_mode_int = '0') then 
                            ---3 wire spi selected
                            --- prepairing input for 3 wire module
                            data_to_module_int  <=  address_in_int & data_in_int;
                            RW_int  <= RW_in_int;
                            spi_3wire_int <= '1';
                            spi_4wire_int <= '0';
                            if(RW_in_int = '0') then
                                ---SPI write sequence
                                State   <=  SPI_write;
                            else
                                ---SPI read sequence
                                State   <=  SPI_read;
                            end if;  
                        elsif(spi_mode_int = '1' and spi_flag = '0') then  
                            ---4 wire spi selected
                            ---need to be configured for the first time
                            ---need to send the value below to configure  
                            data_to_module_int  <= "00000000000000000000001";
                            State   <=  Spi_write; 
                        else
                            ---4 wire spi selected and has been configured
                            --- prepairing input for 4 wire module
                            spi_3wire_int <= '0';
                            spi_4wire_int <= '1';
                            data_to_module_int  <=  address_in_int & data_in_int;
                            RW_int  <= RW_in_int;
                            if(RW_in_int = '0') then
                                ---SPI write sequence
                                State   <=  SPI_write;
                            else
                                ---SPI read sequence
                                State   <=  SPI_read;
                            end if;
                        end if;
                    end if;
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => '0');
                end if;
            -------------    
            when    SPI_write   =>
                if(reset_int = '1') then
                    if(spi_mode_int = '0' or (spi_mode_int = '1' and spi_flag = '0'))then
                        ---SPI 3wire
                        RW_int  <= '0'; 
                        spi_3wire_int   <= '1';
                        spi_4wire_int   <= '0';
                        if(write_finish = '1' ) then
                            if(ACP_int  = '1' and configdone_int = '0')then
                                State   <= ram_next;
                                ram_nextdata_int    <= '1';
                            else
                                if(spi_mode_int = '1' and spi_flag = '0') then
                                    spi_flag    <= '1';
                                    State   <= SPI;
                                else
                                    State   <= idle;
                                end if;
                            end if;
                        else
                            State   <= SPI_write;
                        end if;
                    else
                        ---SPI 4wire
                        RW_int  <= '0';
                        spi_3wire_int <= '0';
                        spi_4wire_int   <= '1';
                        if(write_finish = '1') then
                            State <= idle;
                        else
                            State <= SPI_write;
                        end if;
                      
                    end if;
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => '0');
                end if;
            
            -------------     
            when    SPI_read    =>
                if(reset_int = '1') then
                    RW_int  <= '1';
                    if(spi_mode_int = '0')then
                        ---spi 3wire
                        spi_3wire_int   <= '1';
                        spi_4wire_int   <= '0';
                        if(read_finish = '1') then
                            State <= spi_recive;
                        else
                            State <= SPI_read;
                        end if;
                    else
                        --spi 4wire
                        spi_3wire_int   <= '0';
                        spi_4wire_int   <= '1';
                        if(read_finish = '1') then
                            State <= spi_recive;
                        else
                            State <= SPI_read;
                        end if;
                    end if;
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => '0');
                end if;
            when    SPi_recive  =>
                if(reset_int = '1') then
                    if(spi_mode_int = '0')then
                        dataout_int    <= data_from_SDIO_int;
                    else
                        dataout_int    <= data_from_SPI_int;
                    end if;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    State   <= idle;
                else
                    State   <=  idle;
                    spi_3wire_int   <= '0';
                    spi_4wire_int   <= '0';
                    I2C_int         <= '0';
                    dataout_int        <= (others => '0');
                    data_to_module_int  <= (others  => '0');
                end if;
            when    ram_next    =>
                ram_nextdata_int    <= '0';
                if(ram_finish_int   = '1') then
                    State   <= idle;
                    configdone_int  <= '1';
                else   
                    if(M4_int = '0')then
                        --- spi 
                        State   <= SPI_write;
                        i2c_int <= '0';
                        data_to_module_int  <=  (others => 'Z');
                        RW_int  <= '0';
                        ram_Enable_int  <= '1';
                    else
                        --- i2c
                        spi_3wire_int   <= '0';
                        spi_4wire_int   <= '0';
                        data_to_module_int  <=  (others => 'Z');
                        RW_int  <= '0';
                        i2c_counter <= "10";
                        ram_Enable_int  <= '1';
                        State <= I2C_write;
                    end if;
                end if;       
        end case;
     end if;
    end process;
end Behavioral;