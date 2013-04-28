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
			btn_north  : in std_logic; -- Asynchronous reset

			-- switches 0-2 inject faults into modules,
			-- switch 3 changes between fault readout and lights on LEDs
			switches : in std_logic_vector(3 downto 0);

			-- 8 LEDs
			leds : out std_logic_vector(7 downto 0);
			
			-- Output to denote faulty module --
			faulty_mod : out std_logic_vector(2 downto 0)
	);
end TrafficLightSystem;

architecture Behavioral of TrafficLightSystem is

	component TrafficLightController is
		port( clk_50MHz  : in std_logic; -- 50 MHz clock
				reset      : in std_logic; -- Asynchronous reset
				
				-- Red (001), Yellow (010), Green (100)
				ryg_light1 : out std_logic_vector(2 downto 0);
				ryg_light2 : out std_logic_vector(2 downto 0)
		);
	end component;
	
	signal sreset : std_logic;  -- reset
	
	signal mod0_ryg1, mod0_ryg2, mod1_ryg1, mod1_ryg2, mod2_ryg1, mod2_ryg2 : std_logic_vector(2 downto 0);
	signal mod0_ryg1_x, mod0_ryg2_x, mod1_ryg1_x, mod1_ryg2_x, mod2_ryg1_x, mod2_ryg2_x : std_logic_vector(2 downto 0);

	-- Red (001), Yellow (010), Green (100)
	signal ryg_light1 : std_logic_vector(2 downto 0);
	signal ryg_light2 : std_logic_vector(2 downto 0);
	
	-- Signal to denote faulty module
	signal sfaulty_mod : std_logic_vector(2 downto 0);
	
begin

	-- reset
	sreset <= btn_north;

	mod0: TrafficLightController PORT MAP (
		clk_50MHz => clk_50MHz,
		reset => sreset,
		ryg_light1 => mod0_ryg1,
		ryg_light2 => mod0_ryg2
	);
	mod1: TrafficLightController PORT MAP (
		clk_50MHz => clk_50MHz,
		reset => sreset,
		ryg_light1 => mod1_ryg1,
		ryg_light2 => mod1_ryg2
	);
	mod2: TrafficLightController PORT MAP (
		clk_50MHz => clk_50MHz,
		reset => sreset,
		ryg_light1 => mod2_ryg1,
		ryg_light2 => mod2_ryg2
	);
	
	-- outputs to indicate faulty modules
	faulty_mod <= sfaulty_mod;
	
	-- inject faults
	mod0_ryg1_x <= mod0_ryg1 or (switches(0) & switches(0) & switches(0));
	mod0_ryg2_x <= mod0_ryg2 or (switches(0) & switches(0) & switches(0));

	mod1_ryg1_x <= mod1_ryg1 or (switches(1) & switches(1) & switches(1));
	mod1_ryg2_x <= mod1_ryg2 or (switches(1) & switches(1) & switches(1));

	mod2_ryg1_x <= mod2_ryg1 or (switches(2) & switches(2) & switches(2));
	mod2_ryg2_x <= mod2_ryg2 or (switches(2) & switches(2) & switches(2));

	--voter--
	ryg_light1 <= (mod0_ryg1_x and mod1_ryg1_x) or (mod0_ryg1_x and mod2_ryg1_x) or (mod1_ryg1_x and mod2_ryg1_x);
	ryg_light2 <= (mod0_ryg2_x and mod1_ryg2_x) or (mod0_ryg2_x and mod2_ryg2_x) or (mod1_ryg2_x and mod2_ryg2_x);
	
	-- faulty module detection
	process( clk_50MHz, sreset )
	begin
		
		if sreset = '1' then
			sfaulty_mod <= "000";
		elsif clk_50MHz'event and clk_50MHz = '1' then
			-- clocking this to get rid of combinatorial loops for faulty_mod
			-- once fault is detected, its output stays high until reset
			if sfaulty_mod(0) = '0' and (mod0_ryg1_x /= ryg_light1 or mod0_ryg2_x /= ryg_light2) then
				sfaulty_mod(0) <= '1';
			end if;
			
			if sfaulty_mod(1) = '0' and (mod1_ryg1_x /= ryg_light1 or mod1_ryg2_x /= ryg_light2) then
				sfaulty_mod(1) <= '1';
			end if;		
			
			if sfaulty_mod(2) = '0' and (mod2_ryg1_x /= ryg_light1 or mod2_ryg2_x /= ryg_light2) then
				sfaulty_mod(2) <= '1';
			end if;
		end if;
	end process;

	-- process to control led outputs
	process( switches(3), ryg_light2, ryg_light1, sfaulty_mod )
	begin
		if switches(3) = '0' then
			leds <= "00" & ryg_light1 & ryg_light2;
		else
			leds <= "00000" & sfaulty_mod;
		end if;
	end process;

end Behavioral;
