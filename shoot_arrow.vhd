library ieee;
use ieee.std_logic_1164.all;

entity shoot_arrow is
   port(
	clk50M : in std_logic;
	Key : in std_logic_vector(2 downto 0);
	VGA_R : out std_logic_vector(7 downto 0);
	VGA_G : out std_logic_vector(7 downto 0);
	VGA_B : out std_logic_vector(7 downto 0);
	VGA_CLK : out std_logic;
	VGA_SYNC_N  : out std_logic;
	VGA_BLANK_N  : out std_logic;
	VGA_VS  : out std_logic;
	VGA_HS  : out std_logic
	);
end shoot_arrow;

architecture rlt_shoot_arrow of shoot_arrow is
component div_clk2 is
   port(
	clk50M  : in std_logic;
	clk25M  : out std_logic
	);
end component;
signal clk25M : std_logic;

component key_debuce is 
   port(
	clk   : in std_logic;
	Key   : in std_logic_vector(2 downto 0);
	key_sig : out std_logic_vector(2 downto 0)
	);
end component;
signal key_sig :  std_logic_vector(2 downto 0);

component VGA_SYNC is
   port(
	clk      : in std_logic;
	VGA_HS      : out std_logic;
	VGA_VS      : out std_logic;
	addr_x       : out std_logic_vector(9 downto 0);
	addr_y       : out std_logic_vector(9 downto 0)
	);
end component;
signal VGA_HS_r      :  std_logic;
signal VGA_VS_r      :  std_logic;
signal addr_x        :  std_logic_vector(9 downto 0);
signal addr_y        :  std_logic_vector(9 downto 0);

component dis_vga is 
   port(
	clk    : in std_logic;
	key_sig : in std_logic_vector(2 downto 0);
	addr_x : in std_logic_vector(9 downto 0);
	addr_y : in std_logic_vector(9 downto 0);
	VGA_R  : out std_logic_vector(7 downto 0);
	VGA_G  : out std_logic_vector(7 downto 0);
	VGA_B  : out std_logic_vector(7 downto 0)
	);
end component;
begin

div_clk2_U : div_clk2
   port map(
	clk50M  => clk50M,
	clk25M  => clk25M
	);
	
key_debuce_U : key_debuce 
   port map(
	clk   => clk25M,
	Key   => Key,
	key_sig => key_sig
	);

VGA_SYNC_U : VGA_SYNC
   port map(
	clk         => clk25M,
	VGA_HS      => VGA_HS_r,
	VGA_VS      => VGA_VS_r,
	addr_x      => addr_x,
	addr_y      => addr_y
	);

dis_vga_U : dis_vga 
   port map(
	clk    => clk25M,
	key_sig => key_sig,
	addr_x      => addr_x,
	addr_y      => addr_y,
	VGA_R  => VGA_R,
	VGA_G  => VGA_G,
	VGA_B  => VGA_B
	);
	
VGA_SYNC_N <='0';
VGA_CLK <= not clk25M;	
VGA_BLANK_N <= VGA_VS_r and VGA_HS_r;
VGA_VS <=VGA_VS_r;
VGA_HS <=VGA_HS_r;	

		
	
end rlt_shoot_arrow;
