-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Tue Sep 10 21:18:16 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY pipeline IS 
	PORT
	(
		clock :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC
	);
END pipeline;

ARCHITECTURE bdf_type OF pipeline IS 

COMPONENT control
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 opcode : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		 reg2loc : OUT STD_LOGIC;
		 branch : OUT STD_LOGIC;
		 mem_w : OUT STD_LOGIC;
		 mem_r : OUT STD_LOGIC;
		 memToReg : OUT STD_LOGIC;
		 aluSrc : OUT STD_LOGIC;
		 regWrite : OUT STD_LOGIC;
		 aluCtl : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dataflow
	PORT(Reg2Loc : IN STD_LOGIC;
		 branch : IN STD_LOGIC;
		 memToReg : IN STD_LOGIC;
		 aluSrc : IN STD_LOGIC;
		 regWrite : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 mem_w : IN STD_LOGIC;
		 mem_r : IN STD_LOGIC;
		 aluCtl : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 instruction31to21 : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 



b2v_inst : control
PORT MAP(clk => clock,
		 rst => reset,
		 opcode => SYNTHESIZED_WIRE_0,
		 reg2loc => SYNTHESIZED_WIRE_1,
		 branch => SYNTHESIZED_WIRE_2,
		 mem_w => SYNTHESIZED_WIRE_6,
		 mem_r => SYNTHESIZED_WIRE_7,
		 memToReg => SYNTHESIZED_WIRE_3,
		 aluSrc => SYNTHESIZED_WIRE_4,
		 regWrite => SYNTHESIZED_WIRE_5,
		 aluCtl => SYNTHESIZED_WIRE_8);


b2v_inst1 : dataflow
PORT MAP(Reg2Loc => SYNTHESIZED_WIRE_1,
		 branch => SYNTHESIZED_WIRE_2,
		 memToReg => SYNTHESIZED_WIRE_3,
		 aluSrc => SYNTHESIZED_WIRE_4,
		 regWrite => SYNTHESIZED_WIRE_5,
		 reset => reset,
		 clock => clock,
		 mem_w => SYNTHESIZED_WIRE_6,
		 mem_r => SYNTHESIZED_WIRE_7,
		 aluCtl => SYNTHESIZED_WIRE_8,
		 instruction31to21 => SYNTHESIZED_WIRE_0);


END bdf_type;