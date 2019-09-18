library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity Estagio_MEM is
	port(
		clock : in bit;
	
		-- Da UC, para o estagio MEM
		mem_w : in bit;
		mem_r : in bit;
		branch : in bit;
		
		-- Da UC, para o estagio seguinte
		I_RegWrite : in bit;
		I_MemToReg : in bit;
		
		-- De estagios anteriores
		I_AluOut : in bit_vector(63 downto 0);
		Reg_Mux2 : in bit_vector(63 downto 0);
		ZeroAlu : in bit;
		I_Add1Out : in bit_vector(63 downto 0);
		I_instruction4to0 : in bit_vector(4 downto 0);

		-- Para a UC
		PC_src : out bit;
		
		-- Para os proximo estagio
		O_MemToReg : out bit;
		O_RegWrite : out bit;
		O_AluOut : out bit_vector(63 downto 0);
		O_instruction4to0 : out bit_vector(4 downto 0);
		DMEmOut : out bit_vector(63 downto 0);
		
		-- Para estagios anteriores
		O_Add1Out : out bit_vector(63 downto 0)		
	);
end Estagio_MEM;

architecture arch of Estagio_MEM is

	signal PC_src_signal : bit;
	
	component ram is
        generic (
            addressSize : natural := 64;
            wordSize    : natural := 32
        );
        port (
            ck, wr : in  bit;
            addr   : in  bit_vector(addressSize-1 downto 0);
            data_i : in  bit_vector(wordSize-1 downto 0);
            data_o : out bit_vector(wordSize-1 downto 0)
        );
    end component;
	
	begin
	
	-- RAM
	DMem : ram generic map (addressSize => 64, wordSize => 64) port map (ck => clock, wr => mem_w, addr => I_AluOut, data_I => Reg_Mux2, data_O => DMemOut); 
	
	--I/O mapping
	PC_src_signal <= branch and ZeroAlu;
	PC_src <= PC_src_signal;
	O_MemToReg <= I_MemToReg;
	O_RegWrite <= I_RegWrite;
	O_AluOut <= I_AluOut;
	O_instruction4to0 <= I_instruction4to0;
	O_Add1Out <= I_Add1Out;
	
end arch;