----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:46 07/23/2015 
-- Design Name: 
-- Module Name:    Controller_for_counter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller_for_counter is
    Port ( CLK : in STD_LOGIC;
			  x : in  STD_LOGIC;
           en_in : out  STD_LOGIC;
           clear : out  STD_LOGIC);
end Controller_for_counter;

architecture Behavioral of Controller_for_counter is

type state_type is (reset, run, stop);
signal PS, NS : state_type;
signal pulse, latch: STD_LOGIC;

begin

-- process changes state on clock edge
sync_p: process (CLK)
begin
	if (rising_edge(CLK)) then
		PS <= NS;
	end if;
end process sync_p;

--When x is 1, send one pulse
monopulser: process(x, latch, pulse, CLK)
begin
	-- rising edge makes sure that the "latch" is offset by one clock period
	if (rising_edge(CLK)) then
		-- if x is = 1, then button has been pressed or button is being held
		if (x = '1') then
			-- if latch is off, we pulse immiedately and turn on the latch
			-- latch and x won't be 0 at the same time, because latch has a delay after x
			if (latch = '0') then
				pulse <= '1';
				latch <= '1';
			-- if latch is on, and x is on, then we have already pulsed and we need to end the pulse
			else 
				pulse <= '0';
			end if;
		-- if x = 0, then button press is done and everything goes to 0
		else 
			latch <= '0';
			pulse <= '0';
		end if;
	end if;
end process monopulser;
	
-- process determines the next state when input or present state changes
change_state: process(pulse, PS)
begin
	case PS is 
		-- calculate when we are in the "clear" state
		when reset =>
			-- keep en_in to whatever it was before, and change clear to 1
			clear <= '1';
			-- we only change state if pulse = '1'
			if (pulse = '1') then
				NS <= run;
			else 
				NS <= reset;
			end if;
		when run =>
			-- if at run, we set en_in to 1 and clear to 0
			clear <= '0';
			en_in <= '1';
			-- only change state if pulse = 1;
			if (pulse = '1') then
				NS <= stop;
			else 
				NS <= run;
			end if;
		when stop =>
			-- if at stop, set en_in to 0, and clear to 0
			clear <= '0';
			en_in <= '0';
			--only change state if pulse = 1;
			if (pulse = '1') then
				NS <= reset;
			else 
				NS <= stop;
			end if;
	end case;
end process change_state;
				

end Behavioral;

