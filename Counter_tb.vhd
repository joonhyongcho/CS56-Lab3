--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:43:55 07/23/2015
-- Design Name:   
-- Module Name:   O:/ENGS31/Lab3/Counter_tb.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DecadeCounter
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
 
ENTITY Counter_tb IS
END Counter_tb;
 
ARCHITECTURE behavior OF Counter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DecadeCounter
    PORT(
         CLK : IN  std_logic;
         en_in : IN  std_logic;
         clear : IN  std_logic;
         Q : OUT  std_logic_vector(3 downto 0);
         en_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal en_in : std_logic := '0';
   signal clear : std_logic := '0';

 	--Outputs
   signal Q : std_logic_vector(3 downto 0);
   signal en_out : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DecadeCounter PORT MAP (
          CLK => CLK,
          en_in => en_in,
          clear => clear,
          Q => Q,
          en_out => en_out
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
      -- hold reset state for 30 ns.
      wait for 30 ns;	

      -- insert stimulus here 
		
		-- Start incremeneting  (tests if en_out and increment works properly)
		en_in <= '1';
		clear <= '0';
		
		wait for 14 * clk_period;
				
		-- clear to 0
		clear <= '1';
		
		wait for 2 * clk_period;
		
		-- checks if override en_in
		en_in <= '0';
		
		wait for 2 * clk_period;
		-- Starts incremeneting again
		en_in <= '1';
		clear <= '0';
		
		wait for 9 * clk_period;
		-- check if en_out reacts to en_in
		en_in <= '0';
		
		

      wait;
   end process;

END;
