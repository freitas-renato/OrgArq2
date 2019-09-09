entity MEM_WB is
	port(
		clock : in bit;
		
		-- Entradas de dados
		I_Alu : 					in bit_vector(63 downto 0);
		I_DMEm : 				in bit_vector(63 downto 0);
		I_instruction4to0 : 	in bit_vector(4 downto 0);
		
		-- Entradas de controle
		I_RegWrite : in bit;
		
		-- Saidas de dados
		O_Alu : 					out bit_vector(63 downto 0);
		O_DMEm : 				out bit_vector(63 downto 0);
		O_instruction4to0 : 	out bit_vector(4 downto 0);
		
		-- Saidas de controle	
		O_RegWrite : out bit
	);
end MEM_WB;

architecture arch of MEM_WB is
	signal I_controlDataReg, O_controlDataReg : bit_vector(133 downto 0);
	
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
	-- Para esse registrador em especifico, nao vou separa o sinal de controle dos de dados porque por algum motivo
	-- o Quartus acusa erro de VHDL se tentar usar um bit como bit_vector(0 downto 0)
	
	-- Concatenaçoes
	I_controlDataReg <= I_RegWrite & I_Alu & I_DMem & I_instruction4to0;
	
	-- Registradores
	controlDataReg : reg generic map(134) port map (clock => clock, reset => '0', load => '1', d => I_controlDataReg, q => O_controlDataReg);
	
	-- Saidas
	O_RegWrite <= O_controlDataReg(133);
	
	O_Alu <= O_controlDataReg(132 downto 69);
	O_DMem <= O_controldataReg(68 downto 5);
	O_instruction4to0 <= O_controldataReg(4 downto 0);

end arch;