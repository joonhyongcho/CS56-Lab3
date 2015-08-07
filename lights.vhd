----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:05 07/19/2015 
-- Design Name: 
-- Module Name:    lights - Behavioral 
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

entity lights is
    Port ( CLK : in STD_LOGIC;
				LR : in  STD_LOGIC;
           OnOff : in  STD_LOGIC;
           Hazard : in  STD_LOGIC;
           LightL : out  STD_LOGIC;
           LightR : out  STD_LOGIC);
end lights;

architecture Behavioral of lights is

type state_type is (ST0, Left, Right, Both);
signal PS, NS : state_type;

begin

sync_p: process (CLK) 
begin
	if rising_edge(CLK) then
		PS <= NS;
	end if;
end process sync_p;

-- calculat the next state
blink_light: process (OnOff, LR, HAZARD, PS)
begin
	case PS is 
		-- if state is at both off, then we calculate to go into hazard, left, or right
		when ST0 =>
			LightR <= '0';
			LightL <= '0';
			-- if Hazard, then next state is both
			if (Hazard = '1') then
				NS <= Both;
			else 
				-- make sure OnOff is On
				if (OnOff = '1') then
					if (LR = '1') then
						NS <= Left;
					else
						NS <= Right;
					end if;
				else 
					-- if Off, then we stay on ST0;
					NS <= ST0;
				end if;
			end if;
		when Left =>
			LightR <= '0';
			LightL <= '1';
			if (Hazard = '1') then
				NS <= Both;
			else 
				NS <= ST0;
			end if;
		when Right =>
			LightR <= '1';
			LightL <= '0';
			if (Hazard = '1') then
				NS <= Both;
			else 
				NS <= ST0;
			end if;
		when Both =>
			LightR <= '1';
			LightL <= '1';
			NS <= ST0;
	end case;

end process blink_light;

				

end Behavioral;

