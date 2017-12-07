library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity dis_vga is 
   port(
	clk    : in std_logic;
	key_sig : in std_logic_vector(2 downto 0);
	addr_x : in std_logic_vector(9 downto 0);
	addr_y : in std_logic_vector(9 downto 0);
	VGA_R  : out std_logic_vector(7 downto 0);
	VGA_G  : out std_logic_vector(7 downto 0);
	VGA_B  : out std_logic_vector(7 downto 0)
	);
end dis_vga;

architecture rlt_dis_vga of dis_vga is
constant char_g : std_logic_vector(0 to 127) :=x"00000000003448304038443800000000";----g
constant char_a : std_logic_vector(0 to 127) :=x"00000000003048384848340000000000";----a
constant char_m : std_logic_vector(0 to 127) :=x"00000000006854545454540000000000";----a
constant char_e : std_logic_vector(0 to 127) :=x"000000000038447C4044380000000000";----e

constant char_o : std_logic_vector(0 to 127) :=x"00000000003844444444380000000000";----o
constant char_v : std_logic_vector(0 to 127) :=x"00000000004444282810100000000000";----v
--constant char_e : std_logic_vector(0 to 127) :=x"000000000038447C4044380000000000";----e
constant char_r : std_logic_vector(0 to 127) :=x"00000000002C30202020200000000000";----r

constant char_0 : std_logic_vector(0 to 127) :=x"00003048484848484848300000000000";----0
constant char_1 : std_logic_vector(0 to 127) :=x"00001030101010101010100000000000";----1
constant char_2 : std_logic_vector(0 to 127) :=x"00003048480810202040780000000000";----2
constant char_3 : std_logic_vector(0 to 127) :=x"00003048480830084848300000000000";----3

signal dis_char_num : std_logic_vector(0 to 127) :=(others =>'0');
signal dis_char_code : std_logic_vector(0 to 127) :=(others =>'0');

signal R_sig   : std_logic_vector(1 downto 0) :="00";
signal S_sig   : std_logic_vector(1 downto 0) :="00";
signal M_sig   : std_logic_vector(1 downto 0) :="00";
signal Point_data : integer range 0 to 640 :=17;
signal max_cnt : integer range 0 to 60 :=2;
signal speed_cnt : integer range 0 to 60 :=0;
signal en_sig   : std_logic :='0';

signal addr_x_int : integer range 0 to 640;
signal addr_y_int : integer range 0 to 480;
signal over_sig   : std_logic :='0';

signal VGA_R_t    : std_logic_vector(7 downto 0) :=x"00";
type typ_y_dex is array(0 to 32) of integer range 0 to 480 ;
constant cicr_data_L : typ_y_dex :=(240,234,232,231,229,228,228,227,226,226,225,225,225,224,224,224,224,224,224,224,225,225,225,226,226,227,228,228,229,231,232,234,240);
constant cicr_data_H : typ_y_dex :=(240,246,248,249,251,252,252,253,254,254,255,255,255,256,256,256,256,256,256,256,255,255,255,254,254,253,252,252,251,249,248,246,240);
signal dif_dix  : integer range 0 to 16;
signal code_data : integer range 0 to 3 :=0;
signal num_data  : integer range 0 to 3 :=0;
signal VGA_B_t   : std_logic_vector(7 downto 0) :=x"00";
signal vga_char_t1 : std_logic :='0';
signal vga_char_t2 : std_logic :='0';
signal vag_char_t3 : std_logic :='0';
signal VGA_G_t   : std_logic_vector(7 downto 0) :=x"00";

signal vga_char_tt : std_logic ;
signal VGA_R_tt  : std_logic_vector(7 downto 0);

signal cnt_row_h1 : integer range 0 to 480 :=480;
signal cnt_row_l1 : integer range 0 to 480 :=450;
signal cnt_row_h2 : integer range 0 to 480 :=480;
signal cnt_row_l2 : integer range 0 to 480 :=450;
signal cnt_row_h3 : integer range 0 to 480 :=480;
signal cnt_row_l3 : integer range 0 to 480 :=450;
signal row_en_sig   : std_logic_vector(2 downto 0) :="000";

