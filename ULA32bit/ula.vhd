-----------------------------------------------------------------------
-----------------------------DESLOCADOR--------------------------------
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity deslocador is
	port (
		a: in std_logic_vector(31 downto 0);
		desl: in std_logic; --desloca
		lado: in std_logic; --0 divide 1 multiplica
		c: out std_logic_vector(31 downto 0);
		cout: out std_logic
	);
end deslocador;

architecture deslocador of deslocador is
begin
	c <= a(31 downto 0) when desl = '0' else
		'0' & a(31 downto 1) when lado = '0' else
		a(30 downto 0) & '0';
	cout <= a(30) when lado = '1' and desl = '1' else '0';
end deslocador;

-----------------------------------------------------------------------
--------------------------------MUX A----------------------------------
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Mux8x1A is
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		x: in std_logic;
		y: in std_logic;
		z: in std_logic;
		c: out std_logic_vector(31 downto 0);
		cout: out std_logic
	);
end Mux8x1A;

architecture Mux8x1A of Mux8x1A is
	component deslocador
	port (
		a: in std_logic_vector(31 downto 0);
		desl: in std_logic; --desloca
		lado: in std_logic; --0 divide 1 multiplica
		c: out std_logic_vector(31 downto 0);
		cout: out std_logic
	);
	end component;

	signal temp: std_logic_vector (31 downto 0);
	signal tdesl, tz: std_logic;
begin
	--seleciona o valor de saída baseado na escolha de entrada XYZ
	--as primeiras condições são para operações em lógica booleana
	--receberá o valor de A caso seja feita alguma operação algébrica
	--ou deslocamento de bits
	temp <= a and b when x = '0' and y = '1' and z = '0' else
		a nor b when x = '0' and y = '1' and z = '1' else
		a or b when x = '1' and y = '0' and z = '0' else a;
	--só irá efetuar deslocamento de bits caso xyz = 101 ou 110
	tdesl <= '1' when x = '1' and ( ( y = '0' and z = '1') or ( y = '1' and z = '0' ) ) else '0';
	--tz armazena o lado para qual será efetuado o deslocamento
	tz <= z;
	desloc: deslocador port map (temp, tdesl, tz, c, cout);
end Mux8x1A;

-----------------------------------------------------------------------
--------------------------------MUX B----------------------------------
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Mux8x1B is
	port (
		a: in std_logic_vector(31 downto 0);
		x: in std_logic;
		y: in std_logic;
		z: in std_logic;
		c: out std_logic_vector(31 downto 0)
	);
end Mux8x1B;

architecture Mux8x1B of Mux8x1B is
begin
	c <= "00000000000000000000000000000000" when (x = '1' or y = '1') else
		a when z = '0' else not a;
end Mux8x1B;

-----------------------------------------------------------------------
--------------------------------MUX C----------------------------------
---------------------------comparador----------------------------------
--Identifica se está fazendo subtração para CIN p/ conversão em complemento de 2

library ieee;
use ieee.std_logic_1164.all;

entity Mux8x1C is
	port (
		x: in std_logic;
		y: in std_logic;
		z: in std_logic;
		c: out std_logic
	);
end Mux8x1C;

architecture Mux8x1C of Mux8x1C is
begin
	c <= '1' when (x = '0' and y = '0' and z = '1') else '0';-- or
--		(x = '1' and y = '1' and z = '0') else '0';
		
end Mux8x1C;

-----------------------------------------------------------------------
---------------------------COMPONENTE LÓGICO---------------------------
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity CompLog is
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		x, y, z: in std_logic;
		ia: out std_logic_vector(31 downto 0);
		ib: out std_logic_vector(31 downto 0);
		Cin: out std_logic; --p/ conversão em complemento de 2
		Cout: out std_logic --p/ identificar overflow na multiplicação
	);
end CompLog;

architecture CompLog of CompLog is
	component Mux8x1A
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		x: in std_logic;
		y: in std_logic;
		z: in std_logic;
		c: out std_logic_vector(31 downto 0);
		cout: out std_logic
	);
	end component;

	component Mux8x1B
	port (
		a: in std_logic_vector(31 downto 0);
		x: in std_logic;
		y: in std_logic;
		z: in std_logic;
		c: out std_logic_vector(31 downto 0)
	);
	end component;

	component Mux8x1C
	port (
		x: in std_logic;
		y: in std_logic;
		z: in std_logic;
		c: out std_logic
	);
	end component;
begin
	mux8x1a0: Mux8x1A port map (a, b, x, y, z, ia, Cout);
--	ia <= "01001001";
	mux8x1b0: Mux8x1B port map (b, x, y, z, ib);
	mux8x1c0: Mux8x1C port map (x, y, z, Cin);
end CompLog;

-----------------------------------------------------------------------
--------------------------SOMADOR 1 BIT--------------------------------
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity somador1bit is
	port (
		a: in std_logic;
		b: in std_logic;
		cin: in std_logic;
		s: out std_logic;
		cout: out std_logic
	);
end somador1bit;

architecture somador1bit of somador1bit is
begin
	cout <= (cin and a) or (cin and b) or (a and b);
	s <= (not cin and not a and b) or (not cin and a and not b)
		or (cin and not a and not b) or (cin and a and b);
end somador1bit;


-----------------------------------------------------------------------
--------------------------SOMADOR 16 BITS-------------------------------
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity somador16bits is
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(31 downto 0);
		cout: out std_logic
	);
end somador16bits;

