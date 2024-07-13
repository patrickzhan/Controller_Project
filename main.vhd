----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2023 02:21:20 PM
-- Design Name: 
-- Module Name: main - RTL
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
use work.my_package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
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
end main;

architecture RTL of main is
component TEMPDISPLAY is
    Port ( CURRENT_TEMP : in std_ulogic_vector(6 downto 0);
           DESIRED_TEMP : in std_ulogic_vector(6 downto 0);
           DISPLAY_SELECT : in std_ulogic;
           TEMP_DISPLAY : out std_ulogic_vector(6 downto 0);
           CLK : in std_ulogic;
           RESET : in std_ulogic);
end component;
component STATE_MACHINE is
    Port ( CURRENT_TEMP : in std_ulogic_vector(6 downto 0);
           DESIRED_TEMP : in std_ulogic_vector(6 downto 0);
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
begin
U1: TEMPDISPLAY port map(CURRENT_TEMP=>CURRENT_TEMP,DESIRED_TEMP=>DESIRED_TEMP,DISPLAY_SELECT=>DISPLAY_SELECT,TEMP_DISPLAY=>TEMP_DISPLAY,CLK=>CLK,RESET=>RESET);
U2: STATE_MACHINE port map(CURRENT_TEMP=>CURRENT_TEMP,DESIRED_TEMP=>DESIRED_TEMP,COOL=>COOL,AC_ON=>AC_ON,HEAT=>HEAT,FURNACE_ON=>FURNACE_ON,FURNACE_HOT=>FURNACE_HOT,AC_READY=>AC_READY,FAN_ON=>FAN_ON,CLK=>CLK,RESET=>RESET);
end RTL;
