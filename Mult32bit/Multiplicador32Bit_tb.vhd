library ieee;
use ieee.std_logic_1164.all;

entity mult32_tb is
end mult32_tb;

architecture mult32_tb of mult32_tb is
	signal sclk, sstart, sdone: std_logic;
	signal res: std_logic_vector(63 downto 0);
	signal mtplcnd, mtplcdr: std_logic_vector(31 downto 0);
begin
	vector: entity work.mult32
	port map (
		multiplicando => mtplcnd,
		multiplicador => mtplcdr,
		clk => sclk,
		start => sstart,
		produto => res,
		done => sdone
	);

	process
	begin
		wait;
	end process;
end mult32_tb;
