----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2023 02:48:02 PM
-- Design Name: 
-- Module Name: T_TEMPMUX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity T_main is
--  Port ( );
end T_main;

architecture TEST of T_main is
component main is
    Port ( CURRENT_TEMP : in std_ulogic_vector(6 downto 0);
           DESIRED_TEMP : in std_ulogic_vector(6 downto 0);
           DISPLAY_SELECT : in std_ulogic;
           TEMP_DISPLAY : out std_ulogic_vector(6 downto 0);
           COOL : in std_ulogic;
           AC_ON : out std_ulogic;
           HEAT : in std_ulogic;
           FURNACE_ON : out std_ulogic;
           FURNACE_HOT : in std_ulogic;
           AC_READY : in std_ulogic;
           FAN_ON : out std_ulogic;
           CLK : in std_ulogic;
           RESET : in std_ulogic);
end component;
signal CURRENT_TEMP,DESIRED_TEMP: std_ulogic_vector(6 downto 0);
signal DISPLAY_SELECT,COOL,HEAT : std_ulogic;
signal TEMP_DISPLAY : std_ulogic_vector(6 downto 0);
signal AC_ON,FURNACE_ON : std_ulogic;
signal FURNACE_HOT,AC_READY,FAN_ON: std_ulogic;
signal CLK, RESET : std_ulogic;
begin
UUT: main port map(
    CURRENT_TEMP=>CURRENT_TEMP,
    DESIRED_TEMP=>DESIRED_TEMP,
    DISPLAY_SELECT=>DISPLAY_SELECT,
    TEMP_DISPLAY=>TEMP_DISPLAY,
    COOL=>COOL,
    AC_ON=>AC_ON,
    HEAT=>HEAT,
    FURNACE_ON=>FURNACE_ON,
    FURNACE_HOT=>FURNACE_HOT,
    AC_READY=>AC_READY,
    FAN_ON=>FAN_ON,
    CLK=>CLK,
    RESET=>RESET);
--CLK
process
begin
    while now<200 ns loop
        CLK<='0';
        wait for 1 ns;
        CLK<='1';
        wait for 1 ns;
    end loop;
    wait;
end process;

--RESET
RESET<='1', '0' after 150 ns;

process
--procedure SETTEMPS(CURRENT,DESIRED : in integer)is
--begin
--    CURRENT_TEMP<=conv_std_logic_vector(CURRENT,7);
--    DESIRED_TEMP<=conv_std_logic_vector(DESIRED,7);
--end procedure SETTEMPS;
begin
    assert false report "Starting Temperature control sim" severity note;
    --display
    CURRENT_TEMP<="1000000";
    DESIRED_TEMP<="1100000";
    COOL<='0';
    HEAT<='0';
    FURNACE_HOT<='0';
    AC_READY<='0';
    DISPLAY_SELECT<='0';
    wait for 10 ns;
    DISPLAY_SELECT<='1';
    wait for 10 ns;
    --furnace switch
    HEAT<='1';
    wait for 10 ns;
    --furnace is hot
    FURNACE_HOT<='1';
    wait for 10 ns;
    --current temp increase
    CURRENT_TEMP<="1111111";
    wait for 10 ns;
    --furnace is not hot
    FURNACE_HOT<='0';
    wait for 20 ns;
    --AC switch
    COOL<='1';
    wait for 10 ns;
    --AC is ready
    AC_READY<='1';
    wait for 10 ns;
    --Temperature drop
    CURRENT_TEMP<="1100000";
    wait for 10 ns;
    --AC is not ready
    AC_READY<='0';
    wait for 10 ns;
    wait;
end process;
end TEST;
