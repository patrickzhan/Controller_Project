----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2023 02:48:02 PM
-- Design Name: 
-- Module Name: STATE_MACHINE - STATES
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

entity STATE_MACHINE is
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
end STATE_MACHINE;

architecture STATES of STATE_MACHINE is
signal I_CURRENT_TEMP : std_ulogic_vector(6 downto 0);
signal I_DESIRED_TEMP : std_ulogic_vector(6 downto 0);
signal I_COOL : std_ulogic;
signal I_AC_ON : std_ulogic;
signal I_HEAT : std_ulogic;
signal I_FURNACE_ON : std_ulogic;
signal I_FURNACE_HOT : std_ulogic;
signal I_AC_READY : std_ulogic;
signal I_FAN_ON : std_ulogic;
signal I_COUNTDOWN: integer;

constant IDLE: std_ulogic_vector(2 downto 0):="000";
constant HEAT_ON: std_ulogic_vector(2 downto 0):="001";
constant FURNACE_NOW_HOT: std_ulogic_vector(2 downto 0):="010";
constant FURNACE_COOL: std_ulogic_vector(2 downto 0):="011";
constant COOL_ON: std_ulogic_vector(2 downto 0):="100";
constant AC_NOW_READY: std_ulogic_vector(2 downto 0):="101";
constant AC_DONE: std_ulogic_vector(2 downto 0):="110";

signal CURRENT_STATE: std_ulogic_vector(2 downto 0);
signal NEXT_STATE: std_ulogic_vector(2 downto 0);

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

--COOL
process(CLK,RESET)
begin
    if RESET = '0' then
        I_COOL<='0';
    elsif CLK'event and CLK='1' then
        I_COOL<=COOL;
    end if;
end process;

--AC_ON
process(CLK,RESET)
begin
    if RESET = '0' then
        AC_ON<='0';
    elsif CLK'event and CLK='1' then
        AC_ON<=I_AC_ON;
    end if;
end process;

--HEAT
process(CLK,RESET)
begin
    if RESET = '0' then
        I_HEAT<='0';
    elsif CLK'event and CLK='1' then
        I_HEAT<=HEAT;
    end if;
end process;

--FURNACE_ON
process(CLK,RESET)
begin
    if RESET = '0' then
        FURNACE_ON<='0';
    elsif CLK'event and CLK='1' then
        FURNACE_ON<=I_FURNACE_ON;
    end if;
end process;

--FURNACE_HOT
process(CLK,RESET)
begin
    if RESET = '0' then
        I_FURNACE_HOT<='0';
    elsif CLK'event and CLK='1' then
        I_FURNACE_HOT<=FURNACE_HOT;
    end if;
end process;

--AC_READY
process(CLK,RESET)
begin
    if RESET = '0' then
        I_AC_READY<='0';
    elsif CLK'event and CLK='1' then
        I_AC_READY<=AC_READY;
    end if;
end process;

--FAN_ON
process(CLK,RESET)
begin
    if RESET = '0' then
        FAN_ON<='0';
    elsif CLK'event and CLK='1' then
        FAN_ON<=I_FAN_ON;
    end if;
end process;

--register current state
process(CLK,RESET)
begin
    if RESET = '0' then
        CURRENT_STATE<=IDLE;
    elsif CLK'event and CLK='1' then
        CURRENT_STATE<=NEXT_STATE;
    end if;
end process;

--state machine
process(CURRENT_STATE,I_CURRENT_TEMP,I_DESIRED_TEMP,I_COOL,I_HEAT,I_FURNACE_HOT,I_AC_READY,I_COUNTDOWN)
begin
case CURRENT_STATE is
    when IDLE=>
        if I_HEAT='1' and I_CURRENT_TEMP<I_DESIRED_TEMP then
            NEXT_STATE<=HEAT_ON;
        elsif I_COOL='1' and I_CURRENT_TEMP>I_DESIRED_TEMP then
            NEXT_STATE<=COOL_ON;
        else
            NEXT_STATE<=CURRENT_STATE;
        end if;
    when HEAT_ON=>
        if I_FURNACE_HOT='1' then
            NEXT_STATE<=FURNACE_NOW_HOT;
        else
            NEXT_STATE<=CURRENT_STATE;
        end if;
    when FURNACE_NOW_HOT=>
        if not(I_HEAT='1' and I_CURRENT_TEMP<I_DESIRED_TEMP) then
            NEXT_STATE<=FURNACE_COOL;
        else
            NEXT_STATE<=CURRENT_STATE;
        end if;
    when FURNACE_COOL=>
        if I_FURNACE_HOT='0' and I_COUNTDOWN=0 then
            NEXT_STATE<=IDLE;
        else
            NEXT_STATE<=CURRENT_STATE;
        end if;
    when COOL_ON=>
        if I_AC_READY='1' then
            NEXT_STATE<=AC_NOW_READY;
        else
            NEXT_STATE<=CURRENT_STATE;
        end if;
    when AC_NOW_READY=>
        if not(I_COOL='1' and I_CURRENT_TEMP>I_DESIRED_TEMP) then
            NEXT_STATE<=AC_DONE;
        else
            NEXT_STATE<=CURRENT_STATE;
        end if;
    when AC_DONE=>
        if I_AC_READY='0' and I_COUNTDOWN=0 then
            NEXT_STATE<=IDLE;
        else
            NEXT_STATE<=CURRENT_STATE;
        end if;
     when others =>
        NEXT_STATE<=IDLE;
end case;
end process;

I_FURNACE_ON <='1' when CURRENT_STATE=HEAT_ON or CURRENT_STATE=FURNACE_NOW_HOT else
               '0';
I_AC_ON<='1' when CURRENT_STATE=COOL_ON or CURRENT_STATE=AC_NOW_READY else
         '0';
I_FAN_ON<='1' when CURRENT_STATE=FURNACE_NOW_HOT or CURRENT_STATE=FURNACE_COOL or CURRENT_STATE=AC_NOW_READY or CURRENT_STATE=AC_DONE else
          '0';
process(CURRENT_STATE,I_COUNTDOWN,CLK,RESET)
begin
if RESET = '0' then
     I_COUNTDOWN<=0;
elsif CLK'event and CLK='1' then
case CURRENT_STATE is
    when FURNACE_NOW_HOT=> I_COUNTDOWN<=10;
    when AC_NOW_READY=> I_COUNTDOWN<=20;
    when FURNACE_COOL | AC_DONE=>I_COUNTDOWN<=countdown(I_COUNTDOWN);
    when others=> I_COUNTDOWN<=0;
end case;
end if;
end process;
end STATES;
