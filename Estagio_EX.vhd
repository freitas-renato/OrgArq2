library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

entity Estagio_EX is
	port(
	
		-- From pipeline/UC
		PC : in bit_vector(63 downto 0);
		Reg_Alu : in bit_vector(63 downto 0);
		Reg_Mux2In : in bit_vector(63 downto 0);
		SEOut : in bit_vector(63 downto 0);
		Instruction31to21In : in bit_vector(10 downto 0);
		Instruction4to0In : in bit_vector(4 downto 0);
		SelecaoALU : in bit_vector(3 downto 0);
		alu_Src : in bit;
		
		-- Saidas
		Add1Out : out bit_vector(63 downto 0);
		AluOut : out bit_vector(63 downto 0);
		ZeroAlu : out bit;
		Reg_Mux2 : out bit_vector(63 downto 0);
		Instruction4to0 : out bit_vector(4 downto 0);
		Instruction31to21 : out bit_vector(10 downto 0)
		
	);
end Estagio_EX;

architecture E_EX of Estagio_EX is

	signal signalPC, signalReg_Alu, signalReg_Mux2, Mux2Out, signalSEOut, SL2_Add1, signalAdd1Out, signalAluOut: bit_vector(63 downto 0);
	signal aluSrc, signalZeroAlu : bit;
	signal signalSelecaoALU : bit_vector(3 downto 0);
	
	component mux2to1 is
        generic(ws: natural := 4); -- word size
        port(
            s:    in  bit; -- selection: 0=a, 1=b
            a, b: in  bit_vector(ws-1 downto 0); -- inputs
            o:    out bit_vector(ws-1 downto 0)  -- output
        );
   end component;
	
	component shiftleft2 is
        generic(
            ws: natural := 64
        ); -- word size
        port(
            i: in  bit_vector(ws-1 downto 0); -- input
            o: out bit_vector(ws-1 downto 0)  -- output
        );
   end component;
	
	component alu is
        port (
            A, B : in  bit_vector(63 downto 0); -- inputs
            F    : out bit_vector(63 downto 0); -- output
            S    : in  bit_vector (3 downto 0); -- op selection
            Z    : out bit -- zero flag
        );
   end component;
	 
	 
	
begin

	-- Alocacao de pinos para sinais
	signalPC <= PC;
	signalReg_Alu <= Reg_Alu;
	signalReg_Mux2 <= Reg_Mux2In;
	aluSrc <= alu_Src;
	signalSelecaoALU <= SelecaoALU;
	signalSEOut <= SEOut;
	

	-- Mux numero 2 (vulgo imagem do monociclo)
	mux2 : mux2to1 generic map(64) port map(s => aluSrc, a => signalReg_Mux2, b => signalSEOut, o => Mux2Out);
	
	-- Shift left
	SL2 : shiftleft2 port map(i => signalSEOut, o => SL2_Add1);
	
	-- somador numero 1 (vulgo imagem do monociclo)
	add1 : alu port map(A => signalPC, B => SL2_Add1, F => Add1Out, S => "0010", Z => open);
	
	-- ALU numero 1 (vulgo imagem do monociclo)
	alu1 : alu port map(A => Reg_Alu, B => Mux2Out, F => signalAluOut, S => signalSelecaoALU, Z => signalZeroAlu);

	-- Saidas
	Instruction4to0 <= Instruction4to0In;
	Reg_Mux2 <= Reg_Mux2In;
	Instruction31to21 <= Instruction31to21In;
	Add1Out <= signalAdd1Out;
	ZeroAlu <= signalZeroAlu;
	AluOut <= signalAluOut;
	

end E_EX;