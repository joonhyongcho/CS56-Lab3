--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:47:50 07/23/2015
-- Design Name:   
-- Module Name:   O:/ENGS31/Lab3/Controller_tb.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Controller_for_counter
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
 
ENTITY Controller_tb IS
END Controller_tb;
 
ARCHITECTURE behavior OF Controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Controller_for_counter
    PORT(
         CLK : IN  std_logic;
         x : IN  std_logic;
         en_in : OUT  std_logic;
         clear : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal x : std_logic := '0';
	
 	--Outputs
   signal en_in : std_logic;
   signal clear : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Controller_for_counter PORT MAP (
          CLK => CLK,
          x => x,
          en_in => en_in,
          clear => clear
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 20 ns;	

      -- press the button 3 times
		x <= '0';
		wait for 2 * clk_period;
		x <= '1'; 
		wait for 1 * clk_period;
		
		x <= '0';
		wait for 2 * clk_period;
		x <= '1';
		
		wait for 1 * clk_period;
		x <= '0';
		wait for 2 * clk_period;
		x <= '1';
		
		-- check if latch mechanism is working by holding x for a long time and seeing if pulse doesn't go back to one (monopulse)
		wait for 5 * clk_period;
		x <= '0';
		wait for 3 * clk_period;
		x <= '1';
		wait for 5 * clk_period;
		x <= '0';

      wait;
   end process;

END;
