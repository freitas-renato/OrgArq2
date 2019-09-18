library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity alu_control is 
    port(
        opcode: in bit_vector(10 downto 0);
        alu_op: in bit_vector(1 downto 0);

        alu_function: out bit_vector(3 downto 0)
    );
end alu_control;

architecture alu_control_arch of alu_control is
    signal operation: bit_vector(1 downto 0) := (others => '0');
begin

    operation <= "00" when opcode = "10001011000" or opcode = "10010001000" or opcode = "10010001001" else
                 "01" when opcode = "11001011000" or opcode = "11010001000" or opcode = "11010001001" else
                 "10" when opcode = "10001010000" or opcode = "10010010000" or opcode = "10010010001" else 
                 "11" when opcode = "10101010000" or opcode = "10110010000" or opcode = "10110010001" else 
                 "00";


    alu_function <=  "0010" when alu_op = "00" else -- LDUR/STUR
                     "0111" when alu_op = "01" else -- CBZ
                     "0010" when alu_op = "10" and operation = "00" else
                     "0110" when alu_op = "10" and operation = "01" else
                     "0000" when alu_op = "10" and operation = "10" else
                     "0001" when alu_op = "10" and operation = "11" else
                     "0000";
end architecture;
