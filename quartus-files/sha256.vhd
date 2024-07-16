library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.Gates.all;


entity SHA256 is
    Port (clk,rst,start:in std_logic;i4:out std_logic;
           aso,bso,cso,dso,eso,fso,gso,hso,aco,bco,cco,dco,eco,fco,gco,hco,i0,i1,i2,i3,mewout1:out std_logic_vector(31 downto 0);
			  counts:out std_logic_vector(9 downto 0));
end entity;


architecture Behavioral of SHA256 is

component ME is
    Port ( clk:in std_logic;
	        counter : in  std_logic_vector(9 downto 0);  
	        Wj,Wj2,Wj7,Wj16,Wj15: in  STD_LOGIC_VECTOR(31 downto 0);
           Wout : out  STD_LOGIC_VECTOR(31 downto 0);
			  Waddr:out std_logic_vector(5 downto 0);
			  sel:out std_logic_vector(1 downto 0)
           );
end component;

component MC is
    Port ( clk:in std_logic;
	        counter : in  std_logic_vector(9 downto 0); 
	        ai,bi,ci,di,ei,fi,gi,hi,win: in  STD_LOGIC_VECTOR(31 downto 0);
           ao,bo,co,do,eo,fo,go,ho: out  STD_LOGIC_VECTOR(31 downto 0)
           );
end component;

component sbo2 is
    port(
        sbo2out0, sbo2out1, sbo2out2, sbo2out3: out std_logic_vector(31 downto 0);
        sbo2in0, sbo2in1, sbo2in2, sbo2in3, sbo2in4, sbo2in5, sbo2in6, sbo2in7: in std_logic_vector(31 downto 0);
        write_en, clk,rst: in std_logic
    );
end component sbo2;

component hram is
    port (
        w_write, w_read: in std_logic;
        w_in0,w_in1,w_in2,w_in3: in std_logic_vector(31 downto 0);
        w_A: in std_logic_vector(2 downto 0);
        wout00, wout01, wout02, wout03,wout04, wout05, wout06, wout07 : out std_logic_vector(31 downto 0);
		  sel:in std_logic_vector(1 downto 0);
        clk, rst: in std_logic
    );
end component hram;

component sbi1 is
    port(
        sbi1out1,sbi1out2,sbi1out3,sbi1out0: out std_logic_vector(31 downto 0);
        sbi1in1,sbi1in2,sbi1in3,sbi1in0: in std_logic_vector(31 downto 0);
        write_en, clk, rst: in std_logic;
		  sbi1_r: in std_logic_vector(1 downto 0)
    );
end component sbi1;

component wram is
    port (
        w_write: in std_logic;
        w_sel: in std_logic_vector(1 downto 0);
        w_in: in std_logic_vector(31 downto 0);
        w_A,w_A0,w_A1,w_A2,w_A3,w_r: in std_logic_vector(5 downto 0);
        wout0, wout1, wout2, wout3,woutr: out std_logic_vector(31 downto 0);
        clk, rst: in std_logic
    );
end component wram;

signal am,bm,cm,dm,em,fm,gm,hm,ao,bo,co,do,eo,fo,go,ho,Wj,Wj2,Wj7,Wj15,Wj16,wout1,wout2,
       wout3,wout0,sbo2out1,sbo2out2,sbo2out0,sbo2out3,hout6,hout5,hout7,hout0,hout1,hout2,hout3,hout4,mewout:std_logic_vector(31 downto 0);
signal Waddr,w_a0,w_a1,w_a2,w_a3,w_r,wradd:std_logic_vector(5 downto 0):= (others => '0');
signal sel,wj_sel,sbi1_r,h_sel:std_logic_vector(1 downto 0);
signal w_write,w_read,write_sbi1,write_sbo2,wr_hram,rd_hram,rst_hram,rstsbo2:std_logic;
signal mc_insel:std_logic:='0';
signal h_add:std_logic_vector(2 downto 0);
signal counter:std_logic_vector(9 downto 0);
signal index,index1,index2,index3,index4:integer:=0;
signal count:integer:=-1;
signal rem4:integer range 0 to 3;
begin