signal vga_row_dis1  : std_logic_vector(7 downto 0) :=x"00";
signal vga_row_dis2  : std_logic_vector(7 downto 0) :=x"00";
signal vga_row_dis3  : std_logic_vector(7 downto 0) :=x"00";

signal vga_row_dis   : std_logic_vector(7 downto 0) ;
signal delay_1s      : integer range 0 to 60 :=0;
begin

addr_x_int <=conv_integer(addr_x);
addr_y_int <=conv_integer(addr_y);

process(clk)
begin
  if rising_edge(clk) then
    R_sig <= R_sig(0) & key_sig(0);
	 S_sig <= S_sig(0) & key_sig(1);
	 M_sig <= M_sig(0) & key_sig(2);
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    if R_sig ="01" then
	    code_data <=0;
		 num_data <= 0;
    elsif S_sig ="01" and over_sig ='0' then
	    if Point_data >=304 and Point_data <= 336 then
		   code_data <=code_data +1;
		 else
		   code_data <= code_data;
		 end if;
		 num_data <= num_data +1;
	  else
	    code_data <= code_data;
		 num_data <= num_data;
	 end if;
  end if;
end process;





process(clk)
begin
  if rising_edge(clk) then
    if S_sig ="01" and over_sig ='0' and num_data =0 then
	    row_en_sig(0) <='1';
    elsif R_sig ="01"  or over_sig ='1' then
	    row_en_sig(0) <='0';
	 else
	    row_en_sig(0) <= row_en_sig(0) ;
	 end if;
	 
	 if S_sig ="01" and over_sig ='0' and num_data =1 then
	    row_en_sig(1) <='1';
    elsif R_sig ="01"  or over_sig ='1' then
	    row_en_sig(1) <='0';
	 else
	    row_en_sig(1) <= row_en_sig(1) ;
	 end if;
	 
	 if S_sig ="01" and over_sig ='0' and num_data =2 then
	    row_en_sig(2) <='1';
    elsif R_sig ="01" or over_sig ='1' then
	    row_en_sig(2) <='0';
	 else
	    row_en_sig(2) <= row_en_sig(2) ;
	 end if;
	 
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    if row_en_sig(0) ='1'   then
	    if addr_x_int =1 and  addr_y_int =1   then
		   if cnt_row_l1 <=240 then
		     cnt_row_l1 <= 240;
			  cnt_row_h1 <= 270;
		   else
		     cnt_row_h1 <= cnt_row_h1 -3;
			  cnt_row_l1 <= cnt_row_l1 -3;
		   end if;
		 end if;
	 else
	    cnt_row_h1 <= 480;
		 cnt_row_l1 <= 450;
	 end if;
  end if;
end process;


process(clk)
begin
  if rising_edge(clk) then
    if row_en_sig(2) ='1'   then
	    if addr_x_int =1 and  addr_y_int =1   then
		   if cnt_row_l3 <=240 then
		     cnt_row_l3 <= 240;
			  cnt_row_h3 <= 270;
		   else
		     cnt_row_h3 <= cnt_row_h3 -3;
			  cnt_row_l3 <= cnt_row_l3 -3;
		   end if;
		 end if;
	 else
	    cnt_row_h3 <= 480;
		 cnt_row_l3 <= 450;
	 end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    if row_en_sig(1) ='1'   then
	    if addr_x_int =1 and  addr_y_int =1   then
		   if cnt_row_l2 <=240 then
		     cnt_row_l2 <= 240;
			  cnt_row_h2 <= 270;
		   else
		     cnt_row_h2 <= cnt_row_h2 -3;
			  cnt_row_l2 <= cnt_row_l2 -3;
		   end if;
		 end if;
	 else
	    cnt_row_h2 <= 480;
		 cnt_row_l2 <= 450;
	 end if;
  end if;
end process;


