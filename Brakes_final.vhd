----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:39:47 07/07/2014 
-- Design Name: 
-- Module Name:    TurnSignals - Blink 
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

entity Brakes_final is
    Port (
            LR : in  STD_LOGIC;
            Hazard : in  STD_LOGIC;
				Brake: in STD_LOGIC;
				OnOff: in STD_LOGIC;
            LightL: out STD_logic;
				LightR: out STD_logic;
            clk : in  STD_LOGIC);
end Brakes_final;

architecture Behavioural of Brakes_final is
	type state_type is (ST0, Left, Right, Both);
	signal PS, NS : state_type;
	signal ilights : std_logic_vector(5 downto 0);
	
begin

	process(brake, clk, PS)
	begin
	
		-- Brake supercedes everything 
		if (Brake = '1') then
			-- if hazard then both
			if (Hazard = '1') then
				LightL <= '1';
				LightR <= '1';
			else 
				-- must accomodate for blinking
				-- if on, then only turn on one light (because blinker will take care of other side
				if (OnOff = '1') then
				-- turn opposite on
					if (LR = '1') then
						LightR <= '1';
					else 
						LightL <= '1';
					end if;
				-- turn opposite off
				else
					-- turn both lights on if they are off
					LightR <= '1';
					LightL <= '1';
				end if;
			end if;
		end if;
		
			-- take care of moving between states here
		if (rising_edge(clk)) then
			case PS is
				when ST0 =>
					-- if brakes are not on, then ST0 is actually going to turn lights off
					if (Brake = '0') then
						LightL <= '0';
						LightR <= '0';
					end if;
					
					-- if hazard is on, set next state to both
					if (Hazard = '1') then
						NS <= Both;
					else
						-- assuming that brakes are on, set one side to off if blinker is going to be on
						if (OnOff = '1') then
							-- choose the side
							if (LR = '1') then
								LightL <= '0';
								NS <= Left;
							else
								LightR <= '0';
								NS <= Right;
							end if;
						else
						-- deault if nothing else
							NS <= ST0;
						end if;
					end if;
				when Left =>
					-- only one side, all are set to ST0 as next state
					LightL <= '1';
					NS <= ST0;
				when Right =>
					LightR <= '1';
					NS <= ST0;
				when Both =>
					LightL <= '1';
					LightR <= '1';
					NS <= ST0;
			end case;
			
			-- boom change the state!
			PS <= NS;
		end if;
		

	end process;
end Behavioural;

