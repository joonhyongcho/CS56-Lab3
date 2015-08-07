--------------------------------------------------------------------------------
-- Company: 		Engs 31 15X
-- Engineer:		Joon Cho 
--
-- Create Date:   16:45:22 07/05/2013
-- Design Name:   
-- Module Name:   C:/DigitalDesigns/Engs31/Engs31_15X/lab3/lab3_tb.vhd
-- Project Name:  lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: taillights
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revised 3 July 2014 (EWH), for the Nexys3 board
-- Revised 10 July 2015 (EWH), to work with Nexys2 or Nexys3
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
 
ENTITY lab3_tb IS
END lab3_tb;
 
ARCHITECTURE behavior OF lab3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT taillights
    PORT(
         mclk   : IN  std_logic;
         OnOff  : IN  std_logic;
         LR     : IN  std_logic;
         Hazard : IN  std_logic;
         LightL : OUT  std_logic;
         LightR : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal mclk   : std_logic := '0';
   signal OnOff  : std_logic := '0';
   signal LR     : std_logic := '0';
   signal Hazard : std_logic := '0';

 	--Outputs
   signal LightL : std_logic;
   signal LightR : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1 us;       -- 1 MHz (simulate slow clock)
   constant CLK_PER_2  : time := 20 ns;      -- 50 MHz  (Nexys2)
   constant CLK_PER_3  : time := 10 ns;      -- 100 MHz (Nexys3)
   constant mclk_period: time := CLK_PER_2;	-- Use CLK_PER_2 or CLK_PER_3   
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: taillights	PORT MAP (
          mclk => mclk,				
          OnOff => OnOff,
          LR => LR,
          Hazard => Hazard,
          LightL => LightL,
          LightR => LightR
        );

   -- Clock process definitions
   mclk_process :process
   begin
		mclk <= '0';
		wait for mclk_period/2;
		mclk <= '1';
		wait for mclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      wait for clk_period;
      
      -- insert stimulus here 
      OnOff <= '1';                   -- Turn lights on
	   LR <= '1';                      -- Select left turn signal
		Hazard <= '0';
	   wait for 4 * clk_period;       -- Leave it on a while
		-- OnOff 1 and right blinker should go off
	   OnOff <= '1';
		LR <= '0';
		wait for 4 * clk_period;
		
		-- OnOff = '0' and LR = '0';
		OnOff <= '0';
		wait for 4 * clk_period;
	
		-- OnOff = '0' and LR = '1';
		OnOff <= '0';
		LR <= '1';
		wait for 4 * clk_period;
		
		-- OnOff = '0' and LR = '1' and Hazard = '1';
		OnOff <= '0';
		LR <= '1';
		Hazard <= '1';
		wait for 4 * clk_period;
		
		-- OnOff = '1' and LR = '1' and Hazard = '1';
		OnOff <= '1';
		LR <= '1';
		Hazard <= '1';
		wait for 4 * clk_period;
		
		-- OnOff = '1' and LR = '0' and Hazard = '1';
		OnOff <= '1';
		LR <= '0';
		Hazard <= '1';
		wait for 4 * clk_period;
		
		-- OnOff = '0' and LR = '0' and Hazard = '1'
		OnOff <= '0';
		LR <= '0';
		Hazard <= '1';

      wait;
   end process;

END;
