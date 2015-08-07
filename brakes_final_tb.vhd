--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:31:43 07/23/2015
-- Design Name:   
-- Module Name:   O:/ENGS31/Lab3/brakes_final_tb.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Brakes_final
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY brakes_final_tb IS
END brakes_final_tb;
 
ARCHITECTURE behavior OF brakes_final_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Brakes_final
    PORT(
         LR : IN  std_logic;
         Hazard : IN  std_logic;
         Brake : IN  std_logic;
         OnOff : IN  std_logic;
         LightL : OUT  std_logic;
         LightR : OUT  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal LR : std_logic := '0';
   signal Hazard : std_logic := '0';
   signal Brake : std_logic := '0';
   signal OnOff : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal LightL : std_logic;
   signal LightR : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Brakes_final PORT MAP (
          LR => LR,
          Hazard => Hazard,
          Brake => Brake,
          OnOff => OnOff,
          LightL => LightL,
          LightR => LightR,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

		-- Blinks once on left side
		OnOff <= '1';
		LR <= '1';
		Brake <= '1';
		
		wait for clk_period * 4;
		-- both brakes on becauise off
		OnOff <= '0';
		brake <= '0';
		
		wait for clk_period * 4;
		
		-- Hazard is on, so both lights come on and blink *(brake = 0)
		Hazard <= '1';
		
		wait for clk_period * 6;
		
		--turn on brakes, both lgihts come on continuously
		
		brake <= '1';
		
		wait for clk_period * 4;
		
		-- Start blinking on right side
		OnOff <= '1';
		LR <= '0';
		
		wait for clk_period * 5;
		
		-- everything, off, only blinking on ride side still
		brake <= '0';
		hazard <= '0';
		
		wait for clk_period * 2;
		
		-- turn brakes on and blink off
		brake <= '1';
		OnOff <= '0';
		wait for clk_period * 2;
		
		--turn on blinkers
		OnOff <= '1';
		LR <= '1';
		
		wait for clk_period * 3;
		
		-- turn off blinkers and brakes
		OnOff <= '0';
		brake <= '0';
		
		wait for clk_period * 2.5;
		
		-- boom brake into between a set lets go!
		brake <= '1';
		
      wait;
   end process;

END;
