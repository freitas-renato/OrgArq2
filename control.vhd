library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_bit.all;

entity control_unit is 
    port(
        clk:    in bit;
        rst:    in bit;

        opcode: in bit_vector(10 downto 0);

        reg2loc:        out bit;
        uncondBranch:   out bit;
        branch:         out bit;
        mem_wr:         out bit;
        memToReg:       out bit;
        aluCtl:         out bit_vector(3 downto 0);
        aluSrc:         out bit;
        regWrite:       out bit
    );
end control_unit;

architecture control_arch of control_unit is
    component alu_control is
        port(
            opcode: in bit_vector(10 downto 0);
            alu_op: in bit_vector(1 downto 0);

            alu_function: out bit_vector(3 downto 0)
        );
    end component;

    signal alu_op: bit_vector(1 downto 0);

begin
    alu_ctr: alu_control port map(
        opcode => opcode,
        alu_op => alu_op,
        alu_function => aluCtl
    );

    decode: process (clk, opcode) is
    begin
        if rising_edge(clk) then
            case to_integer(unsigned(opcode)) is
                -- ADD, SUB, AND, ORR
                when to_integer(unsigned(bit_vector'("10001011000"))) | to_integer(unsigned(bit_vector'("11001011000"))) |
                     to_integer(unsigned(bit_vector'("10001010000"))) | to_integer(unsigned(bit_vector'("10101010000")))  =>
                    reg2loc         <= '0';
                    uncondBranch    <= '0';
                    branch          <= '0';
                    mem_wr          <= '0';
                    memToReg        <= '0';
                    alu_op          <= "10";
                    aluSrc          <= '0';
                    regWrite        <= '1';

                when to_integer(unsigned(bit_vector'("10010001000"))) | to_integer(unsigned(bit_vector'("10010001001"))) |    -- ADDI
                     to_integer(unsigned(bit_vector'("11010001000"))) | to_integer(unsigned(bit_vector'("11010001001"))) |    -- SUBI
                     to_integer(unsigned(bit_vector'("10010010000"))) | to_integer(unsigned(bit_vector'("10010010001"))) |    -- ANDI
                     to_integer(unsigned(bit_vector'("10110010000"))) | to_integer(unsigned(bit_vector'("10110010001")))   => -- ORRI
                    reg2loc         <= '0';
                    uncondBranch    <= '0';
                    branch          <= '0';
                    mem_wr          <= '0';
                    memToReg        <= '0';
                    alu_op          <= "10";
                    aluSrc          <= '1'; -- Imm
                    regWrite        <= '1';

                when to_integer(unsigned(bit_vector'("11111000010"))) => -- LDUR
                    reg2loc         <= '0'; -- (tanto faz?)
                    uncondBranch    <= '0';
                    branch          <= '0';
                    mem_wr          <= '0';
                    memToReg        <= '1';
                    alu_op          <= "00"; -- add operation
                    aluSrc          <= '1'; -- DT_address
                    regWrite        <= '1';

                when to_integer(unsigned(bit_vector'("11111000000"))) => -- STUR
                    reg2loc         <= '0'; -- (tanto faz?)
                    uncondBranch    <= '0';
                    branch          <= '0';
                    mem_wr          <= '1';
                    memToReg        <= '0';
                    alu_op          <= "00"; -- add operation
                    aluSrc          <= '1'; -- DT_address
                    regWrite        <= '1';

                when to_integer(unsigned(bit_vector'("10110100000"))) to to_integer(unsigned(bit_vector'("10110100111"))) => -- CBZs
                    reg2loc         <= '0';
                    uncondBranch    <= '0';
                    branch          <= '1';
                    mem_wr          <= '0';
                    memToReg        <= '0';
                    alu_op          <= "01"; -- enable zero flag
                    aluSrc          <= '1'; -- BR_address 
                    regWrite        <= '0';

                when others =>
                    reg2loc         <= '0';
                    uncondBranch    <= '0';
                    branch          <= '0';
                    mem_wr          <= '0';
                    memToReg        <= '0';
                    alu_op          <= "00";
                    aluSrc          <= '0';
                    regWrite        <= '0';
            end case;
        end if;
    end process decode;
end architecture;