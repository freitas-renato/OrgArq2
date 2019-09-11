entity EX_MEM is
	port(
		clock : in bit;
		
		-- Entradas de dados
		I_Add1 : 					in bit_vector(63 downto 0);
		I_Alu : 						in bit_vector(63 downto 0);
		I_Reg_Mux2 : 				in bit_vector(63 downto 0);
		I_Instruction4to0 : 		in bit_vector(4 downto 0);
		
		-- Entradas de controle
		I_ZeroAlu : 	in bit;
		I_branch : 		in bit;
		I_mem_w : 		in bit;
		I_mem_r : 		in bit;
		I_memToReg: 	in bit;
		I_regWrite:    in bit;
		
		-- Saidas de dados
		O_Add1 : 					out bit_vector(63 downto 0);
		O_Alu : 						out bit_vector(63 downto 0);
		O_Reg_Mux2 : 				out bit_vector(63 downto 0);
		O_Instruction4to0 : 		out bit_vector(4 downto 0);
		
		-- Saidas de controle
		O_ZeroAlu : 	out bit;
		O_branch : 		out bit;
		O_mem_w : 		out bit;
		O_mem_r : 		out bit;
		O_memToReg: 	out bit;
		O_regWrite:    out bit
	);
end EX_MEM;

architecture arch of EX_MEM is
	
	signal I_controlReg, O_controlReg : bit_vector(5 downto 0);
	signal I_dataReg, O_dataReg : bit_vector(196 downto 0);
	
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
	-- Concatenaçoes
	I_controlReg <= I_ZeroAlu & I_branch & I_mem_w & I_mem_r & I_memToReg & I_regWrite;
	I_dataReg <= I_Add1 & I_Alu & I_Reg_Mux2 & I_Instruction4to0;
	
	-- Alocaçao dos registradores
	controlReg : reg generic map(6) port map (clock => clock, reset => '0', load => '1', d => I_controlReg, q => O_controlReg);
	dataReg : reg generic map(197) port map (clock => clock, reset => '0', load => '1', d => I_dataReg, q => O_dataReg);
	
	-- Mapeando as saidas
	O_ZeroAlu <= O_controlReg(5);
	O_branch <= O_controlReg(4);
	O_mem_w <= O_controlReg(3);
	O_mem_r <= O_controlReg(2);
	O_memToReg <= O_controlReg(1);
	O_regWrite <= O_controlReg(0);
	
	O_Add1 <= O_dataReg(196 downto 133);
	O_Alu <= O_dataReg(132 downto 69);
	O_Reg_Mux2 <= O_dataReg(68 downto 5);
	O_Instruction4to0 <= O_dataReg(4 downto 0);

end arch;