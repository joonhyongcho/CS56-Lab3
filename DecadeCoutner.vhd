----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:03:41 07/23/2015 
-- Design Name: 
-- Module Name:    DecadeCounter - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DecadeCounter is
    Port ( CLK : in STD_LOGIC;
				en_in : in  STD_LOGIC;
           clear : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (3 downto 0);
           en_out : out  STD_LOGIC);
end DecadeCounter;

architecture Behavioral of DecadeCounter is
	signal t_count : unsigned(3 downto 0) := (others => '0');
begin

	-- this is the main process that incremeents the coutner
	process (CLK, clear)
	begin
		-- if clear, then it resets, and this takes precedence over everything
		if (clear = '1') then
			-- on rising edge, set t_coutn to 0
			if (rising_edge(CLK)) then
				t_count <= (others => '0');
			end if;
		-- if t_count is 9, and we know that it won't go over since this is a coutner, then we reset if..
		elsif (t_count = 9) then		
			-- if rising_edge, and en_in, then reset, otherwise we hold 9
			if (rising_edge(CLK)) then
				if (en_in = '1') then
					t_count <= (others => '0');
				else 
					t_count <= t_count;
				end if;
			end if;
		-- else if en_in is 1, then we increment on clock edge or just hold if en_in is not 1
		elsif (rising_edge(CLK)) then
			if (en_in = '1') then
				t_count <= t_count + 1;
			else
				t_count <= t_count;
			end if;
		end if;
		
	end process;
	
	-- This process takes care of setting en_out
	en_out_p : process (t_count, en_in)
	begin
		-- if we are at 9, and en_in = 1, then en_out becomes 1
		if (t_count = 9) then
			if (en_in = '1') then
				en_out <= '1';
			else 
				-- as soon as en_in = 0 (because process reacts to en_in), en_out becomes 0
				en_out <= '0';
			end if;
		else
			-- if not at 9, then en_out = 0;
			en_out <= '0';
		end if;
	end process en_out_p;
	
	-- take intermediate signal and put it into output
	Q <= std_logic_vector(t_count);


end Behavioral;

