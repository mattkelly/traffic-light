----------------------------------------------------------------------------------
-- Company: Rochester Institute of Technology
-- Engineer: Dan Grau & Matt Kelly
-- 
-- Create Date:    11:26:21 04/22/2013 
-- Design Name: 
-- Module Name:    TrafficLightController - Behavioral 
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

entity TrafficLightController is
	port( clk_50MHz  : in std_logic; -- 50 MHz clock
			btn_north  : in std_logic; -- Synchronous reset
			
			-- Red (001), Yellow (010), Green (100)
			ryg_light1 : out std_logic_vector(2 downto 0);
			ryg_light2 : out std_logic_vector(2 downto 0)
	);
end TrafficLightController;

architecture Behavioral of TrafficLightController is

	signal sreset : std_logic;  -- Synchronous reset
	-- TODO probably need clock divider
	signal sclk_en : std_logic;

	-- States
	type tstate is (S0, S1, S2, S3, S4, S5, S6, S7);
	signal state : tstate;
	
	-- TODO how long?
	signal s1_ms : std_logic; -- Timer signal - high every 1 ms
	
	-- Counter
	-- TODO how big?
	signal scount : std_logic_vector(19 downto 0);
	signal scount_rst : std_logic;

begin

	sreset <= btn_north;
	s1_ms <= '1' when scount = (50000-1) else '0';
	scount_rst <= '1' when scount = (50000-1) else '0';

	------------------------------------
	-- State machine
	------------------------------------
	process( clk_50MHz )
	begin
		if clk_50MHz'event and clk_50MHz = '1' then
			if sreset = '1' then
				state <= S0;
			else
				case state is
					when S0 =>
						if s1_ms = '1' then
							state <= S1;
						end if;
					when S1 =>
						if s1_ms = '1' then
							state <= S2;
						end if;
					when S2 =>
						if s1_ms = '1' then
							state <= S3;
						end if;
					when S3 =>
						if s1_ms = '1' then
							state <= S4;
						end if;
					when S4 =>
						if s1_ms = '1' then
							state <= S5;
						end if;
					when S5 =>
						if s1_ms = '1' then
							state <= S0;
						end if;
						
					-- Unused states, shouldn't end up here
					when S6 => state <= S0;
					when S7 => state <= S0;
					when others => null;
				end case;
			end if;
		end if;
	end process;
	
	------------------------------------
	-- Assign outputs
	------------------------------------
	process( state, sreset )
	begin
		if sreset = '1' then
			ryg_light1 <= "001";
			ryg_light2 <= "001";
		else
			case state is
				when S0|S3|S6|S7 =>
					ryg_light1 <= "001"; -- Red
					ryg_light2 <= "001"; -- Red
				when S1 =>
					ryg_light1 <= "100"; -- Green
					ryg_light2 <= "001"; -- Red
				when S2 =>
					ryg_light1 <= "010"; -- Yellow
					ryg_light2 <= "001"; -- Red
				when S4 =>
					ryg_light1 <= "001"; -- Red
					ryg_light2 <= "100"; -- Green
				when S5 =>
					ryg_light1 <= "001"; -- Red 
					ryg_light2 <= "010"; -- Yellow
				when others =>
					-- Should never happen
					ryg_light1 <= "001"; -- Red
					ryg_light2 <= "001"; -- Red
			end case;
		end if;
	end process;
	
	-----------------------------------
	-- Counter
	-----------------------------------
	process( clk_50MHz )
	begin
		if clk_50MHz'event and clk_50MHz = '1' then
			if sreset = '1' or scount_rst = '1' then
				scount <= (others => '0');
			else
				scount <= scount + 1;
			end if;
		end if;
	end process;

end Behavioral;
