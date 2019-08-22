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
    signal length, start: natural := 0;

    signal dt_address: bit_vector(8 downto 0) := (others => '0');
    signal br_address: bit_vector(18 downto 0):= (others => '0');

begin

    dt_address <= i(20 downto 12);
    br_address <= i(23 downto 5);

    o <= bit_vector(resize(signed(dt_address), o'length)) when i(26) = '0' else
         bit_vector(resize(signed(br_address), o'length)) when i(26) = '1' else
         (others => '0');

    -- with i(26) select length <=
    --     9  when '0',
    --     19 when '1';

    -- with i(26) select start <=
    --     12 when '0',
    --     5  when '1';

    -- lsb: for idx in start to (length - 1) generate
    --     o(idx - start) <= i(idx);
    -- end generate;

    -- msb: for idx in (length) to (o'length - 1) generate
    --     o(idx) <= i(length - 1 + start);
    -- end generate;


end combinational;
