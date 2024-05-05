library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_THERMO is
end T_THERMO;

architecture TEST of T_THERMO is
component THERMO
    port(  
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
           FAN_ON : out std_logic;
           CLK : in std_logic);
end component;

signal CURRENT_TEMP :std_logic_vector(6 downto 0);
signal DESIRED_TEMP :std_logic_vector(6 downto 0);
signal TEMP_DISPLAY :std_logic_vector(6 downto 0);
signal DISPLAY_SELECT, COOL, HEAT, AC_READY, FURNACE_HOT, AC_ON, FURNACE_ON, FAN_ON :std_logic;
signal CLK :std_logic := '0';

begin

CLK <= not CLK after 5 ns;

UUT : THERMO port map ( CLK => CLK,
                        CURRENT_TEMP => CURRENT_TEMP,
                        DESIRED_TEMP => DESIRED_TEMP,
                        DISPLAY_SELECT => DISPLAY_SELECT,
                        TEMP_DISPLAY => TEMP_DISPLAY,
                        AC_READY => AC_READY,
                        FURNACE_HOT => FURNACE_HOT,
                        COOL => COOL,
                        HEAT => HEAT,
                        AC_ON => AC_ON,
                        FURNACE_ON => FURNACE_ON,
                        FAN_ON => FAN_ON);
                        
process
begin
CURRENT_TEMP <= "0000000";
DESIRED_TEMP <= "1111111";
DISPLAY_SELECT <= '0';
HEAT <= '0';
COOL <= '0';
FURNACE_HOT <= '0';
AC_READY <= '0';
wait for 50 ns;
DISPLAY_SELECT <= '1';
wait for 50 ns;
HEAT <= '1';
wait until FURNACE_ON = '1';
FURNACE_HOT <= '1';
wait until FAN_ON = '1';
HEAT <= '0';
wait until FURNACE_ON = '0';
FURNACE_HOT <= '0';
wait for 50 ns;
CURRENT_TEMP <= "1000000";
DESIRED_TEMP <= "0111111";
wait for 50 ns;
COOL <= '1';
wait until AC_ON = '1';
AC_READY <= '1';
wait until FAN_ON = '1';
COOL <= '0';
wait until AC_ON = '0';
AC_READY <= '0';
wait for 50 ns;
wait;
end process;
end TEST;