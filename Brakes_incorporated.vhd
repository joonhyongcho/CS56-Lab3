----------------------------------------------------------------------------------
-- Company: 			Engs 31 15X
-- Engineer: 			Joon cho
-- 
-- Create Date:    	 
-- Design Name: 		
-- Module Name:    		lab3_shell 
-- Project Name: 		Lab3
-- Target Devices: 		Digilent NEXYS2 (Spartan 3E) or NEXYS3 (Spartan 6)
-- Tool versions: 		ISE Design Suite 14.7
-- Description: 		Taillight lab
--				
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Revised (EWH), 3 July 2014, for the Nexys3 board
-- Revised (EWH), 10 July 2015, to work with either Nexys2 or Nexys3
-- Additional Comments: 
--
----------------------------------------------------------------------------------
-- Boilerplate: don't change this
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;		-- needed for arithmetic

library UNISIM;					-- needed for the BUFG component
use UNISIM.Vcomponents.ALL;


-- Entity block
-- Change the name of the entity from Lab3_shell to something more descriptive,
-- like Lab3_taillights.

entity taillights is
port ( mclk, OnOff, LR, Hazard, Brake	    : in std_logic;
       LightL, LightR				: out std_logic );
end taillights; 

architecture Behavioral of taillights is
-- Signals for the clock divider, which divides the master clock down to 4 Hz
-- Master clock frequency / CLOCK_DIVIDER_VALUE = 8 Hz
constant CDV2: integer :=  6250000;                 -- Nexys2 board has 50 MHz clock
constant CDV3: integer := 12500000;                 -- Nexys3 board has 100 MHz clock
constant CLOCK_DIVIDER_VALUE: integer := 10;      -- use CDV2 or CDV3
signal clkdiv: integer := 0;		-- the clock divider counter
signal clk_en: std_logic := '0';	-- terminal count
signal clk: std_logic;			    -- the slow clock

-- Signal declarations for your state machine go here
type state_type is (ST0, Left, Right, Both);
signal PS, NS : state_type;
signal left_light, right_light: std_logic;

begin
-- Clock buffer for 4 Hz clock
-- The BUFG component puts the slow clock onto the FPGA clocking network
Slow_clock_buffer: BUFG
      port map (I => clk_en,
                O => clk );

-- Divide the master clock down to 8 Hz, then
-- toggling the clk_en signal at 8 Hz gives a 4 Hz clock with 50% duty cycle
Clock_divider: process(mclk)
begin
	if rising_edge(mclk) then
	   	if clkdiv = CLOCK_DIVIDER_VALUE-1 then 
	   		clk_en <= NOT(clk_en);		
			clkdiv <= 0;
		else
			clkdiv <= clkdiv + 1;
		end if;
	end if;
end process Clock_divider;



-- calculat the next state
blink_light: process (OnOff, LR, HAZARD, Brake, PS, CLK)
begin
	case PS is 
		-- if state is at both off, then we calculate to go into hazard, left, or right
		when ST0 =>
			LightR <= '0';
			LightL <= '0';
			-- check if brake is on
			if (Brake = '1') then
				if (Hazard = '1') then
					-- lights are both on IMMEDIATELY
					LightR <= '1';
					LightL <= '1';
				else 
					if (Onoff = '1') then
						if (LR = '1') then
							PS <= Left;
						else 
							PS <= Right;
						end if;
					else 
						-- turn both on
						LightR <= '1';
						LightL <= '1';
					end if;
				end if;
			else 
				-- do output here
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
		end if;
			
		when Left =>
			LightR <= '0';
			LightL <= '1';
			
			if (brake = '1') then
				LightR <= '1';
			else 
				if (Hazard = '1') then
					NS <= Both;
				else 
					NS <= ST0;
				end if;
			end if;
		when Right =>
			LightR <= '1';
			LightL <= '0';
			if (brake = '1') then
				LightL <= '1';
			else 
			
				if (Hazard = '1') then
					NS <= Both;
				else 
					NS <= ST0;
				end if;
			end if;
		when Both =>
			LightR <= '1';
			LightL <= '1';
			NS <= ST0;
	end case;
	
	if (rising_edge(CLK)) then
		PS <= NS;
	end if;

end process blink_light;

				

end Behavioral;

