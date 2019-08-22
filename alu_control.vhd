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

begin
    alu_function <=  "0010" when alu_op = "00" else -- LDUR/STUR
                     "0111" when alu_op = "01" else -- CBZ
                     "0010" when alu_op = "10" and opcode = "10001011000" else
                     "0110" when alu_op = "10" and opcode = "11001011000" else
                     "0000" when alu_op = "10" and opcode = "10001010000" else
                     "0001" when alu_op = "10" and opcode = "10101010000" else
                     "0000";
end architecture;
