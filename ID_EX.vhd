entity ID_EX is
	port(
		clock : in bit;
		
		-- Entradas de controle
		I_branch: 			in bit;
		I_mem_wr:			in bit;
		I_memToReg:			in bit;
		I_aluCtl:			in bit_vector(3 downto 0);
		I_aluSrc:         in bit;
		I_regWrite:       in bit;
		
		-- Entradas de dados
		I_instruction31to21: in	bit_vector(10 downto 0);
		I_PC : 					in bit_vector(63 downto 0);
		I_Reg_Alu : 			in bit_vector(63 downto 0);
		I_Reg_Mux2 : 			in bit_vector(63 downto 0);
		I_SEOut : 				in bit_vector(63 downto 0);
		I_instruction4to0 : 	in bit_vector(4 downto 0);
	
		-- Saidas de controle
		O_branch: 			out bit;
		O_mem_wr:			out bit;
		O_memToReg:			out bit;
		O_aluCtl:			out bit_vector(3 downto 0);
		O_aluSrc:         out bit;
		O_regWrite:       out bit;
		
		-- Saidas de dados
		O_instruction31to21: out bit_vector(10 downto 0);
		O_PC : 					out bit_vector(63 downto 0);
		O_Reg_Alu : 			out bit_vector(63 downto 0);
		O_Reg_Mux2 : 			out bit_vector(63 downto 0);
		O_SEOut : 				out bit_vector(63 downto 0);
		O_instruction4to0 : 	out bit_vector(4 downto 0)
	);
end ID_EX;

architecture arch of ID_EX is

	signal I_controlReg, O_controlReg : bit_vector(8 downto 0);
	signal I_dataReg, O_dataReg : bit_vector(271 downto 0); 
	
	component reg is
		generic(
            wordSize: natural := 4
        );
        port(
            clock: in bit; --! entrada de clock
            reset: in bit; --! clear assíncrono
            load:  in bit; --! write enable (carga paralela)
            d:     in bit_vector(wordSize-1 downto 0); --! entrada
            q:     out bit_vector(wordSize-1 downto 0) --! saída
        );
    end component;
	
begin
	I_controlReg <= I_branch & I_mem_wr & I_memToReg & I_aluCtl & I_aluSrc & I_regWrite;
	I_dataReg <= I_instruction31to21 & I_PC & I_Reg_Alu & I_Reg_Mux2 & I_SEOut & I_instruction4to0;
	
	-- instanciando os registradores
	controlReg : reg generic map(9) port map(clock => clock, reset => '0', load => '1', d => I_controlReg, q => O_controlReg);
	dataReg : reg generic map(272) port map(clock => clock, reset => '0', load => '1', d => I_dataReg, q => O_dataReg);
	
	-- mapeando os sinais
	O_branch <= O_controlReg(8);
	O_mem_wr <= O_controlReg(7);
	O_memToReg <= O_controlReg(6);
	O_aluCtl <= O_controlReg(5 downto 2);
	O_aluSrc <= O_controlReg(1);
	O_regWrite <= O_controlReg(0);
	
	O_instruction31to21 <= O_dataReg(271 downto 261);
	O_PC <= O_dataReg(260 downto 197);
	O_Reg_Alu <= O_dataReg(196 downto 133);
	O_Reg_Mux2 <= O_dataReg(132 downto 69);
	O_SeOut <= O_dataReg(68 downto 5);
	O_instruction4to0 <= O_dataReg(4 downto 0);

end arch;