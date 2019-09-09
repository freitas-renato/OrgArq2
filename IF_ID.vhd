library ieee;
use ieee.std_logic_1164.ALL;

entity IF_ID is
	port(
		clock : in bit;
		
		-- Entradas de dados
		I_IMem : in bit_vector(31 downto 0);
		I_PC : in bit_vector(63 downto 0);
		
		-- Entradas de controle
		O_IMem : out bit_vector(31 downto 0);
		O_PC : out bit_vector(63 downto 0)
	);
end IF_ID;

architecture arch of IF_ID is
	signal IMemSignal : bit_vector(31 downto 0);
	signal PCSignal : bit_vector(63 downto 0);
	signal regIN, regOUT : bit_vector(95 downto 0);
	
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
	IMemSignal <= I_Imem;
	PCSignal <= I_PC;
	regIN <= IMemSignal & PCSignal;
	
	-- mapeando o registrador
	IF_IDReg : reg generic map(96) port map (clock => clock, reset => '0', load => '1', d => regIN, q => regOUT);
	
	-- mapeando as saidas
	O_Imem <= regOUT(95 downto 64);
	O_PC <= regOUT(63 downto 0);
end arch;
	