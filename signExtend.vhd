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
    signal i_type, d_type, cb_type: bit := '0';

    signal alu_imm: bit_vector(11 downto 0) := (others => '0');
    signal dt_addr: bit_vector(8 downto 0)  := (others => '0');
    signal br_addr: bit_vector(18 downto 0) := (others => '0');

begin

    alu_imm <= i(21 downto 10);
    dt_addr <= i(20 downto 12);
    br_addr <= i(23 downto 5);

    -- 1001000100 -- addi
    -- 1101000100 -- subi
    -- 1001001000 -- andi
    -- 1011001000 -- orri

    with i(31 downto 22) select i_type <=
        '1' when "1001000100" or "1101000100" or "1001001000" or "1011001000",
        '0' when others;

    d_type  <= '1' when (i(26) = '0') and not(i_type) else '0';
    cb_tybe <= '1' when (i(26) = '1') and not (i_type) else '0';


    o <= bit_vector(resize(signed(alu_imm)), o'length) when i_type = '1' else
         bit_vector(resize(signed(dt_addr)), o'length) when d_type = '1' else
         bit_vector(resize(signed(br_addr)), o'length) when cb_type = '1' else
         (others => '0');

end combinational;
