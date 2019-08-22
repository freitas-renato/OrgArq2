library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity legv8 is
    port(
        clk: in bit;
        rst: in bit
    );
end entity;

architecture estrutural of legv8 is
    component fluxo_de_dados is
        port(
            clock: in bit;
            reset: in bit;

            -- From UC
            reg2loc:        in bit;
            uncond_branch:  in bit;
            branch:         in bit;
            mem_wr:         in bit;
            mem_to_reg:     in bit;
            alu_function:   in bit_vector(3 downto 0);
            alu_src:        in bit;
            reg_write:      in bit;

            -- To UC
            opcode: out bit_vector(10 downto 0)
        );
    end component;

    component control_unit is
        port(
            clk:    in bit;
            rst:    in bit;

            -- From FD
            opcode: in bit_vector(10 downto 0);

            -- To FD
            reg2loc:        out bit;
            uncond_branch:  out bit;
            branch:         out bit;
            mem_wr:         out bit;
            mem_to_reg:     out bit;
            alu_function:   out bit_vector(3 downto 0);
            alu_src:        out bit;
            reg_write:      out bit
        );
    end component;

    signal opcode: bit_vector(10 downto 0);
    signal reg2loc: bit;
    signal uncond_branch: bit;
    signal branch: bit;
    signal mem_wr: bit;
    signal mem_to_reg: bit;
    signal alu_function: bit_vector(3 downto 0);
    signal alu_src: bit;
    signal reg_write: bit;

begin
    FD: fluxo_de_dados port map(
        clock =>            clk,
        reset =>            rst,

        opcode =>           opcode,
        reg2loc =>          reg2loc,
        uncond_branch =>    uncond_branch,
        branch  =>          branch,
        mem_wr =>           mem_wr,
        mem_to_reg =>       mem_to_reg,
        alu_function =>     alu_function,
        alu_src =>          alu_src,
        reg_write =>        reg_write
    );

    UC: control_unit port map(
        clk =>            clk,
        rst =>            rst,

        opcode =>           opcode,
        reg2loc =>          reg2loc,
        uncond_branch =>    uncond_branch,
        branch  =>          branch,
        mem_wr =>           mem_wr,
        mem_to_reg =>       mem_to_reg,
        alu_function =>     alu_function,
        alu_src =>          alu_src,
        reg_write =>        reg_write
    );

end architecture;