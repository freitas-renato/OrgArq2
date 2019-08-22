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
            uncondBranch:   in bit;
            branch:         in bit;
            mem_wr:         in bit;
            memToReg:       in bit;
            aluCtl:         in bit_vector(3 downto 0);
            aluSrc:         in bit;
            regWrite:       in bit;

            -- To UC
            instruction31to21: out bit_vector(10 downto 0)
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
            uncondBranch:   out bit;
            branch:         out bit;
            mem_wr:         out bit;
            memToReg:       out bit;
            aluCtl:         out bit_vector(3 downto 0);
            aluSrc:         out bit;
            regWrite:       out bit
        );
    end component;

    signal opcode: bit_vector(10 downto 0);
    signal reg2loc: bit;
    signal uncondBranch: bit;
    signal branch: bit;
    signal mem_wr: bit;
    signal memToReg: bit;
    signal aluCtl: bit_vector(3 downto 0);
    signal aluSrc: bit;
    signal regWrite: bit;

begin
    FD: fluxo_de_dados port map(
        clock =>            clk,
        reset =>            rst,

        reg2loc =>          reg2loc,
        uncondBranch =>     uncondBranch,
        branch  =>          branch,
        mem_wr =>           mem_wr,
        memToReg =>         memToReg,
        aluCtl =>           aluCtl,
        aluSrc =>           aluSrc,
        regWrite =>         regWrite,
        instruction31to21 => opcode
    );

    UC: control_unit port map(
        clk =>              clk,
        rst =>              rst,

        opcode =>           opcode,
        reg2loc =>          reg2loc,
        uncondBranch =>     uncondBranch,
        branch  =>          branch,
        mem_wr =>           mem_wr,
        memToReg =>         memToReg,
        aluCtl =>           aluCtl,
        aluSrc =>           aluSrc,
        regWrite =>         regWrite
    );

end architecture;