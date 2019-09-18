library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity TB_ID is
end entity;

architecture testbench of TB_ID is
	component Estagio_ID is
		port(
			clock : in bit;
			reset : in bit;
		
			-- Da UC, para o estagio ID
			Reg2Loc : in bit;
		
			-- Sinais de controle vindos de estagios futuros
			I_regWrite:       in bit;
			
			-- De estagios anteriores
			I_PC : in bit_vector(63 downto 0);
			instruction : in bit_vector(31 downto 0);
			
			-- De estagios adiante
			Mux3Out : 				in bit_vector(63 downto 0);
			I_instruction4to0 : 	in bit_vector(4 downto 0);
			
			-- Para a UC e para o proximo estagio
			instruction31to21: out bit_vector(10 downto 0);
			
			-- Para os proximos estagios	
			-- Dados
			O_PC : out bit_vector(63 downto 0);
			Reg_Alu : out bit_vector(63 downto 0);
			Reg_Mux2 : out bit_vector(63 downto 0);
			SEOut : out bit_vector(63 downto 0);
			O_instruction4to0 : out bit_vector(4 downto 0)				
	);
	end component;
	
	--signals
	signal clock, reset, Reg2Loc, I_RegWrite : bit := '0';
	signal I_PC, Mux3Out, O_PC, Reg_Alu, Reg_Mux2, SEOut : bit_vector(63 downto 0) := (others => '0');
	signal instruction : bit_vector(32 downto 0) := (others => '0');
	signal I_instruction4to0, O_instruction4to0 : bit_vector(4 downto 0) := (others => '0');
	signal instruction31to21 : bit_vector(10 downto 0) := (others => '0');
	
	begin
		
		ID : Estagio_ID port map(
			clock => clock,
			reset => reset,
			Reg2Loc => Reg2Loc,
			I_regWrite => I_regWrite,
			I_PC => I_PC,
			instruction => instruction,
			Mux3Out => Mux3Out,
			I_instruction4to0 => I_instruction4to0,
			instruction31to21 => instruction31to21,
			O_PC => O_PC,
			Reg_Alu => Reg_Alu,
			Reg_Mux2 => Reg_Mux2,
			SEOut => SEOut, 
			O_instruction4to0 => O_instruction4to0
			);
			
		testbench_process : process
		-- constants
		
		begin
		-- 1) reset
		reset <= '1';
		wait for 25	ns;
		reset <= '0';
		wait for 5 ns;
		
		-- 2) escrita e leitura do Register File. Escrevendo "111...1" no registrador 1 e "01010101...01" no registrador 2
		I_regWrite <= '1';
		
		Mux3Out <= "1111111111111111111111111111111111111111111111111111111111111111";
		I_instruction4to0 <= "00001";
		wait for 50 ns;
		
		Mux3Out <= "0101010101010101010101010101010101010101010101010101010101010101";
		I_instruction4to0 <= "00010";		
		wait for 60 ns;
		
		I_regWrite <= '0';
		-- Testaremos com uma operação ADD $3,$2,$1 (Rd = Rm + Rn)
		instruction <= "10001011000" & "00010" & "000000" & "00001" & "00011";
		--					   opcode        Rm(R2)    shamt     Rn(R1)       Rd
		wait for 40 ns;
  		
		end process testbench_process;

		clock_gen: process
		begin
			clock <= not clock;
			wait for 10 ns;
		end process clock_gen;

end architecture;

	