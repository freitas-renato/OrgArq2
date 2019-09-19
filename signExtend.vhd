-------------------------------------------------------
--! @file signExtend.vhdl
--! @author balbertini@usp.br
--! @date 20180730
--! @brief 2-complement sign extension used on polileg.
-------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

-- pag 271 livro 

entity signExtend is
    -- Size of output is expected to be greater than input
    generic(
        ws_in:  natural := 32; -- input  word size
        ws_out: natural := 64  -- output word size
    );
    port(
        i: in  bit_vector(ws_in - 1  downto 0); -- input
        o: out bit_vector(ws_out - 1 downto 0) := (others => '0')  -- output
    );
end signExtend;

architecture combinational of signExtend is
    signal i_type, d_type, cb_type, b_type: bit := '0';

    signal alu_imm: bit_vector(11 downto 0) := (others => '0');
    signal dt_addr: bit_vector(8 downto 0)  := (others => '0');
    signal cond_br_addr: bit_vector(18 downto 0) := (others => '0');
	 signal br_addr : bit_vector(25 downto 0) := (others => '0');
	 signal o_alu_imm, o_dt, o_cond_br, o_br : bit_vector(ws_out - 1 downto 0) := (others => '0');

begin

    alu_imm <= i(21 downto 10);
    dt_addr <= i(20 downto 12);
    cond_br_addr <= i(23 downto 5);
	 br_addr <= i(25 downto 0);

    -- 1001000100 -- addi
    -- 1101000100 -- subi
    -- 1001001000 -- andi
    -- 1011001000 -- orri

    with i(31 downto 22) select i_type <=
        '1' when "1001000100" | "1101000100" | "1001001000" | "1011001000",
        '0' when others;

    b_type <= '1' when ((i(31 downto 29) = "101")) else '0';
	 d_type  <= '1' when ((i(26) = '0') and (i_type = '0')) else '0';
    cb_type <= '1' when ((i(26) = '1') and (i_type = '0')) else '0';
	
	 o_alu_imm <= bit_vector(resize(signed(alu_imm), o'length));
	 o_dt <= bit_vector(resize(signed(dt_addr), o'length));
	 o_cond_br <= bit_vector(resize(signed(cond_br_addr), o'length));
	 o_br <= bit_vector(resize(signed(br_addr), o'length));
	 
    o <= o_cond_br when cb_type = '1' else
			o_br when b_type = '1' else
			o_alu_imm when i_type = '1' else
         o_dt when d_type = '1' else		
         (others => '0');

end combinational;
