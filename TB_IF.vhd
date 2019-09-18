library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity TB_IF is
end entity;

architecture test of TB_IF is
	component Estagio_IF is
		port(
			clock: in bit;
			reset : in bit;
			
			-- Do pipeline/UC
			PCSrc:   in bit;
			Add1Out: in bit_vector(63 downto 0);
			
			
			-- Saidas
			IMemOut: out bit_vector(31 downto 0);
			PC: out bit_vector(63 downto 0)
		);
	end component;
	
	-- signals
	signal clock, reset, PCSrc : bit := '0';
	signal Add1Out, PC : bit_vector := (others => '0');
	signal IMemOut : bit_vector := (others => '0');
	
	begin
	
	IFComponent : Estagio_IF port map(
		clock => clock,
		reset => reset,
		PCSrc => PCSrc,
		Add1Out => Add1Out,
		IMemOut => IMemOut,
		PC => PC
		);
		
	testbench: process
	
	-- constants
	
	begin
		-- teste do Reset
		reset <= '1';
		wait for 20 ns;
		reset <= '0';
		wait for 20 ns;
		
		-- teste do Desvio]
		Add1Out <= "0000000000000000000000000000000000000000000000000000000000000100";
		PCSrc <= '1';
		wait for 20 ns;
		
		
	end process testbench;
	
	clock_gen: process
		begin
			clock <= not clock;
			wait for 10 ns;
   end process clock_gen;
	
end test;
	