mc1:MC 
    Port map( clk=>clk,
	        counter=>counter,
	        ai=>am,bi=>bm,ci=>cm,di=>dm,ei=>em,fi=>fm,gi=>gm,hi=>hm,win=>mewout, 
           ao=>ao,bo=>bo,co=>co,do=>do,eo=>eo,fo=>fo,go=>go,ho=>ho);--mux for ai

me1:ME 
    Port map( clk=>clk,
	        counter=>counter,  
	        Wj=>Wj,Wj2=>Wj2,Wj7=>Wj7,Wj16=>Wj16,Wj15=>Wj15,
           Wout=>mewout,
			  Waddr=>Waddr,
			  sel=>sel
           );  --mux for wj
sbi11:sbi1 
    port map(
        sbi1out1=>Wj15,sbi1out2=>Wj7,sbi1out3=>Wj2,sbi1out0=>Wj16,
        sbi1in1=>wout1,sbi1in2=>wout2,sbi1in3=>wout3,sbi1in0=>wout0,
        write_en=>write_sbi1, clk=>clk, rst=>rst,
		  sbi1_r=>sbi1_r  
    );
	 
aco<=ao;
bco<=bo;
cco<=co;
dco<=do;
eco<=eo;fco<=fo;gco<=go;hco<=ho;
wram1:wram 
    port map(
        w_write=>w_write,  
        w_sel=>sel,
        w_in=>mewout,
        w_A=>Wradd,w_A0=>w_A0,w_A1=>w_A1,w_A2=>w_A2,w_A3=>w_A3,w_r=>w_r,
        wout0=>wout0, wout1=>wout1, wout2=>wout2, wout3=>wout3,woutr=>wj,
        clk=>clk, rst=>rst
    );

sbo21: sbo2 
    port map(
        sbo2out0=>sbo2out0, sbo2out1=>sbo2out1, sbo2out2=>sbo2out2, sbo2out3=>sbo2out3,
        sbo2in0=>ao, sbo2in1=>bo, sbo2in2=>co, sbo2in3=>do, sbo2in4=>eo, sbo2in5=>fo, sbo2in6=>go, sbo2in7=>ho,
        write_en=>write_sbo2, clk=>clk,rst=>rstsbo2
    );
	 
	 
hram1:hram 
    port map(
        w_write=>wr_hram, w_read=>rd_hram,
        w_in0=>sbo2out0,w_in1=>sbo2out1,w_in2=>sbo2out2,w_in3=>sbo2out3,
        w_A=>h_add,
        wout00=>hout0, wout01=>hout1, wout02=>hout2, wout03=>hout3,wout04=>hout4, wout05=>hout5, wout06=>hout6, wout07=>hout7,
		  sel=>h_sel,
        clk=>clk, rst=>rst_hram
    );
	 
	 

