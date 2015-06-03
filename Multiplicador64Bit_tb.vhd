library ieee;
use ieee.std_logic_1164.all;

entity mult64_tb is
end mult64_tb;

architecture mult64_tb of mult64_tb is
	signal sclk, sstart, sdone: std_logic;
	signal mtplcnd, res: std_logic_vector(63 downto 0);
	signal mtplcdr: std_logic_vector(31 downto 0);
begin
	vector: entity work.mult64
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
end mult64_tb;