process(clk)
begin
  if rising_edge(clk) then
    if addr_y_int <= cnt_row_h1 and addr_y_int >= cnt_row_h1 -25 then
	    if addr_x_int >=318 and addr_x_int <= 321 then
		    vga_row_dis1 <=x"aa";
		 else
		    vga_row_dis1 <= x"00";
		 end if;
	 elsif addr_y_int >= cnt_row_l1 and addr_y_int < cnt_row_h1 -25 then
	    if addr_x_int >=319 and addr_x_int <= 320 then
		    vga_row_dis1 <=x"ee";
		 else
		    vga_row_dis1 <= x"00";
		 end if;
	 else
	    vga_row_dis1 <= x"00";
	 end if;
  end if;
end process;


process(clk)
begin
  if rising_edge(clk) then
    if addr_y_int <= cnt_row_h2 and addr_y_int >= cnt_row_h2 -25 then
	    if addr_x_int >=318 and addr_x_int <= 321 then
		    vga_row_dis2 <=x"aa";
		 else
		    vga_row_dis2 <= x"00";
		 end if;
	 elsif addr_y_int >= cnt_row_l2 and addr_y_int < cnt_row_h2 -25 then
	    if addr_x_int >=319 and addr_x_int <= 320 then
		    vga_row_dis2 <=x"ee";
		 else
		    vga_row_dis2 <= x"00";
		 end if;
	 else
	    vga_row_dis2 <= x"00";
	 end if;
  end if;
end process;


process(clk)
begin
  if rising_edge(clk) then
    if addr_y_int <= cnt_row_h3 and addr_y_int >= cnt_row_h3 -25 then
	    if addr_x_int >=318 and addr_x_int <= 321 then
		    vga_row_dis3 <=x"aa";
		 else
		    vga_row_dis3 <= x"00";
		 end if;
	 elsif addr_y_int >= cnt_row_l3 and addr_y_int < cnt_row_h3 -25 then
	    if addr_x_int >=319 and addr_x_int <= 320 then
		    vga_row_dis3 <=x"ee";
		 else
		    vga_row_dis3 <= x"00";
		 end if;
	 else
	    vga_row_dis3 <= x"00";
	 end if;
  end if;
end process;


vga_row_dis <= vga_row_dis1 when row_en_sig ="001" else
					vga_row_dis1 or vga_row_dis2 when row_en_sig ="011" else
				   vga_row_dis3 or vga_row_dis1 or vga_row_dis2 when row_en_sig ="111" else
				   x"00";
               


process(clk)
begin
  if rising_edge(clk) then
    if R_sig ="01" then
	    delay_1s <= 0;
	 elsif cnt_row_l3 =240 then
	   if delay_1s =60 then
		   delay_1s <= 60;
		else
	      delay_1s <= delay_1s +1;
		end if;
	 end if;
  end if;
end process;
process(clk)
begin
  if rising_edge(clk) then
    if R_sig ="01" then
	   over_sig <='0';
	 elsif delay_1s =60 then
	   over_sig <='1';
	 end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    case max_cnt is
	 when 2 => if M_sig ="01" then
	              max_cnt <= 4;
					else
					  max_cnt <= 2;
					end if;
	 when 4 => if M_sig ="01" then
	              max_cnt <= 8;
					else
					  max_cnt <= 4;
					end if;
	 when 8 => if M_sig ="01" then
	              max_cnt <= 2;
					else
					  max_cnt <= 8;
					end if;				
	 when others => max_cnt <= 4;			
	 end case;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    if addr_x_int =1 and  addr_y_int =1 then
	    if speed_cnt >=max_cnt then
		    speed_cnt <=0;
			 en_sig <='1';
		 else
		    speed_cnt <= speed_cnt +1;
			 en_sig <='0';
		 end if;
	 else
	    speed_cnt <= speed_cnt;
		 en_sig <='0';
	 end if;
  end if;
end process;



