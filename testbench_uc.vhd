library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity teste_uc is
end entity;

architecture uc_tb of teste_uc is
    component control_unit is 
        port(
            clk:    in bit;
            rst:    in bit;

            opcode: in bit_vector(10 downto 0);

            reg2loc:        out bit;
            uncond_branch:  out bit;
            branch:         out bit;
            mem_read:       out bit;
            mem_to_reg:     out bit;
            alu_function:    out bit_vector(3 downto 0);
            mem_write:      out bit;
            alu_src:        out bit;
            reg_write:      out bit
        );
    end component;

    signal reg2loc, uncond_branch, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write: bit := '0';
    signal alu_function: bit_vector(3 downto 0) := "0000";

    type opcode_range_t is array (natural range <>) of bit_vector(10 downto 0);

    signal clk: bit := '0';
    signal rst: bit := '0';

    signal opcode: bit_vector(10 downto 0);

begin

    UC: control_unit port map(
        clk => clk,
        rst => rst,

        opcode => opcode,

        reg2loc => reg2loc,
        uncond_branch => uncond_branch,
        branch => branch,
        mem_read => mem_read,
        mem_to_reg => mem_to_reg,
        mem_write => mem_write,
        alu_function => alu_function,
        alu_src => alu_src,
        reg_write => reg_write
    );

    uc_control: process
        constant opcodes: opcode_range_t := (
            "10001011000", "11001011000", "10001010000", "10101010000",
            "10110010000", "11111000000", "10110100000"
        );

    begin
        -- wait for 50 ns;

        for i in opcodes'range loop
            opcode <= opcodes(i);
            wait for 50 ns;
        end loop;
    end process uc_control;


    clock_gen: process
    begin
        clk <= not clk;
        wait for 10 ns;
    end process clock_gen;

end architecture;