w_r<=std_logic_vector(to_unsigned(index, w_A0'length));
counts<=counter;
 process (mc_insel,ao,bo,co,do,eo,fo,go,ho,hout6,hout5,hout7,hout0,hout1,hout2,hout3,hout4)
 begin
			 
          case mc_insel is
                    when '0'=>
						  am<=hout0;bm<=hout1;cm<=hout2;dm<=hout3;em<=hout4;fm<=hout5;gm<=hout6;hm<=hout7;
                    when '1' =>
                    am<=ao;bm<=bo;cm<=co;dm<=do;em<=eo;fm<=fo;gm<=go;hm<=ho;
                    
                    when others =>
                        null;
          end case;
 end process;
 aso<=hout0;bso<=hout1;cso<=hout2;dso<=hout3;eso<=hout4;fso<=hout5;gso<=hout6;hso<=hout7;
 i0<="00000000000000000000000000"&w_a0;i1<="00000000000000000000000000"&w_a1;i2<="00000000000000000000000000"&w_a2;i3<="00000000000000000000000000"&w_a3;
counter<=std_logic_vector(to_unsigned(count,10));
mewout1<=mewout;i4<=w_write;
rem4<=abs(count-1) rem 4;
index<=((count-1)/4);
index1<=((count-1)/4)+1;
index2<=((count-2)/4)+1;
index3<=((count-3)/4)+1;
index4<=((count-4)/4)+1;
wradd<=std_logic_vector(to_unsigned(((count-3)/4),6));
clk1:process(clk,rst)
begin
if rst='1' then
count<=0;
elsif rising_edge(clk) then
count<=count+1;
end if;
end process;

control: process(rst,count, start, rem4)
begin 
    if (rst = '1') then
        rst_hram <= '1';
        rstsbo2 <= '1';
        w_write <= '0'; 
        write_sbi1 <= '1'; 
        write_sbo2 <= '0'; 
        wr_hram <= '0'; 
        rd_hram <= '1';
        wj_sel <="00"; 
        mc_insel <= '0';
        h_sel <= "00";
		  h_add <= std_logic_vector(to_unsigned(abs(count-1) rem 8 , 3));
       elsif (count < 5) then
            w_write <= '0'; 
            write_sbi1 <= '1'; 
            write_sbo2 <= '0'; 
            wr_hram <= '0'; 
            rd_hram <= '1';
            wj_sel <= std_logic_vector(to_unsigned(rem4, 2)); 
            mc_insel <= '0'; 
            rst_hram <= '0';
            h_sel <= std_logic_vector(to_unsigned(rem4, 2));
            rstsbo2 <= '0';
		      h_add <= std_logic_vector(to_unsigned(abs(count-1) rem 8 , 3));
        elsif (count < 67) then
            w_write <= '0'; 
            write_sbi1 <= '1'; 
            write_sbo2 <= '0'; 
            wr_hram <= '0'; 
            rd_hram <= '0';
            wj_sel <= std_logic_vector(to_unsigned(rem4, 2)); 
            mc_insel <= '1'; 
            rst_hram <= '0';
            h_sel <= std_logic_vector(to_unsigned(rem4, 2));
            rstsbo2 <= '0';
				h_add <= std_logic_vector(to_unsigned(abs(count-1) rem 8 , 3));
        elsif (count < 257) then
            w_write <= '1'; 
            write_sbi1 <= '1'; 
            write_sbo2 <= '0'; 
            wr_hram <= '0'; 
            rd_hram <= '0';
            h_sel <= std_logic_vector(to_unsigned(rem4, 2));
            wj_sel <= std_logic_vector(to_unsigned(rem4, 2)); 
            mc_insel <= '1'; 
            rst_hram <= '0';
            rstsbo2 <= '0';
				h_add <= std_logic_vector(to_unsigned(abs(count-1) rem 8 , 3));
        elsif (count < 261) then
            w_write <= '1'; 
            write_sbi1 <= '1'; 
            write_sbo2 <= '1'; 
            wr_hram <= '0'; 
            rd_hram <= '0';
            h_sel <= std_logic_vector(to_unsigned(rem4, 2));
            wj_sel <= std_logic_vector(to_unsigned(rem4, 2)); 
            mc_insel <= '1'; 
            rst_hram <= '0';
            rstsbo2 <= '0';
				h_add <= std_logic_vector(to_unsigned(abs(count-1) rem 8 , 3));
        elsif (count < 269) then
            w_write <= '0'; 
            write_sbi1 <= '0'; 
            write_sbo2 <= '0'; 
            wr_hram <= '1'; 
            rd_hram <= '0';
            h_sel <= "00";
            wj_sel <= std_logic_vector(to_unsigned(rem4, 2)); 
            mc_insel <= '1'; 
            rst_hram <= '0';
            rstsbo2 <= '0';
            h_add <= std_logic_vector(to_unsigned(abs(count-5) rem 8 , 3));
        elsif (start = '1') then
            rstsbo2 <= '1';
				wr_hram <= '0';
            h_sel <= "00";
            rd_hram <= '1';
				w_write <= '0'; 
            write_sbi1 <= '1'; 
            write_sbo2 <= '0'; 
            wr_hram <= '0'; 
            rd_hram <= '1';
            wj_sel <= std_logic_vector(to_unsigned(rem4, 2)); 
            mc_insel <= '1'; 
            rst_hram <= '0';
            h_sel <= std_logic_vector(to_unsigned(rem4, 2));
				h_add <= std_logic_vector(to_unsigned(abs(count-1) rem 8 , 3));
        else
            wr_hram <= '0';
            h_sel <= "00";
            rd_hram <= '1';
				w_write <= '0'; 
            write_sbi1 <= '1'; 
            write_sbo2 <= '0'; 
            wr_hram <= '0'; 
            rd_hram <= '1';
            wj_sel <= std_logic_vector(to_unsigned(rem4, 2)); 
            mc_insel <= '1'; 
            rst_hram <= '0';
            h_sel <= std_logic_vector(to_unsigned(rem4, 2));
            rstsbo2 <= '0';
				h_add <= std_logic_vector(to_unsigned(abs(count-1) rem 8 , 3));
        end if;  
end process;

 
 address:process(count,index1,rem4,index,index2,index3,index4)
 begin
 if(count>60) then
	     case rem4 is
            when 0 =>
                w_A0 <= std_logic_vector(to_unsigned(index1 - 2, w_A0'length));
            when 1 =>
                w_A0 <= std_logic_vector(to_unsigned(index1 - 7, w_A0'length));
            when 2 =>
                w_A0 <= std_logic_vector(to_unsigned(index1 - 15, w_A0'length));
            when 3 =>
                w_A0 <= std_logic_vector(to_unsigned(index1 - 16, w_A0'length));
				when others=>
				    w_A0 <="000000";
        end case;
		 else
		   w_A0 <= std_logic_vector(to_unsigned(index, w_A0'length));
		end if; 
		if(count>61) then
	     case rem4 is
            when 0 =>
                w_A1 <= std_logic_vector(to_unsigned(index2 - 16, w_A1'length));
            when 1 =>
                w_A1 <= std_logic_vector(to_unsigned(index2 - 2, w_A1'length));
            when 2 =>
                w_A1 <= std_logic_vector(to_unsigned(index2 - 7, w_A1'length));
            when 3 =>
                w_A1 <= std_logic_vector(to_unsigned(index2 - 15, w_A1'length));
				when others=>
				    w_A1 <="000000";
        end case;
		   else
		   w_A1 <= std_logic_vector(to_unsigned(index, w_A0'length));
		end if;
	  if(count>62) then
	     case rem4 is
            when 0 =>
                w_A2 <= std_logic_vector(to_unsigned(index3 - 15, w_A2'length));
            when 1 =>
                w_A2 <= std_logic_vector(to_unsigned(index3 - 16, w_A2'length));
            when 2 =>
                w_A2 <= std_logic_vector(to_unsigned(index3 - 2, w_A2'length));
            when 3 =>
                w_A2 <= std_logic_vector(to_unsigned(index3 - 7, w_A2'length));
				when others=>
				    w_A2 <="000000";
        end case;
		  else
		   w_A2 <= std_logic_vector(to_unsigned(index, w_A0'length));
		end if;
		if(count>63) then
	     case rem4 is
            when 0 =>
                w_A3 <= std_logic_vector(to_unsigned(index4 - 7, w_A3'length));
            when 1 =>
                w_A3 <= std_logic_vector(to_unsigned(index4 - 15, w_A3'length));
            when 2 =>
                w_A3 <= std_logic_vector(to_unsigned(index4 - 16, w_A3'length));
            when 3 =>
                w_A3 <= std_logic_vector(to_unsigned(index4 - 2, w_A3'length));
			   when others=>
				    w_A3 <="000000";
        end case;
		  else
		   w_A3 <= std_logic_vector(to_unsigned(index, w_A0'length));
		end if;
		case rem4 is
            when 0 =>
               sbi1_r  <= "00";
            when 1 =>
                sbi1_r  <= "01";
            when 2 =>
                sbi1_r  <= "10";
            when 3 =>
                sbi1_r  <= "11";
				when others=>
				    sbi1_r  <= "00";
        end case;
end process;
 
end Behavioral;