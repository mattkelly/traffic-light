--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:19:12 04/27/2013
-- Design Name:   
-- Module Name:   Z:/Documents/Class/Fault Tolerant Systems/Project/TrafficLightSystem/Testbench.vhd
-- Project Name:  TrafficLightSystem
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TrafficLightSystem
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
 
ENTITY Testbench IS
END Testbench;
 
ARCHITECTURE behavior OF Testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TrafficLightSystem
    PORT(
         clk_50MHz : IN  std_logic;
         btn_north : IN  std_logic;
         switches : IN  std_logic_vector(3 downto 0);
         leds : OUT  std_logic_vector(7 downto 0);
         faulty_mod : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_50MHz : std_logic := '0';
   signal btn_north : std_logic := '0';
   signal switches : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal leds : std_logic_vector(7 downto 0);
   signal faulty_mod : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_50MHz_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TrafficLightSystem PORT MAP (
          clk_50MHz => clk_50MHz,
          btn_north => btn_north,
          switches => switches,
          leds => leds,
          faulty_mod => faulty_mod
        );

   -- Clock process definitions
   clk_50MHz_process :process
   begin
		clk_50MHz <= '0';
		wait for clk_50MHz_period/2;
		clk_50MHz <= '1';
		wait for clk_50MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_50MHz_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
