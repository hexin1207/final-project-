library ieee;
use ieee.std_logic_1164.all;

entity key_debuce is 
   port(
	clk   : in std_logic;
	Key   : in std_logic_vector(2 downto 0);
	key_sig : out std_logic_vector(2 downto 0)
	);
end key_debuce;

architecture rlt_key_debuce of key_debuce is
signal key_v0 : std_logic_vector(15 downto 0) :=(others =>'1');
signal key_v1 : std_logic_vector(15 downto 0) :=(others =>'1');
signal key_v2 : std_logic_vector(15 downto 0) :=(others =>'1');
signal cnt    : integer range 0 to 12499 :=0;
signal clk1K  : std_logic :='0';
signal key_v_deb : std_logic_vector(2 downto 0) :="000";
begin

process(clk)
begin
  if rising_edge(clk) then
    if cnt =12499 then
	    cnt <= 0;
	 else
	    cnt <= cnt +1;
	 end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    if cnt =12499 then
	    clk1K <= not clk1K;
	 else
	    clk1K <= clk1K;
	 end if;
  end if;
end process;

process(clk1K)
begin
 if rising_edge(clk1K) then
     key_v0 <=key_v0(14 downto 0) & Key(0);
	 key_v1 <=key_v1(14 downto 0) & Key(1);
	 key_v2 <=key_v2(14 downto 0) & Key(2);
 end if;
end process;

process(clk1K)
begin
 if rising_edge(clk1K) then
    if key_v0 =x"8000" then
	   key_v_deb(0) <='1';
	 else
	   key_v_deb(0) <='0';
	 end if;
	 if key_v1 =x"8000" then
	   key_v_deb(1) <='1';
	 else
	   key_v_deb(1) <='0';
	 end if;
	 
	 if key_v2 =x"8000" then
	   key_v_deb(2) <='1';
	 else
	   key_v_deb(2) <='0';
	 end if;
 end if;
end process;

key_sig <=key_v_deb; 

end rlt_key_debuce;