process(clk)
begin
  if rising_edge(clk) then
    if R_sig ="01" or over_sig ='1' then
	    Point_data <= 17;
	 elsif en_sig ='1' then
	   if Point_data >=623 then
		   Point_data <= 17;
		else
		   Point_data <= Point_data +8;
		end if;
	 end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    if addr_x_int >= Point_data -16 and addr_x_int <= Point_data + 16 then
	    if addr_y_int >=cicr_data_L(addr_x_int +16 -Point_data) and addr_y_int <= cicr_data_H(addr_x_int +16 -Point_data) then
		    VGA_R_t <=x"f8";
		 else
		    VGA_R_t <=x"00";
		 end if;
	 else
	    VGA_R_t <=x"00";
	 end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
    if addr_x_int =320 or addr_y_int =240 then
	    VGA_B_t <= x"f0";
	 else
	    VGA_B_t <= x"00";
	 end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
     if addr_y_int >=210 and addr_y_int <=225 then
	    if addr_x_int >=300 and addr_x_int <=307 then
		    vga_char_t1 <= char_g((addr_y_int -210)*8 + (addr_x_int -300));
		 elsif addr_x_int >=310 and addr_x_int <=317 then
		    vga_char_t1 <= char_a((addr_y_int -210)*8 + (addr_x_int -310));
		 elsif addr_x_int >=322 and addr_x_int <=329 then
		    vga_char_t1 <= char_m((addr_y_int -210)*8 + (addr_x_int -322));
		 elsif addr_x_int >=330 and addr_x_int <=337 then
		    vga_char_t1 <= char_e((addr_y_int -210)*8 + (addr_x_int -330));
		 else
		    vga_char_t1 <='0';
		 end if;
	  else
	    vga_char_t1 <='0';
	  end if;
  end if;
end process;

process(clk)
begin
  if rising_edge(clk) then
     if addr_y_int >=210 and addr_y_int <=225 then
	    if addr_x_int >=350 and addr_x_int <=357 then
		    vga_char_t2 <= char_o((addr_y_int -210)*8 + (addr_x_int -350));
		 elsif addr_x_int >=360 and addr_x_int <=367 then
		    vga_char_t2 <= char_v((addr_y_int -210)*8 + (addr_x_int -360));
		 elsif addr_x_int >=370 and addr_x_int <=377 then
		    vga_char_t2 <= char_e((addr_y_int -210)*8 + (addr_x_int -370));
		 elsif addr_x_int >=380 and addr_x_int <=387 then
		    vga_char_t2 <= char_r((addr_y_int -210)*8 + (addr_x_int -380));
		 else
		    vga_char_t2 <='0';
		 end if;
	  else
	    vga_char_t2 <='0';
	  end if;
  end if;
end process;

dis_char_num <= char_0 when num_data =3 else
                char_1 when num_data =2 else
					 char_2 when num_data =1 else
					 char_3;
					 
dis_char_code <= char_0 when code_data =0 else
                char_1 when code_data =1 else
					 char_2 when code_data =2 else
					 char_3;
					 
process(clk)
begin
  if rising_edge(clk) then
     if addr_y_int >=210 and addr_y_int <=225 then
	    if addr_x_int >=280 and addr_x_int <=287 then
		    vag_char_t3 <= dis_char_num((addr_y_int -210)*8 + (addr_x_int -400));
		 elsif addr_x_int >=400 and addr_x_int <=407 then
		    vag_char_t3 <= dis_char_code((addr_y_int -210)*8 + (addr_x_int -400));	 
		 else
		    vag_char_t3 <='0';
		 end if;
	  else
	    vag_char_t3 <='0';
	  end if;
  end if;
end process;

vga_char_tt <= vga_char_t1 or vga_char_t2;
VGA_R_tt <=vag_char_t3 & vag_char_t3 & vag_char_t3 & vag_char_t3 & vag_char_t3 & "000";

VGA_G_t <= x"00" when over_sig ='0' else
           vga_char_tt & vga_char_tt & vga_char_tt & vga_char_tt & x"0";
			  
VGA_G <= VGA_G_t or vga_row_dis;

---VGA_B <= VGA_B_t or VGA_G_t or vga_row_dis;
VGA_B <= VGA_G_t or vga_row_dis;

VGA_R <= VGA_R_t or VGA_R_tt when over_sig ='0' else
         VGA_R_tt;


end rlt_dis_vga;