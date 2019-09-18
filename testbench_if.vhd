library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity teste_if is
end entity;

architecture teste_estagio_if of teste_if is
    component Estagio_IF is 
        port(
            clock:    in bit;
            reset:    in bit;

            -- Do pipeline/UC
				PCSrc:   in bit;
				Add1Out: in bit_vector(63 downto 0);
		
		
				-- Saidas
				IMemOut: out bit_vector(31 downto 0);
				PC: out bit_vector(63 downto 0)
				
				
        );
    end component;

 
    signal clock: bit := '0';
    signal reset: bit := '0';
	 signal PCSrc: bit := '0';
	 signal Add1Out: bit_vector(63 downto 0) := (others=>'0');

	 signal IMemOut: bit_vector(31 downto 0) := (others=>'0');
	 signal PC: bit_vector(63 downto 0) := (others=>'0');
	
begin

    TESTE_IF: Estagio_IF port map(
        clock => clock,
        reset => reset,

		  PCSrc => PCSrc,
		  Add1Out => Add1Out,
		  
		  IMemOut => IMemOut, 
		  PC => PC
    );


    clock_gen: process
    begin
        clock <= not clock;
        wait for 10 ns;
    end process clock_gen;

end architecture;