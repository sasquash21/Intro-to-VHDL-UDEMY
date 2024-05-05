entity THERMO is

port ( CURRENT_TEMP : in bit_vector(6 downto 0);
       DESIRED_TEMP : in bit_vector(6 downto 0);
       DISPLAY_SELECT : in bit;
       COOL : in bit;
       HEAT : in bit;
       TEMP_DISPLAY : out bit_vector(6 downto 0);
       A_C_ON : out bit;
       FURNACE_ON : out bit;
       CLK : in bit);
end THERMO;

architecture RTL of THERMO is

signal CURRENT_TEMP_REG : bit_vector(6 downto 0);
signal DESIRED_TEMP_REG : bit_vector(6 downto 0);
signal DISPLAY_SELECT_REG : bit;
signal COOL_REG : bit;
signal HEAT_REG : bit;

begin

process (CLK)
begin
if CLK'event and CLK = '1' then
    CURRENT_TEMP_REG <= CURRENT_TEMP;
    DESIRED_TEMP_REG <= DESIRED_TEMP;
    DISPLAY_SELECT_REG <= DISPLAY_SELECT;
    COOL_REG <= COOL;
    HEAT_REG <= HEAT;
end if;
end process;
    

process (CLK)
begin
if CLK'event and CLK = '1' then
    if DISPLAY_SELECT = '1' then
        TEMP_DISPLAY <= CURRENT_TEMP_REG;
    else
        TEMP_DISPLAY <= DESIRED_TEMP_REG;
    end if;
end if;

end process;

process (CLK)
begin

if CLK'event and CLK = '1' then
    if CURRENT_TEMP_REG > DESIRED_TEMP_REG and COOL_REG = '1' then
        A_C_ON <= '1';
        FURNACE_ON <= '0';
    elsif CURRENT_TEMP_REG < DESIRED_TEMP_REG and HEAT_REG = '1' then
        A_C_ON <= '0';
        FURNACE_ON <= '1';
    else
        A_C_ON <= '0';
        FURNACE_ON <= '0';
    end if;
end if;

end process;

end RTL;
