library ieee;
use ieee.std_logic_1164.all;

entity div_clk2 is
   port(
	clk50M  : in std_logic;
	clk25M  : out std_logic
	);
end div_clk2;

architecture rlt_div_clk2 of div_clk2 is
signal clk25M_r : std_logic :='0';
begin

process(clk50M)
begin
  if rising_edge(clk50M) then
    clk25M_r <= not clk25M_r;
  end if;
end process;

clk25M <= clk25M_r;

end rlt_div_clk2;
