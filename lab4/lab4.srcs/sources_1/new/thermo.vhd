
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity THERMO is
port ( CLK : in std_logic;
       -- RESET : in std_logic;
       CURRENT_TEMP : in std_logic_vector(6 downto 0);
       DESIRED_TEMP : in std_logic_vector(6 downto 0);
       DISPLAY_SELECT : in std_logic;
       COOL : in std_logic;
       HEAT : in std_logic;
       AC_READY : in std_logic;
       FURNACE_HOT : in std_logic;
       TEMP_DISPLAY : out std_logic_vector(6 downto 0);
       AC_ON : out std_logic;
       FURNACE_ON : out std_logic;
       FAN_ON : out std_logic);
end THERMO;

architecture RTL of THERMO is

type STATE_THERMO is (THERMO_IDLE,
                      THERMO_COOLON,
                      THERMO_ACREADY,
                      THERMO_ACDONE,
                      THERMO_HEATON,
                      THERMO_FURNACEREADY,
                      THERMO_FURNACECOOL);
 

signal CURRENT_TEMP_REG : std_logic_vector(6 downto 0);
signal DESIRED_TEMP_REG : std_logic_vector(6 downto 0);
signal DISPLAY_SELECT_REG : std_logic;
signal COOL_REG : std_logic;
signal HEAT_REG : std_logic;
signal AC_READY_REG : std_logic;
signal FURNACE_HOT_REG : std_logic;

signal THERMO_STATE : STATE_THERMO;
signal NEXT_STATE : STATE_THERMO;

begin

process (CLK)
begin
if CLK'event and CLK = '1' then
    CURRENT_TEMP_REG <= CURRENT_TEMP;
    DESIRED_TEMP_REG <= DESIRED_TEMP;
    DISPLAY_SELECT_REG <= DISPLAY_SELECT;
    COOL_REG <= COOL;
    HEAT_REG <= HEAT;
    AC_READY_REG <= AC_READY;
    FURNACE_HOT_REG <= FURNACE_HOT;
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
    THERMO_STATE <= NEXT_STATE;
end if;
end process;

process(CURRENT_TEMP_REG, DESIRED_TEMP_REG, COOL_REG, HEAT_REG, AC_READY_REG,
        FURNACE_HOT_REG)
begin

case THERMO_STATE is
    when THERMO_IDLE =>
        if CURRENT_TEMP_REG > DESIRED_TEMP_REG and COOL_REG = '1' then
            NEXT_STATE <= THERMO_COOLON;
        elsif CURRENT_TEMP_REG < DESIRED_TEMP_REG and HEAT_REG = '1' then
            NEXT_STATE <= THERMO_HEATON;
        else
            NEXT_STATE <= THERMO_IDLE;
        end if;
    when THERMO_COOLON =>
        if AC_READY_REG = '1' then    
            NEXT_STATE <= THERMO_ACREADY;
        else
            NEXT_STATE <= THERMO_COOLON;
        end if;
    when THERMO_ACREADY =>
        if not (CURRENT_TEMP_REG > DESIRED_TEMP_REG and COOL_REG = '1') then
            NEXT_STATE <= THERMO_ACDONE;
        else
            NEXT_STATE <= THERMO_ACREADY;
        end if;
    when THERMO_ACDONE =>
        if AC_READY_REG = '0' then
            NEXT_STATE <= THERMO_IDLE;
        else
            NEXT_STATE <= THERMO_ACDONE;
        end if;
    when THERMO_HEATON =>
        if FURNACE_HOT_REG = '1' then
            NEXT_STATE <= THERMO_FURNACEREADY;
        else
            NEXT_STATE <= THERMO_HEATON;
        end if;
    when THERMO_FURNACEREADY =>
        if not (CURRENT_TEMP_REG < DESIRED_TEMP_REG and HEAT_REG = '1') then
            NEXT_STATE <= THERMO_FURNACECOOL;
        else
            NEXT_STATE <= THERMO_FURNACEREADY;
        end if;
    when THERMO_FURNACECOOL =>
        if FURNACE_HOT_REG = '0' then
            NEXT_STATE <= THERMO_IDLE;
        else
            NEXT_STATE <= THERMO_FURNACECOOL;
        end if;
    when others =>
        NEXT_STATE <= THERMO_IDLE;
    end case;
end process;

process(CLK)
begin
    if CLK'event and CLK = '1' then
        if NEXT_STATE = THERMO_HEATON or NEXT_STATE = THERMO_FURNACEREADY then
            FURNACE_ON <= '1';
        else
            FURNACE_ON <= '0';
        end if;
        
        if NEXT_STATE = THERMO_COOLON or NEXT_STATE = THERMO_ACREADY then
            AC_ON <= '1';
        else
            AC_ON <= '0';
        end if;
        
        if NEXT_STATE = THERMO_ACREADY or NEXT_STATE = THERMO_ACDONE or 
        NEXT_STATE = THERMO_FURNACEREADY or NEXT_STATE = THERMO_FURNACECOOL then
            FAN_ON <= '1';
        else
            FAN_ON <= '0';
        end if;
    end if; 
end process;
        

end RTL;