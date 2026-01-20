library IEEE;
use IEEE.std_logic_1164.all;

entity unidadDeControl is
	port( 
		clk		  : in  std_logic;
		rst       : in  std_logic;
		control	  : out std_logic_vector(17 downto 0);
		estado    : in std_logic_vector(11 downto 0)		
	);
end unidadDeControl;

architecture unidadDeControlArch of unidadDeControl is

  -- señales de control
  alias PCWr            : std_logic is control(0);
  alias AddrSrc         : std_logic is control(1);
  alias MemWr           : std_logic is control(2); 
  alias OldPCwr         : std_logic is control(3);
  alias IrWr            : std_logic is control(4);
  alias BRWr            : std_logic is control(5);
  alias Awr             : std_logic is control(6);
  alias Bwr             : std_logic is control(7);
  alias ALUsrcA         : std_logic_vector(1 downto 0) is control(9 downto 8);  
  alias ALUsrcB         : std_logic_vector(1 downto 0) is control(11 downto 10);
  alias ALUop           : std_logic_vector(1 downto 0) is control(13 downto 12);
  alias ALUoutWr        : std_logic is control(14);
  alias MDRwr           : std_logic is control(15);
  alias ResSrc          : std_logic_vector(1 downto 0) is control(17 downto 16);
  
  -- señales de estado
  alias Zero       : std_logic is estado(0);  
  alias op         : std_logic_vector(6 downto 0) is estado(7 downto 1);
  alias funct7_5   : std_logic is estado(8);
  alias funct3     : std_logic_vector(2 downto 0) is estado(11 downto 9);

  
  TYPE states IS (S0, S0bis, S1, S2, S3, S3bis, S4, S5, S6, S7, S8, S9, S10);   
  SIGNAL currentState, nextState: states;

begin

  stateGen:
  PROCESS (currentState, op , zero, funct3)
  BEGIN

    nextState <= currentState;
    control <= (OTHERS=>'0');
		  
    CASE currentState IS
		
		WHEN S0 =>
            PCWr <= '1';
            ResSrc <= "10";
            ALUop <= "00"; --innecesario
            ALUsrcA <= "00"; --innecesario
            ALUsrcB <= "10";
            --IRWr <= '1';
            OldPCwr <= '1';
            AddrSrc <= '0'; --innecesario
            nextState <= S0bis; --nextState <= S1;                
			
	    WHEN S0bis =>
	        AddrSrc <= '0'; --innecesario.  No hace falta porque la lectura se hace en el ciclo anterior
			IRWr <= '1';
			nextState <= S1;
			
		WHEN S1 =>
			AWr <= '1';
			BWr <= '1';
			ALUop <= "00"; --innecesario
			ALUsrcA <= "01";
			ALUsrcB <= "01";
			ALUoutWr <= '1';
			if (op = "0000011" or op = "0100011") then -- lw/sw
				nextState <= S2;
			elsif (op = "0010011") then -- tipo I
				nextState <= S8;
			elsif (op = "0110011") then -- tipo R
				nextState <= S6;
			elsif (op = "1101111") then -- jal
				nextState <= S9;
			elsif (op = "1100011") then -- beq
				nextState <= S10;
			end if;
			
		WHEN S2 =>
		   ALUoutWr <= '1';
		   ALUop <= "00"; --innecesario
		   ALUsrcA <= "10";
		   ALUsrcB <= "01";
		   if (op = "0000011") then -- lw
		      nextState <= S3;
		   elsif (op = "0100011") then -- sw
		     nextState <= S5; 
		   end if;
		
		WHEN S3 =>
		    --MDRwr <= '1';
		    AddrSrc <= '1';
		    ResSrc <= "00"; --innecesario
		    nextState <= S3bis;--nextState <= S4;
		    
		WHEN S3bis =>
		    MDRwr <= '1';
		    AddrSrc <= '1'; -- No hace falta porque la lectura se hace en el ciclo anterior
		    ResSrc <= "00"; --innecesario. NO hace falta porque la lectura se hace en el ciclo anterior
		    nextState <= S4;		    
			
		WHEN S4 =>
			ResSrc <= "01";
			BRWr <= '1';
			nextState <= S0;
		
		WHEN S5 =>
			MemWr <= '1';
			ResSrc <= "00"; --innecesario
			AddrSrc <= '1';
			nextState <= S0;
		
		WHEN S6 =>
			ALUoutWr <= '1';
			ALUsrcA <= "10";
			ALUsrcB <= "00"; --innecesario
			ALUop <= "10";
			nextState <= S7;
		
		WHEN S7 =>
			ResSrc <= "00"; --innecesario
			BRWr <= '1';
			nextState <= S0;
		
		WHEN S8 =>
		    ALUoutWr <= '1';
		    ALUsrcA <= "10";
		    ALUsrcB <= "01";
			ALUop <= "10";
			nextState <= S7;
		
		WHEN S9 =>
			PCWr <= '1';
			ResSrc <= "00"; --innecesario
			ALUoutWr <= '1';
			ALUop <= "00"; --innecesario
			ALUsrcA <= "01";
			ALUsrcB <= "10";
			nextState <= S7;
			
		WHEN S10 =>
			ALUsrcA <= "10";
			ALUSrcB <= "00"; --innecesario
			ALUop <= "01";
			if (Zero = '0') then
				nextState <= S0;
			else
			    PCWr <= '1';
			    ResSrc <= "00"; --innecesario
				nextState <= S0;
			end if;
			
    END CASE;
    
  END PROCESS stateGen;

  state:
  PROCESS (rst, clk)
  BEGIN
	 IF (rst = '1') THEN
		currentState <= S0;
    ELSIF RISING_EDGE(clk) THEN
		currentState <= nextState;
    END IF;
  END PROCESS state;

end unidadDeControlArch;