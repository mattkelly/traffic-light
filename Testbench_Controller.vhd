--------------------------------------------------------------------------------
-- Company: 
-- Engineer: Dan Grau + Matt Kelly
--
-- Create Date:   00:05:44 04/24/2013
-- Design Name:   
-- Module Name:   Z:/Documents/Class/Fault Tolerant Systems/Project/TrafficLightSystem/Testbench_Controller.vhd
-- Project Name:  TrafficLightSystem
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TrafficLightController
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
 
ENTITY Testbench_Controller IS
END Testbench_Controller;
 
ARCHITECTURE behavior OF Testbench_Controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TrafficLightController
    PORT(
         clk_50MHz : IN  std_logic;
         btn_north : IN  std_logic;
         ryg_light1 : OUT  std_logic_vector(2 downto 0);
         ryg_light2 : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk_50MHz : std_logic := '0';
   signal btn_north : std_logic := '0';

 	--Outputs
   signal ryg_light1 : std_logic_vector(2 downto 0);
   signal ryg_light2 : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_50MHz_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TrafficLightController PORT MAP (
          clk_50MHz => clk_50MHz,
          btn_north => btn_north,
          ryg_light1 => ryg_light1,
          ryg_light2 => ryg_light2
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
      
		-- Reset
		btn_north <= '1';
		wait for 200 ns;
		btn_north <= '0';

      wait;
   end process;

END;
