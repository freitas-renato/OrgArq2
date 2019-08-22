library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

entity registerFile is -- incluir um sinal de RESET ?
  port (
    Read1, Read2, WriteReg: in bit_vector(4 downto 0); --inputs
	 WriteData : in bit_vector(63 downto 0);
	 RegWrite, clock: in bit; --sinais de controle
	 DataOut1, DataOut2: out bit_vector(63 downto 0)
    );
	 
	 
end registerFile;

architecture arch of registerFile is

	component reg is
		generic(wordSize: natural := 4);
		port(
			clock:    in 	bit; --! entrada de clock
			reset:	  in 	bit; --! clear assíncrono
			load:     in 	bit; --! write enable (carga paralela)
			d:   			in	bit_vector(wordSize-1 downto 0); --! entrada
			q:  			out	bit_vector(wordSize-1 downto 0) --! saída
		);
	end component;
	
	type dataBus_type is array (0 to 31) of bit_vector(63 downto 0);
	signal dataBus : dataBus_type;
	signal loadSelection : bit_vector(31 downto 0);
	
	begin
	loadSelection(00) <= not (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(01) <= not (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and     (WriteReg(0));
	loadSelection(02) <= not (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and 	 (WriteReg(1)) and not (WriteReg(0));
	loadSelection(03) <= not (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and 	 (WriteReg(1)) and 	  (WriteReg(0));
	loadSelection(04) <= not (WriteReg(4)) and not (WriteReg(3)) and 	   (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(05) <= not (WriteReg(4)) and not (WriteReg(3)) and     (WriteReg(2)) and not (WriteReg(1)) and     (WriteReg(0));
	loadSelection(06) <= not (WriteReg(4)) and not (WriteReg(3)) and     (WriteReg(2)) and     (WriteReg(1)) and not (WriteReg(0));
	loadSelection(07) <= not (WriteReg(4)) and not (WriteReg(3)) and 	   (WriteReg(2)) and	    (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(08) <= not (WriteReg(4)) and     (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(09) <= not (WriteReg(4)) and 	  (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(10) <= not (WriteReg(4)) and 	  (WriteReg(3)) and not (WriteReg(2)) and	    (WriteReg(1)) and not (WriteReg(0));
	loadSelection(11) <= not (WriteReg(4)) and 	  (WriteReg(3)) and not (WriteReg(2)) and	    (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(12) <= not (WriteReg(4)) and 	  (WriteReg(3)) and 	   (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(13) <= not (WriteReg(4)) and 	  (WriteReg(3)) and		(WriteReg(2)) and not (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(14) <= not (WriteReg(4)) and 	  (WriteReg(3)) and	   (WriteReg(2)) and	    (WriteReg(1)) and not (WriteReg(0));
	loadSelection(15) <= not (WriteReg(4)) and 	  (WriteReg(3)) and	   (WriteReg(2)) and	    (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(16) <= 	 (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(17) <= 	 (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(18) <= 	 (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and		 (WriteReg(1)) and not (WriteReg(0));
	loadSelection(19) <= 	 (WriteReg(4)) and not (WriteReg(3)) and not (WriteReg(2)) and		 (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(20) <= 	 (WriteReg(4)) and not (WriteReg(3)) and 	   (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(21) <= 	 (WriteReg(4)) and not (WriteReg(3)) and	   (WriteReg(2)) and not (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(22) <= 	 (WriteReg(4)) and not (WriteReg(3)) and	   (WriteReg(2)) and		 (WriteReg(1)) and not (WriteReg(0));
	loadSelection(23) <= 	 (WriteReg(4)) and not (WriteReg(3)) and	   (WriteReg(2)) and		 (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(24) <= 	 (WriteReg(4)) and 	  (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(25) <= 	 (WriteReg(4)) and 	  (WriteReg(3)) and not (WriteReg(2)) and not (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(26) <= 	 (WriteReg(4)) and	  (WriteReg(3)) and not (WriteReg(2)) and		 (WriteReg(1)) and not (WriteReg(0));
	loadSelection(27) <= 	 (WriteReg(4)) and	  (WriteReg(3)) and not (WriteReg(2)) and		 (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(28) <= 	 (WriteReg(4)) and	  (WriteReg(3)) and	   (WriteReg(2)) and not (WriteReg(1)) and not (WriteReg(0));
	loadSelection(29) <= 	 (WriteReg(4)) and	  (WriteReg(3)) and	   (WriteReg(2)) and not (WriteReg(1)) and	  (WriteReg(0));
	loadSelection(30) <= 	 (WriteReg(4)) and	  (WriteReg(3)) and	   (WriteReg(2)) and     (WriteReg(1)) and not (WriteReg(0));
	loadSelection(31) <= '0'; -- nunca é possível escrever no registrador 31, que armazena a constante 0
	
	GENERATE_REGISTERS:
	for I in 0 to 31 generate
		REG_FILE : reg 
		generic map(
			wordSize => 64
		)
		port map(
			clock => clock,
			reset => '0',
			load => loadSelection(I),
			d => WriteData,
			q => dataBus(I)
		);
	end generate GENERATE_REGISTERS;
	
	with Read1 select
		DataOut1 <= dataBus(00) when "00000",
						dataBus(01) when "00001",
						dataBus(02) when "00010",
						dataBus(03) when "00011",
						dataBus(04) when "00100",
						dataBus(05) when "00101",
						dataBus(06) when "00110",
						dataBus(07) when "00111",
						dataBus(08) when "01000",
						dataBus(09) when "01001",
						dataBus(10) when "01010",
						dataBus(11) when "01011",
						dataBus(12) when "01100",
						dataBus(13) when "01101",
						dataBus(14) when "01110",
						dataBus(15) when "01111",
						dataBus(16) when "10000",
						dataBus(17) when "10001",
						dataBus(18) when "10010",
						dataBus(19) when "10011",
						dataBus(20) when "10100",
						dataBus(21) when "10101",
						dataBus(22) when "10110",
						dataBus(23) when "10111",
						dataBus(24) when "11000",
						dataBus(25) when "11001",
						dataBus(26) when "11010",
						dataBus(27) when "11011",
						dataBus(28) when "11100",
						dataBus(29) when "11101",
						dataBus(30) when "11110",
						dataBus(31) when others;

	with Read2 select
		DataOut2 <= dataBus(00) when "00000",
						dataBus(01) when "00001",
						dataBus(02) when "00010",
						dataBus(03) when "00011",
						dataBus(04) when "00100",
						dataBus(05) when "00101",
						dataBus(06) when "00110",
						dataBus(07) when "00111",
						dataBus(08) when "01000",
						dataBus(09) when "01001",
						dataBus(10) when "01010",
						dataBus(11) when "01011",
						dataBus(12) when "01100",
						dataBus(13) when "01101",
						dataBus(14) when "01110",
						dataBus(15) when "01111",
						dataBus(16) when "10000",
						dataBus(17) when "10001",
						dataBus(18) when "10010",
						dataBus(19) when "10011",
						dataBus(20) when "10100",
						dataBus(21) when "10101",
						dataBus(22) when "10110",
						dataBus(23) when "10111",
						dataBus(24) when "11000",
						dataBus(25) when "11001",
						dataBus(26) when "11010",
						dataBus(27) when "11011",
						dataBus(28) when "11100",
						dataBus(29) when "11101",
						dataBus(30) when "11110",
						dataBus(31) when others;
		
end arch;