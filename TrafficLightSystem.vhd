----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Dan Grau & Matt Kelly
-- 
-- Create Date:    11:26:21 04/22/2013 
-- Design Name: 
-- Module Name:    TrafficLightSystem - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TrafficLightSystem is
	port( clk_50MHz  : in std_logic; -- 50 MHz clock
			btn_north  : in std_logic; -- Synchronous reset
			
			-- Red (001), Yellow (010), Green (100)
			ryg_light1 : out std_logic_vector(2 downto 0);
			ryg_light2 : out std_logic_vector(2 downto 0);
			-- Output to denote faulty module --
			faulty_mod : out std_logic_vector(2 downto 0);
			
			-- TODO: add switch control to create faults
	);
end TrafficLightSystem;

architecture Behavioral of TrafficLightSystem is

	component TrafficLightController is
		port( clk_50MHz  : in std_logic; -- 50 MHz clock
				btn_north  : in std_logic; -- Synchronous reset
				
				-- Red (001), Yellow (010), Green (100)
				ryg_light1 : out std_logic_vector(2 downto 0);
				ryg_light2 : out std_logic_vector(2 downto 0)
		);
	end component;
	
	signal sreset : std_logic;  -- reset
	
	signal mod0_ryg1, mod0_ryg2, mod1_ryg1, mod1_ryg2, mod2_ryg1, mod2_ryg2 : std_logic_vector(2 downto 0);
	
begin

	mod0: TrafficLightController PORT MAP (
		clk_50MHz => clk_50MHz,
		btn_north => btn_north,
		ryg_light1 => mod0_ryg1,
		ryg_light2 => mod0_ryg2
	);
	mod1: TrafficLightController PORT MAP (
		clk_50MHz => clk_50MHz,
		btn_north => btn_north,
		ryg_light1 => mod1_ryg1,
		ryg_light2 => mod1_ryg2
	);
	mod2: TrafficLightController PORT MAP (
		clk_50MHz => clk_50MHz,
		btn_north => btn_north,
		ryg_light1 => mod2_ryg1,
		ryg_light2 => mod2_ryg2
	);
	
	--voter--
	ryg_light1 <= (mod0_ryg1 and mod1_ryg1) or (mod0_ryg1 and mod2_ryg1) or (mod1_ryg1 and mod2_ryg1);
	ryg_light2 <= (mod0_ryg2 and mod1_ryg2) or (mod0_ryg2 and mod2_ryg2) or (mod1_ryg2 and mod2_ryg2);
	
	-- faulty module detection
	process( ryg_light1, ryg_light2 )
	begin
		if sreset = '1' then
			faulty_mod <= "000";
		end if;
		-- once fault is detected, its output stay high until reset
		if faulty_mod(0) = '0' and (mod0_ryg1 /= ryg_light1 or mod0_ryg2 /= ryg_light2) then
			faulty_mod(0) <= '1';
		end if;
		if faulty_mod(1) = '0' and (mod1_ryg1 /= ryg_light1 or mod1_ryg2 /= ryg_light2) then
			faulty_mod(1) <= '1';
		end if;
		if faulty_mod(2) = '0' and (mod2_ryg1 /= ryg_light1 or mod2_ryg2 /= ryg_light2) then
			faulty_mod(2) <= '1';
		end if;
	end process;

end Behavioral;
