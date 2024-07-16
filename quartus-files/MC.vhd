library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
library work;
use work.Gates.all;

-- Entity for 32-bit Adder
entity MC is
    Port ( clk:in std_logic;
	        counter : in  std_logic_vector(9 downto 0); 
	        ai,bi,ci,di,ei,fi,gi,hi,win: in  STD_LOGIC_VECTOR(31 downto 0);
           ao,bo,co,do,eo,fo,go,ho : out  STD_LOGIC_VECTOR(31 downto 0)
           );
end entity;


architecture Behavioral of MC is
type regp is array (0 to 7 ) of std_logic_vector(31 downto 0);
signal l11,l12,l13,l21,l22,l41,l42,l31,l32,EP0,EP1,a1,a2,a3,e1,e2,e3,ch,maj,suml1,suml2,suml3,suml4,suml5,suml6,suml7,k:STD_LOGIC_VECTOR(31 downto 0);
signal l1,l2,l3,l4:regp:= (others => (others => '0'));
signal c1,c2,c3,c4,c5,c6,c7:std_logic;
signal rema,r1,r2,r3,r4,j,coun:integer;


begin
coun<=to_integer(unsigned(counter));
rema<=coun rem 4;
j<=(coun-1)/4;
a1<=ai(1 downto 0) & ai(31 downto 2);
a2<=ai(12 downto 0) & ai(31 downto 13);
a3<=ai(21 downto 0) & ai(31 downto 22);
EP0<=((a1 xor a2) xor a3);
e1<=ei(5 downto 0) & ei(31 downto 6);
e2<=ei(10 downto 0) & ei(31 downto 11);
e3<=ei(24 downto 0) & ei(31 downto 25);
EP1<=((e1 xor e2) xor e3);
ch<=(ei and fi) xor ((not ei) and gi);
maj<=(ai and bi) xor (bi and ci) xor (ai and ci);



cons:SHA256_Constants 
    port map(
        index=>j,
        round_constant=>k
    );

adderl11:Adder32 
    Port map ( A =>EP0,
           B =>Maj,
           Sum =>suml1,
           CarryOut=>c1);
			  
adderl2:Adder32 
    Port map ( A =>EP1,
           B =>ch,
           Sum =>suml2,
           CarryOut=>c2);
adderl3:Adder32 
    Port map ( A =>k,
           B =>hi,
           Sum =>suml3,
           CarryOut=>c3);

		
		
adderl4:Adder32 
    Port map ( A =>l13,
           B =>l12,
           Sum =>suml4,
           CarryOut=>c4);		  

adderl5:Adder32 
    Port map ( A =>win,
           B =>l22,
           Sum =>suml5,
           CarryOut=>c5);	
			  
adderl6:Adder32 
    Port map ( A =>l32,
           B =>l3(3),
           Sum =>suml6,
           CarryOut=>c6);

adderl7:Adder32 
    Port map ( A =>l32,
           B =>l31,
           Sum =>suml7,
           CarryOut=>c7);
			  
ao<=l41;bo<=l4(0);co<=l4(1);do<=l4(2);eo<=l42;fo<=l4(4);go<=l4(5);ho<=l4(6);


 process (ai,bi,ci,di,ei,fi,gi,hi,clk)
 begin
 if rising_edge(clk) then
  l42<=suml6;
  l41<=suml7;
  l4<=l3;
  r4<=r3;
 
  l32<=suml5;
  l31<=l21;
  l3<=l2;
  r3<=r2;
 
  l21<=l11;
  l22<=suml4;
  l2<=l1; 
  r2<=r1;
  
  l11<=suml1;
  l12<=suml2;
  l13<=suml3;
  l1(0) <= ai;
  l1(1) <= bi;
  l1(2) <= ci;
  l1(3) <= di;
  l1(4) <= ei;
  l1(5) <= fi;
  l1(6) <= gi;
  l1(7) <= hi;
  r1<=rema;
  end if;    
 end process;
end Behavioral;