architecture somador16bits of somador16bits is
	component somador1bit
	port (
		a, b, cin: in std_logic;
		s, cout: out std_logic
	);
	end component;

	signal ta, tb, ts: std_logic_vector(31 downto 0);
	signal c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16,
	c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31: std_logic;
begin
	ta <= a;
	tb <= b;
	s8b0: somador1bit port map (a(0), b(0), cin, ts(0), c0);
	s8v1: somador1bit port map (a(1), b(1), c0, ts(1), c1);
	s8v2: somador1bit port map (a(2), b(2), c1, ts(2), c2);
	s8v3: somador1bit port map (a(3), b(3), c2, ts(3), c3);
	s8v4: somador1bit port map (a(4), b(4), c3, ts(4), c4);
	s8v5: somador1bit port map (a(5), b(5), c4, ts(5), c5);
	s8v6: somador1bit port map (a(6), b(6), c5, ts(6), c6);
	s8v7: somador1bit port map (a(7), b(7), c6, ts(7), c7);
	s8b8: somador1bit port map (a(8), b(8), c7, ts(8), c8);
	s8v9: somador1bit port map (a(9), b(9), c8, ts(9), c9);
	s8v10: somador1bit port map (a(10), b(10), c9, ts(10), c10);
	s8v11: somador1bit port map (a(11), b(11), c10, ts(11), c11);
	s8v12: somador1bit port map (a(12), b(12), c11, ts(12), c12);
	s8v13: somador1bit port map (a(13), b(13), c12, ts(13), c13);
	s8v14: somador1bit port map (a(14), b(14), c13, ts(14), c14);
	s8v15: somador1bit port map (a(15), b(15), c14, ts(15), c15);
	s8v16: somador1bit port map (a(16), b(16), c15, ts(16), c16);
	s8v17: somador1bit port map (a(17), b(17), c16, ts(17), c17);
	s8v18: somador1bit port map (a(18), b(18), c17, ts(18), c18);
	s8v19: somador1bit port map (a(19), b(19), c18, ts(19), c19);
	s8v20: somador1bit port map (a(20), b(20), c19, ts(20), c20);
	s8v21: somador1bit port map (a(21), b(21), c20, ts(21), c21);
	s8v22: somador1bit port map (a(22), b(22), c21, ts(22), c22);
	s8v23: somador1bit port map (a(23), b(23), c22, ts(23), c23);
	s8v24: somador1bit port map (a(24), b(24), c23, ts(24), c24);
	s8v25: somador1bit port map (a(25), b(25), c24, ts(25), c25);
	s8v26: somador1bit port map (a(26), b(26), c25, ts(26), c26);
	s8v27: somador1bit port map (a(27), b(27), c26, ts(27), c27);
	s8v28: somador1bit port map (a(28), b(28), c27, ts(28), c28);
	s8v29: somador1bit port map (a(29), b(29), c28, ts(29), c29);
	s8v30: somador1bit port map (a(30), b(30), c29, ts(30), c30);
	s8v31: somador1bit port map (a(31), b(31), c30, ts(31), c31);
	--verifica overflow e underflow
	cout <= (not a(31) and not b(31) and ts(31)) or (a(31) and b(31) and not ts(31));
	s <= ts;
end somador16bits;


-----------------------------------------------------------------------
-----------------------------ULA-PO------------------------------------
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ula_po is
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		x, y, z: in std_logic;
		s: out std_logic_vector(31 downto 0);
		couterro: out std_logic
	);
end ula_po;

architecture ula_po of ula_po is
	component CompLog
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		x, y, z: in std_logic;
		ia: out std_logic_vector (31 downto 0);
		ib: out std_logic_vector(31 downto 0);
		Cin: out std_logic;
		Cout: out std_logic
	);
	end component;

	component somador16bits
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(31 downto 0);
		cout: out std_logic
	);
	end component;

	signal ia, ib: std_logic_vector(31 downto 0);
	signal cin, cout, cout2: std_logic;
begin
	complog0: CompLog port map (a, b, x, y, z, ia, ib, cin, cout);
	somador8b0: somador16bits port map (ia, ib, cin, s, cout2);
	couterro <= cout or cout2;
end ula_po;

-----------------------------------------------------------------------
-----------------------------ULA-PC------------------------------------
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity ula_pc IS
port ( clk, do_op : in std_logic;
		done, state: out std_logic
);
end ula_pc;

architecture ula_pc of ula_pc is
	constant STDOINGOP: std_logic := '0';
	constant STOPDONE: std_logic := '1';
	signal st: std_logic;
begin
	--espera um ciclo de clock para ter certeza que as operações
	--se estabilizaram
	PROCESS (clk)
	BEGIN
		if (clk'event and clk = '1') then
			case st is
				when STOPDONE =>
					if (do_op = '1') then
						st <= STDOINGOP;
					end if;
				when others =>
					st <= STOPDONE;
			end case;
		end if;
	end process;

	done <= '1' when st = STOPDONE else '0';
	state <= st;
end ula_pc;

-----------------------------------------------------------------------
-------------------------------ULA-------------------------------------
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ula is
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		x, y, z, clk, do_op: in std_logic;
		s: out std_logic_vector(31 downto 0);
		couterro, done, state: out std_logic
	);
end ula;

architecture ula of ula is
	component ula_po
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		x, y, z: in std_logic;
		s: out std_logic_vector(31 downto 0);
		couterro: out std_logic
	);
	end component;

	component ula_pc
	port (
		clk, do_op : in std_logic;
		done, state: out std_logic
	);
	end component;

begin
	ulapo: ula_po port map (a, b, x, y, z, s, couterro);
	ulapc: ula_pc port map (clk, do_op, done, state);
end ula;
