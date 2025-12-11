
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use IEEE.numeric_std.all;


entity fmc_fsm is
generic(
	bus_length: INTEGER := 16
);
port( 
	-- Segnali MCU - FMC
	FMC_CLK, FMC_NE1, FMC_NOE, FMC_NWE : in STD_LOGIC;
	
	-- Segnali FMC - Registri
	ADD_LE, DIN_OE, DOUT_LE : out STD_LOGIC;
	
	-- Segnali FMC - Memoria
	RD, WR: out STD_LOGIC
);
end	fmc_fsm;

---------------------------------------------

architecture behavioral of fmc_fsm is

	type TYPE_STATE is (S_IDLE, S_ADD_SAMPLE, S_READ, S_DATA_OUT, S_DATA_SAMPLE, S_WAIT, S_HOLD, S_WRITE);
	
	signal CURRENT_STATE : TYPE_STATE := S_IDLE;
	signal NEXT_STATE : TYPE_STATE := S_IDLE;

	begin

 	P_ADVANCE_STATE : process(FMC_CLK)		
	begin
		if (FMC_CLK ='1' and FMC_CLK'EVENT) then 
			CURRENT_STATE <= NEXT_STATE;
		end if;
	end process P_ADVANCE_STATE;

	P_NEXT_STATE : process(CURRENT_STATE, FMC_NE1, FMC_NWE)
	begin
		case CURRENT_STATE is
			when S_IDLE => 
				if FMC_NE1 = '0' then
					NEXT_STATE <= S_ADD_SAMPLE;
				else
					NEXT_STATE <= S_IDLE;
				end if;
				
			when S_ADD_SAMPLE => 
				if FMC_NWE = '1' then
					NEXT_STATE <= S_READ;	--Passo alla sequenza di read
				else
					NEXT_STATE <= S_HOLD;	--Passo alla frequenza di write
				end if;
			
			when S_READ => 
				NEXT_STATE <= S_DATA_OUT;
			
			when S_DATA_OUT => 
				NEXT_STATE <= S_WAIT;
			
			when S_WAIT => 
				if FMC_NE1 = '1' then
					NEXT_STATE <= S_IDLE;
				else
					NEXT_STATE <= S_WAIT;
				end if;

			when S_HOLD => 
				NEXT_STATE <= S_DATA_SAMPLE;
			
			when S_DATA_SAMPLE => 
				NEXT_STATE <= S_WRITE;
			
			when S_WRITE => 
				NEXT_STATE <= S_WAIT;
			
			
		end case;	
	end process P_NEXT_STATE;

	
	P_OUTPUTS: process(CURRENT_STATE, FMC_CLK)
	begin
	
		case CURRENT_STATE is
				
			when S_IDLE => 
				DIN_OE <= '0';
				ADD_LE <= '0';
				DOUT_LE <= '0';
				RD <= '0';
				WR <= '0';
				
			when S_ADD_SAMPLE => 
				DIN_OE <= '0';
				ADD_LE <= '1';
				DOUT_LE <= '0';
				RD <= '0';
				WR <= '0';
				
			when S_READ => 
				DIN_OE <= '0';
				ADD_LE <= '0';
				DOUT_LE <= '0';
				RD <= '1';
				WR <= '0';
				
			when S_DATA_OUT => 
				DIN_OE <= '1';
				ADD_LE <= '0';
				DOUT_LE <= '0';
				RD <= '0';
				WR <= '0';
				
			when S_WAIT => 
				DIN_OE <= '0';
				ADD_LE <= '0';
				DOUT_LE <= '0';
				RD <= '0';
				WR <= '0';
				
			when S_HOLD => 
				DIN_OE <= '0';
				ADD_LE <= '0';
				DOUT_LE <= '0';
				RD <= '0';
				WR <= '0';
				
			when S_DATA_SAMPLE => 
				DIN_OE <= '0';
				ADD_LE <= '0';
				DOUT_LE <= '1';
				RD <= '0';
				WR <= '0';
				
			when S_WRITE => 
				DIN_OE <= '0';
				ADD_LE <= '0';
				DOUT_LE <= '0';
				RD <= '0';
				WR <= '1';				

		end case; 	
	end process P_OUTPUTS;
end behavioral;
 
