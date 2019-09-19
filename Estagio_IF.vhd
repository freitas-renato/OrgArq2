library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

entity Estagio_IF is
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
end Estagio_IF;

architecture E_IF of Estagio_IF is

	signal Add2Out, Mux1Out, signalPC, signalAdd1Out : bit_vector(63 downto 0);
	signal ZeroAlu, SelecaoMux1 : bit;
	signal signalIMemOut: bit_vector(31 downto 0);
	signal sinal4bits: bit_vector(63 downto 0) := (2 => '1', others => '0');
	
	
	component mux2to1 is
        generic(ws: natural := 4); -- word size
        port(
            s:    in  bit; -- selection: 0=a, 1=b
            a, b: in  bit_vector(ws-1 downto 0); -- inputs
            o:    out bit_vector(ws-1 downto 0)  -- output
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
	 
	 component rom is
      generic (
         addressSize : natural := 64;
         wordSize    : natural := 32;
         mifFileName : string  := "rom.dat"
      );
      port (
         addr : in  bit_vector(addressSize-1 downto 0);
         data : out bit_vector(wordSize-1 downto 0)
      );
    end component;

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

	-- Alocacao de pinos para os sinais
	SelecaoMux1 <= PCSrc;
	signalAdd1Out <= Add1Out;

	-- MUX numero 1 (vulgo a imagem do monociclo)
	mux1 : mux2to1 generic map(64) port map(s => SelecaoMux1, a => Add2Out, b => signalAdd1Out, o => Mux1Out);
	
	-- PC
	programCounter : reg generic map(64) port map(clock => clock, reset => reset, load => '1', d => Mux1Out, q => signalPC);
	
	-- Memoria de instrucao
	IMem : rom generic map (mifFileName => "rom.txt", addressSize => 64) port map(addr => signalPC, data => signalIMemOut);
	
	-- Somador numero 2 (vulgo a imagem do monociclo)
	sinal4bits <= (2 => '1', others => '0');
	add2 : alu port map(A => signalPC, B => sinal4bits, F => Add2Out, S => "0010", Z => open);
	
	--Alocacao de pinos de saida
	PC <= signalPC;
	IMemOut <= signalIMemOut;
	

	
end E_IF;