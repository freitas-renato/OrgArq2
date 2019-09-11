library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

entity Estagio_WB is
	port(
	
		-- Entradas de estagios anteriores
		AluOut: 					in bit_vector(63 downto 0);
		DMemOut: 				in bit_vector(63 downto 0);
		Instruction4to0In: 	in bit_vector(4 downto 0);
		
		-- Entradas de controle para o estagio WB
		MemtoReg: in bit;
		
		-- Entradas de controle para estagios anteriores
		I_RegWrite : in bit;
		
		-- Saidas de dados
		Instruction4to0: 	out bit_vector(4 downto 0);
		Mux3Out: 			out bit_vector(63 downto 0);
		
		-- Saidas de controle
		O_RegWrite : out bit
	);
end Estagio_WB;

architecture E_WB of Estagio_WB is
	
	signal signalAluOut, signalDMemOut, signalMux3Out : bit_vector(63 downto 0);
	signal signalMemtoReg : bit;
	
	component mux2to1 is
        generic(ws: natural := 4); -- word size
        port(
            s:    in  bit; -- selection: 0=a, 1=b
            a, b: in  bit_vector(ws-1 downto 0); -- inputs
            o:    out bit_vector(ws-1 downto 0)  -- output
        );
   end component;
	

begin

	-- Alocacao de pinos para sinais
	signalMemtoReg <= MemtoReg;
	signalDMemOut <= DMemOut;
	signalAluOut <= AluOut;	

	-- MUX numero 3 (vulgo imagem do monociclo)
	mux3 : mux2to1 generic map(64) port map(s => signalMemtoReg, a => signalDMemOut, b => signalAluOut, o => signalMux3Out);
	
	-- Saidas
	Instruction4to0 <= Instruction4to0In;
	Mux3Out <= signalMux3Out;
	
	O_RegWrite <= I_RegWrite;

end E_WB;