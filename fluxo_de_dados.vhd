library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use std.textio.all;

entity fluxo_de_dados is 
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
end fluxo_de_dados;

architecture fluxo of fluxo_de_dados is

    signal PC, SL2_Add1, Add1Out : bit_vector(63 downto 0); 
    signal Reg_Alu, AluOut : bit_vector(63 downto 0);
    signal ZeroAlu : bit;
    signal sinal4bits: bit_vector(63 downto 0) := (2 => '1', others => '0');
    signal Add2Out : bit_vector(63 downto 0);
    signal Mux1Out : bit_vector(63 downto 0);
    signal SelecaoMux1: bit := '0';
    signal Reg_Mux2, Mux2Out : bit_vector(63 downto 0);
    signal DMemOut : bit_vector(63 downto 0);
    signal Mux3Out : bit_vector(63 downto 0);
    signal IMemOut : bit_vector(31 downto 0);
    signal SEOut : bit_vector(63 downto 0);
    signal mux4out : bit_vector(4 downto 0);
    
    component signExtend is
        -- Size of output is expected to be greater than input
        generic(
            ws_in:  natural := 32; -- input word size
            ws_out: natural := 64  -- output word size
        );
        port(
            i: in  bit_vector(ws_in-1  downto 0); -- input
            o: out bit_vector(ws_out-1 downto 0)  -- output
        );
    end component;

    component shiftleft2 is
        generic(
            ws: natural := 64
        ); -- word size
        port(
            i: in  bit_vector(ws-1 downto 0); -- input
            o: out bit_vector(ws-1 downto 0)  -- output
        );
    end component;

    component rom is
      generic (
         addressSize : natural := 64;
         wordSize    : natural := 32;
         mifFileName : string  := "rom.dat"
      );
      port (
         addr : in  bit_vector(addressSize-1 downto 0);
         data : out bit_vector(wordSize-1 downto 0)
      );
    end component;

    component reg is
        generic(
            wordSize: natural := 4
        );
        port(
            clock: in bit; --! entrada de clock
            reset: in bit; --! clear assíncrono
            load:  in bit; --! write enable (carga paralela)
            d:     in bit_vector(wordSize-1 downto 0); --! entrada
            q:     out bit_vector(wordSize-1 downto 0) --! saída
        );
    end component;

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

    component mux2to1 is
        generic(ws: natural := 4); -- word size
        port(
            s:    in  bit; -- selection: 0=a, 1=b
            a, b: in  bit_vector(ws-1 downto 0); -- inputs
            o:    out bit_vector(ws-1 downto 0)  -- output
        );
    end component;

    component alu is
        port (
            A, B : in  bit_vector(63 downto 0); -- inputs
            F    : out bit_vector(63 downto 0); -- output
            S    : in  bit_vector (3 downto 0); -- op selection
            Z    : out bit -- zero flag
        );
    end component;

    component registerFile is
        port (
            Read1:      in bit_vector(4 downto 0);
            Read2:      in bit_vector(4 downto 0);
            WriteReg:   in bit_vector(4 downto 0); -- reg address
            WriteData:  in bit_vector(63 downto 0); 
            RegWrite:   in bit; --sinais de controle
            clock:      in bit;
            DataOut1:   out bit_vector(63 downto 0);
            DataOut2:   out bit_vector(63 downto 0)
        );
    end component;
    
    
begin

    -- sinal4bits <= "0000000000000000000000000000000000000000000000000000000000000100";

    SelecaoMux1 <= uncondBranch or (branch and ZeroAlu);

    instruction31to21 <= IMemOut(31 downto 21);
    
    -- ALUs e Somadores
    add1 : alu port map(A => PC, B => SL2_Add1, F => Add1Out, S => "0010", Z => open);
    alu1 : alu port map(A => Reg_Alu, B => Mux2Out, F => AluOut, S => aluCtl, Z => ZeroAlu);
    add2 : alu port map(A => PC, B => sinal4bits, F => Add2Out, S => "0010", Z => open);
    
    -- MUX
    mux1 : mux2to1 generic map(64) port map(s => SelecaoMux1, a => Add2Out, b => Add1Out, o => Mux1Out);
    mux2 : mux2to1 generic map(64) port map(s => aluSrc, a => Reg_Mux2, b => SEOut, o => Mux2Out);
    mux3 : mux2to1 generic map(64) port map(s => memToReg, a => DMemOut, b => AluOut, o => Mux3Out);
    mux4 : mux2to1 generic map(5) port map(s => reg2loc, a => IMemOut(20 downto 16), b => IMemOut(4 downto 0), o => Mux4Out);
    
    -- Registradores
    programCounter : reg generic map(64) port map(clock => clock, reset => '0', load => '1', d => Mux1Out, q => PC);
    regFile : registerFile port map(Read1 => IMemOut(9 downto 5), Read2 => Mux4Out, WriteReg => IMemOut(4 downto 0), WriteData => Mux3Out, RegWrite => regWrite, clock => clock, DataOut1 => Reg_Alu, DataOut2 => Reg_Mux2); -- criar banco de regs
    
    SE: signExtend port map(i => IMemOut, o => SEOut);
    SL2 : shiftleft2 port map(i => SEOut, o => SL2_Add1);
    
    -- Memorias
    IMem : rom port map(addr => PC, data => IMemOut);
    DMem: ram generic map (addressSize => 64, wordSize => 64) port map(ck => clock, wr => mem_wr, addr => AluOut, data_i => Reg_Mux2, data_o => DMemOut);
    
end fluxo; 
