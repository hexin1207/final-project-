-------------640X480
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity VGA_SYNC is
   port(
	clk      : in std_logic;
	VGA_HS      : out std_logic;
	VGA_VS      : out std_logic;
	addr_x       : out std_logic_vector(9 downto 0);
	addr_y       : out std_logic_vector(9 downto 0)
	);
end VGA_SYNC;

architecture rlt_VGA_SYNC of VGA_SYNC is
signal cnt_H   : integer range 0 to 799 :=0;
signal cnt_V   : integer range 0 to 523 :=0;
begin
process(clk)
begin
   if rising_edge(clk) then
	   if cnt_H =799 then
		   cnt_H <= 0;
		else
		   cnt_H <= cnt_H +1;
		end if;
	end if;
end process;

process(clk)
begin
   if rising_edge(clk) then
	   if cnt_H =799 then
		  if cnt_V =523 then
		    cnt_V <= 0;
		  else
		    cnt_V <= cnt_V +1;
		  end if;
		end if;
	end if;
end process;

VGA_HS <= '0' when cnt_H < 96 else
             '1';
VGA_VS <= '0' when cnt_V < 2 else
             '1';
				 

addr_x <= conv_std_logic_vector((cnt_H -143),10) when cnt_H >=144 and cnt_H <= 783 else
         conv_std_logic_vector(0,10);
			
addr_y <= conv_std_logic_vector((cnt_V -33),10) when cnt_V >=34 and cnt_V <= 513 else
         conv_std_logic_vector(0,10);

end rlt_VGA_SYNC;