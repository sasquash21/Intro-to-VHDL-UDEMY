entity THERMO is

    port ( CURRENT_TEMP : in bit_vector(6 downto 0);
           DESIRED_TEMP : in bit_vector(6 downto 0);
           DISPLAY_SELECT : in bit;
           COOL : in bit;
           HEAT : in bit;
           TEMP_DISPLAY : out bit_vector(6 downto 0);
           A_C_ON : out bit;
           FURNACE_ON : out bit);
end THERMO;

architecture RTL of THERMO is
begin

process (CURRENT_TEMP, DESIRED_TEMP, DISPLAY_SELECT)
begin

    if DISPLAY_SELECT = '1' then
        TEMP_DISPLAY <= CURRENT_TEMP;
    else
        TEMP_DISPLAY <= DESIRED_TEMP;
    end if;

end process;

process (CURRENT_TEMP, DESIRED_TEMP, COOL, HEAT)
begin

    if CURRENT_TEMP > DESIRED_TEMP and COOL = '1' then
        A_C_ON <= '1';
        FURNACE_ON <= '0';
    elsif CURRENT_TEMP < DESIRED_TEMP and HEAT = '1' then
        A_C_ON <= '0';
        FURNACE_ON <= '1';
    else
        A_C_ON <= '0';
        FURNACE_ON <= '0';
    end if;
end process;
 
end RTL;