entity MEM_WB is
	port(
		clock : in bit;
		
		-- Entradas de dados
		I_Alu : 					in bit_vector(63 downto 0);
		I_DMEm : 				in bit_vector(63 downto 0);
		I_instruction4to0 : 	in bit_vector(4 downto 0);
		
		-- Entradas de controle
		I_RegWrite : in bit;
		I_MemToReg : in bit;
		
		-- Saidas de dados
		O_Alu : 					out bit_vector(63 downto 0);
		O_DMEm : 				out bit_vector(63 downto 0);
		O_instruction4to0 : 	out bit_vector(4 downto 0);
		
		-- Saidas de controle	
		O_RegWrite : out bit;
		O_MemToReg : out bit
	);
end MEM_WB;

architecture arch of MEM_WB is
	signal I_dataReg, O_dataReg : bit_vector(132 downto 0);
	signal I_controlReg, O_controlReg : bit_vector(1 downto 0);
	
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
	I_dataReg <= I_Alu & I_DMem & I_instruction4to0;
	I_controlReg <= I_RegWrite & I_MemToReg;
	
	-- Registradores
	dataReg : reg generic map(133) port map (clock => clock, reset => '0', load => '1', d => I_dataReg, q => O_dataReg);
	controlReg : reg generic map(2) port map (clock => clock, reset => '0', load => '1', d => I_controlReg, q => O_controlReg);
	
	-- Saidas
	O_RegWrite <= O_controlReg(1);
	O_MemToReg <= O_controlReg(0);
	
	O_Alu <= O_dataReg(132 downto 69);
	O_DMem <= O_dataReg(68 downto 5);
	O_instruction4to0 <= O_dataReg(4 downto 0);

end arch;