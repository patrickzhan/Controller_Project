----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2023 02:43:41 PM
-- Design Name: 
-- Module Name: TEMP_DISPLAY - RTL
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEMPDISPLAY is
    Port ( CURRENT_TEMP : in std_ulogic_vector(6 downto 0);
           DESIRED_TEMP : in std_ulogic_vector(6 downto 0);
           DISPLAY_SELECT : in std_ulogic;
           TEMP_DISPLAY : out std_ulogic_vector(6 downto 0);
           CLK : in std_ulogic;
           RESET : in std_ulogic);
end TEMPDISPLAY;

architecture BEHAVE of TEMPDISPLAY is
signal I_CURRENT_TEMP : std_ulogic_vector(6 downto 0);
signal I_DESIRED_TEMP : std_ulogic_vector(6 downto 0);
signal I_DISPLAY_SELECT : std_ulogic;
signal I_TEMP_DISPLAY : std_ulogic_vector(6 downto 0);

begin
--CURRENT_TEMP
process(CLK,RESET)
begin
    if RESET = '0' then
        I_CURRENT_TEMP<=(others=>'0');
    elsif CLK'event and CLK='1' then
        I_CURRENT_TEMP<=CURRENT_TEMP;
    end if;
end process;

--DESIRED_TEMP
process(CLK,RESET)
begin
    if RESET = '0' then
        I_DESIRED_TEMP<=(others=>'0');
    elsif CLK'event and CLK='1' then
        I_DESIRED_TEMP<=DESIRED_TEMP;
    end if;
end process;

--DISPLAY_SELECT
process(CLK,RESET)
begin
    if RESET = '0' then
        I_DISPLAY_SELECT<='0';
    elsif CLK'event and CLK='1' then
        I_DISPLAY_SELECT<=DISPLAY_SELECT;
    end if;
end process;

--TEMP_DISPLAY
process(CLK,RESET)
begin
    if RESET = '0' then
        TEMP_DISPLAY<=(others=>'0');
    elsif CLK'event and CLK='1' then
        TEMP_DISPLAY<=I_TEMP_DISPLAY;
    end if;
end process;

process(I_CURRENT_TEMP,I_DESIRED_TEMP,I_DISPLAY_SELECT)
begin
    if I_DISPLAY_SELECT='1' then
        I_TEMP_DISPLAY<=I_CURRENT_TEMP;
    else
        I_TEMP_DISPLAY<=I_DESIRED_TEMP;
    end if;
end process;

end BEHAVE;
