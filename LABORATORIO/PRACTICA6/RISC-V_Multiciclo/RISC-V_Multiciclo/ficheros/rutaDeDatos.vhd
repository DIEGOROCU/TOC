library IEEE;
use IEEE.std_logic_1164.all;

entity rutaDeDatos is
	port( 
		clk		: in  std_logic;
		rst   	: in  std_logic;
		control	: in  std_logic_vector(17 downto 0);
		estado  : out std_logic_vector(11 downto 0)	
	);
end rutaDeDatos;

architecture rutaDeDatosArch of rutaDeDatos is

	component registro
		generic(
			n : positive := 32
		);
		port( 
			clk  : in  std_logic;
			rst  : in  std_logic;
			load : in  std_logic;
			din  : in  std_logic_vector( n-1 downto 0 );
			dout : out std_logic_vector( n-1 downto 0 ) 
		);
	end component;
	
	component multiplexor2a1
		generic(
			bits_entradas: positive := 32
		); 
		port( 
			entrada0     : in  std_logic_vector(bits_entradas-1 downto 0); 
			entrada1     : in  std_logic_vector(bits_entradas-1 downto 0); 
			seleccion    : in  std_logic; 
			salida       : out std_logic_vector(bits_entradas-1 downto 0)  
		); 
	end component; 

	component multiplexor4a1 
		generic(
			bits_entradas: positive := 32
		); 
		port( 
			entrada0	: in  std_logic_vector(bits_entradas-1 downto 0);
			entrada1	: in  std_logic_vector(bits_entradas-1 downto 0);
			entrada2	: in  std_logic_vector(bits_entradas-1 downto 0);
			entrada3    : in  std_logic_vector(bits_entradas-1 downto 0);
			seleccion   : in  std_logic_vector(1 downto 0); 
			salida	    : out std_logic_vector(bits_entradas-1 downto 0)  
		); 
	end component;

	component memoria is
		port( 
			clk		    : in  std_logic;
			ADDR		: in  std_logic_vector(31 downto 0 );
			MemWrite	: in  std_logic;
			MemRead	    : in  std_logic;
			DW			: in  std_logic_vector(31 downto 0 );
			DR			: out std_logic_vector(31 downto 0 ) 
		);
	end component;	
  
  
	component bancoDeRegistros
		port( 
			clk		    : in  std_logic;
			rst 		: in  std_logic;
			RA1			: in  std_logic_vector(4 downto 0);
			RA2			: in  std_logic_vector(4 downto 0);
			WE       	: in  std_logic;
			WA			: in  std_logic_vector(4 downto 0);
			WD		    : in  std_logic_vector(31 downto 0);
			RD1		    : out std_logic_vector(31 downto 0);
			RD2		    : out std_logic_vector(31 downto 0) 
		);
	end component;  
  
	component ALU
		port( 		
			A			: in  std_logic_vector(31 downto 0);
			B			: in  std_logic_vector(31 downto 0);
			ALUop		: in  std_logic_vector(1 downto 0);
			op_5	    : in  std_logic;
            funct7_5   	: in  std_logic;
            funct3		: in  std_logic_vector(2 downto 0);            
			Zero		: out std_logic;
			R			: out std_logic_vector(31 downto 0)
		);
	end component;  

    component extesnionDeSigno
        port( 
            IR	              : in  std_logic_vector(31 downto 0);
            signo_extendido   : out std_logic_vector(31 downto 0)  
        ); 
    end component;	
  
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
  
  
  signal salidaALU          : std_logic_vector(31 downto 0);
  signal PC                 : std_logic_vector(31 downto 0);
  signal OldPC              : std_logic_vector(31 downto 0);
  signal ALUOut             : std_logic_vector(31 downto 0);
  signal ADDR               : std_logic_vector(31 downto 0);
  signal A                  : std_logic_vector(31 downto 0);
  signal B                  : std_logic_vector(31 downto 0);
  signal salidaMem          : std_logic_vector(31 downto 0);
  signal IR                 : std_logic_vector(31 downto 0);
  signal MDR                : std_logic_vector(31 downto 0);
  signal OPA                : std_logic_vector(31 downto 0);
  signal OPB                : std_logic_vector(31 downto 0);
  signal signo_extendido    : std_logic_vector(31 downto 0);
  signal salidaBancoRegA    : std_logic_vector(31 downto 0);
  signal salidaBancoRegb    : std_logic_vector(31 downto 0);  
  signal salidaResSrc       : std_logic_vector(31 downto 0);
  
begin

	op <= IR(6 downto 0);
	funct3 <= IR(14 downto 12);
	funct7_5 <= IR(30);

	reg_PC : registro port map(clk => clk, rst => rst, load => PCWr, din => salidaResSrc, dout => PC);

	mux_AddrSrc : multiplexor2a1 port map(entrada0 => PC, entrada1 => salidaResSrc, seleccion => AddrSrc, salida => ADDR); 

	mem : memoria port map(clk => clk, ADDR => ADDR, MemWrite => MemWr, MemRead => '1', DW => B, DR => salidaMem); -- TODO: ¿Controlar la señal de lectura?
	
	reg_IR : registro port map(clk => clk, rst => rst, load => IRWr, din => salidaMem, dout => IR);
	
    reg_OldPC : registro port map(clk => clk, rst => rst, load => OldPCwr, din => PC, dout => OldPC);
	
	reg_MDR : registro port map(clk => clk, rst => rst, load => MDRwr, din => salidaMem, dout => MDR);
	
	extesnionDeSigno_i : extesnionDeSigno port map(IR => IR, signo_extendido => signo_extendido);

	banco_registros: bancoDeRegistros port map(clk => clk, rst => rst, RA1 => IR(19 downto 15), RA2 => IR(24 downto 20), WE => BRWr, WA => IR(11 downto 7), WD => salidaResSrc, RD1 => salidaBancoRegA, RD2 => salidaBancoRegB);
	
	reg_A : registro port map(clk => clk, rst => rst, load => AWr, din => salidaBancoRegA, dout => A);
	
	reg_B : registro port map(clk => clk, rst => rst, load => BWr, din => salidaBancoRegB, dout => B);
	
	mux_opA : multiplexor4a1 port map(entrada0 => PC, entrada1 => OldPC, entrada2 => A, entrada3 => x"00000000", seleccion => ALUsrcA, salida => OPA);
	
	mux_opB : multiplexor4a1 port map(entrada0 => B, entrada1 => signo_extendido, entrada2 => x"00000004", entrada3 => x"00000000", seleccion => ALUsrcB, salida => OPB); 
	
	ALU_i : ALU port map(A => OPA, B => OPB, ALUop => ALUop, op_5 => IR(5), funct7_5 => IR(30), funct3 => IR(14 downto 12), Zero => Zero, R => salidaALU);
	
	reg_ALUout : registro port map(clk => clk, rst => rst, load => ALUoutWr, din => salidaALU, dout => ALUOut);

    mux_ResSrc : multiplexor4a1 port map(entrada0 => ALUOut, entrada1 => MDR, entrada2 => salidaALU, entrada3 => x"00000000", seleccion => ResSrc, salida => salidaResSrc);
    
end rutaDeDatosArch;