library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity Estagio_ID is
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
end Estagio_ID;

architecture ID of Estagio_ID is
	
	signal Mux4Out : bit_vector(4 downto 0);
	
	component registerFile is
        port (
            Read1:      in bit_vector(4 downto 0);
            Read2:      in bit_vector(4 downto 0);
            WriteReg:   in bit_vector(4 downto 0); -- reg address
            WriteData:  in bit_vector(63 downto 0); 
            RegWrite:   in bit; --sinais de controle
            clock:      in bit;
				reset:		in bit;
            DataOut1:   out bit_vector(63 downto 0);
            DataOut2:   out bit_vector(63 downto 0)
        );
    end component;
	 
	 component mux2to1 is
        generic(ws: natural := 4); -- word size
        port(
            s:    in  bit; -- selection: 0=a, 1=b
            a, b: in  bit_vector(ws-1 downto 0); -- inputs
            o:    out bit_vector(ws-1 downto 0)  -- output
        );
    end component;
	 
	 component signExtend is
        -- Size of output is expected to be greater than input
        generic(
            ws_in:  natural := 32; -- input word size
            ws_out: natural := 64  -- output word size
        );
        port(
            i: in  bit_vector(ws_in-1  downto 0); -- input
            o: out bit_vector(ws_out-1 downto 0)  -- output
        );
    end component;	 
	 
	
	begin
	
	--mux
	mux_4 : mux2to1 generic map(ws => 5) port map (s => Reg2Loc, a=> instruction(20 downto 16), b => instruction(4 downto 0), o => Mux4Out);
	
	--sign extender
	SE : signExtend port map(i => instruction, o => SEOut);
	
	--register file
	regFile : registerFile port map(Read1 => instruction(9 downto 5), Read2 => Mux4Out, WriteReg => I_instruction4to0, WriteData => Mux3Out, RegWrite => I_RegWrite, clock => clock, reset => reset, DataOut1 => Reg_Alu, DataOut2 => Reg_Mux2);
	
	-- I/O mapping
	instruction31to21 <= instruction(31 downto 21);
	O_instruction4to0 <= instruction(4 downto 0);
	
end ID;