module EQ(
    // Input Port
    clk,
    rst_n,
    in_valid,
    in_row,
    in_col,
    // Output Port
    out_valid,
    out
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//---------------------------------------------------------------------
input clk, rst_n, in_valid;
input [2:0] in_row, in_col;
output logic out_valid;
output logic [2:0] out;

logic diaP [13:1];
logic diaM [13:1];
logic col [7:0];
logic [3:0] CS, NS;
logic [3:0] i;
logic [2:0] Irow [1:0];
logic [2:0] Icol [1:0];
logic [3:0] IdiaP [1:0];
logic [3:0] IdiaM [1:0];
logic [3:0] IdiaP_temp;
logic [3:0] IdiaM_temp;
logic [2:0] outTemp [7:0];
logic UPorDOWN;
logic [3:0] counter;

parameter IDLE = 0;
parameter GET0 = 1;
parameter GET1 = 12;
parameter CAL0 = 2;
parameter CAL1 = 3;
parameter CAL2 = 4;
parameter CAL3 = 5;
parameter CAL4 = 6;
parameter CAL5 = 7;
parameter CAL6 = 8;
parameter CAL7 = 9;
parameter OUT_0 = 10;
parameter OUT = 11;

parameter UP = 0;
parameter DOWN = 1;



always_ff @ ( posedge clk or negedge rst_n ) begin
	if( !rst_n ) begin
		out_valid <= 0;
		out <= 0;
		CS <= IDLE;
		counter <= 0;
	end
	else begin
		case( NS )
			IDLE: begin
				for( i = 0 ; i < 8 ; i = i + 1 ) begin
					col[i] <= 0;
				end
				for( i = 1 ; i < 14 ; i = i + 1 ) begin
					diaP[i] <= 0;
					diaM[i] <= 0;
				end
			end
			GET0: begin
				Irow[0] <= in_row;
				Icol[0] <= in_col;
				IdiaP[0] <= IdiaP_temp;
				IdiaM[0] <= IdiaM_temp;
				col[in_col] <= 1;
				diaP[ IdiaP_temp ] <= 1;
				diaM[ IdiaM_temp ] <= 1;
				outTemp[in_row] <= in_col;
				CS <= GET1;
			end
			GET1: begin
				Irow[1] <= in_row;
				Icol[1] <= in_col;
				IdiaP[1] <= IdiaP_temp;
				IdiaM[1] <= IdiaM_temp;
				col[in_col] <= 1;
				diaP[ IdiaP_temp ] <= 1;
				diaM[ IdiaM_temp ] <= 1;
				outTemp[in_row] <= in_col;
				CS <= CAL0;
				UPorDOWN <= DOWN;
				outTemp[0] <= 0;
			end
			CAL0: begin
				if( Irow[0] != 0 && Irow[1] != 0 ) begin
					case( outTemp[0] )
						0: begin
							if( UPorDOWN == UP ) begin
								col[0] <= 0;
								diaM[7] <= 0;
							end
						end
						1: begin
							col[1] <= 0;
							diaM[6] <= 0;
							diaP[1] <= 0;
						end
						2: begin
							col[2] <= 0;
							diaM[5] <= 0;
							diaP[2] <= 0;
						end
						3: begin
							col[3] <= 0;
							diaM[4] <= 0;
							diaP[3] <= 0;
						end
						4: begin
							col[4] <= 0;
							diaM[3] <= 0;
							diaP[4] <= 0;
						end
						5: begin
							col[5] <= 0;
							diaM[2] <= 0;
							diaP[5] <= 0;
						end
						6: begin
							col[6] <= 0;
							diaM[1] <= 0;
							diaP[6] <= 0;
						end
					endcase
					if( !col[0] && !diaM[7] && UPorDOWN == DOWN ) begin
						outTemp[0] <= 0;
						col[0] <= 1;
						diaM[7] <= 1;
					end
					else if( !col[1] && !diaM[6] && !diaP[1] && outTemp[0] == 0 ) begin
						outTemp[0] <= 1;
						col[1] <= 1;
						diaM[6] <= 1;
						diaP[1] <= 1;
					end
					else if( !col[2] && !diaM[5] && !diaP[2] && outTemp[0] <= 1 ) begin
						outTemp[0] <= 2;
						col[2] <= 1;
						diaM[5] <= 1;
						diaP[2] <= 1;
					end
					else if( !col[3] && !diaM[4] && !diaP[3] && outTemp[0] <= 2 ) begin
						outTemp[0] <= 3;
						col[3] <= 1;
						diaM[4] <= 1;
						diaP[3] <= 1;
					end
					else if( !col[4] && !diaM[3] && !diaP[4] && outTemp[0] <= 3 ) begin
						outTemp[0] <= 4;
						col[4] <= 1;
						diaM[3] <= 1;
						diaP[4] <= 1;
					end
					else if( !col[5] && !diaM[2] && !diaP[5] && outTemp[0] <= 4 ) begin
						outTemp[0] <= 5;
						col[5] <= 1;
						diaM[2] <= 1;
						diaP[5] <= 1;
					end
					else if( !col[6] && !diaM[1] && !diaP[6] && outTemp[0] <= 5 ) begin
						outTemp[0] <= 6;
						col[6] <= 1;
						diaM[1] <= 1;
						diaP[6] <= 1;
					end
					else if( !col[7] && !diaP[7] && outTemp[0] <= 6 ) begin
						outTemp[0] <= 7;
						col[7] <= 1;
						diaP[7] <= 1;
					end
					CS <= CAL1;
					UPorDOWN <= DOWN;
					outTemp[1] <= 0;
				end
				else begin
					CS <= CAL1;
					outTemp[1] <= 0;
				end
			end
			CAL1: begin
				if( Irow[0] != 1 && Irow[1] != 1 ) begin
					case( outTemp[1] )
						0: begin
							if( UPorDOWN == UP ) begin
								col[0] <= 0;
								diaM[8] <= 0;
								diaP[1] <= 0;
							end
						end
						1: begin
							col[1] <= 0;
							diaM[7] <= 0;
							diaP[2] <= 0;
						end
						2: begin
							col[2] <= 0;
							diaM[6] <= 0;
							diaP[3] <= 0;
						end
						3: begin
							col[3] <= 0;
							diaM[5] <= 0;
							diaP[4] <= 0;
						end
						4: begin
							col[4] <= 0;
							diaM[4] <= 0;
							diaP[5] <= 0;
						end
						5: begin
							col[5] <= 0;
							diaM[3] <= 0;
							diaP[6] <= 0;
						end
						6: begin
							col[6] <= 0;
							diaM[2] <= 0;
							diaP[7] <= 0;
						end
						7: begin
							col[7] <= 0;
							diaM[1] <= 0;
							diaP[8] <= 0;
						end
					endcase
					if( !col[0] && !diaM[8] && !diaP[1] && UPorDOWN == DOWN ) begin
						outTemp[1] <= 0;
						col[0] <= 1;
						diaM[8] <= 1;
						diaP[1] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[1] && !diaM[7] && !diaP[2] && outTemp[1] == 0 ) begin						
						outTemp[1] <= 1;
						col[1] <= 1;
						diaM[7] <= 1;
						diaP[2] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[2] && !diaM[6] && !diaP[3] && outTemp[1] <= 1 ) begin
						outTemp[1] <= 2;
						col[2] <= 1;
						diaM[6] <= 1;
						diaP[3] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[3] && !diaM[5] && !diaP[4] && outTemp[1] <= 2 ) begin
						outTemp[1] <= 3;
						col[3] <= 1;
						diaM[5] <= 1;
						diaP[4] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[4] && !diaM[4] && !diaP[5] && outTemp[1] <= 3 ) begin
						outTemp[1] <= 4;
						col[4] <= 1;
						diaM[4] <= 1;
						diaP[5] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[5] && !diaM[3] && !diaP[6] && outTemp[1] <= 4 ) begin
						outTemp[1] <= 5;
						col[5] <= 1;
						diaM[3] <= 1;
						diaP[6] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[6] && !diaM[2] && !diaP[7] && outTemp[1] <= 5 ) begin
						outTemp[1] <= 6;
						col[6] <= 1;
						diaM[2] <= 1;
						diaP[7] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[7] && !diaM[1] && !diaP[8] && outTemp[1] <= 6 ) begin
						outTemp[1] <= 7;
						col[7] <= 1;
						diaM[1] <= 1;
						diaP[8] <= 1;
						CS <= CAL2;
						outTemp[2] <= 0;
						UPorDOWN <= DOWN;
					end
					else begin
						CS <= CAL0;
						UPorDOWN <= UP;
					end
				end
				else if( UPorDOWN == DOWN ) begin
					CS <= CAL2;
					outTemp[2] <= 0;
				end
				else begin
					CS <= CAL0;
				end
			end
			CAL2: begin
				if( Irow[0] != 2 && Irow[1] != 2 ) begin
					case( outTemp[2] )
						0: begin
							if( UPorDOWN == UP ) begin
								col[0] <= 0;
								diaM[9] <= 0;
								diaP[2] <= 0;
							end
						end
						1: begin
							col[1] <= 0;
							diaM[8] <= 0;
							diaP[3] <= 0;
						end
						2: begin
							col[2] <= 0;
							diaM[7] <= 0;
							diaP[4] <= 0;
						end
						3: begin
							col[3] <= 0;
							diaM[6] <= 0;
							diaP[5] <= 0;
						end
						4: begin
							col[4] <= 0;
							diaM[5] <= 0;
							diaP[6] <= 0;
						end
						5: begin
							col[5] <= 0;
							diaM[4] <= 0;
							diaP[7] <= 0;
						end
						6: begin
							col[6] <= 0;
							diaM[3] <= 0;
							diaP[8] <= 0;
						end
						7: begin
							col[7] <= 0;
							diaM[2] <= 0;
							diaP[9] <= 0;
						end
					endcase
					if( !col[0] && !diaM[9] && !diaP[2] && UPorDOWN == DOWN ) begin
						outTemp[2] <= 0;
						col[0] <= 1;
						diaM[9] <= 1;
						diaP[2] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[1] && !diaM[8] && !diaP[3] && outTemp[2] == 0 ) begin
						outTemp[2] <= 1;
						col[1] <= 1;
						diaM[8] <= 1;
						diaP[3] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[2] && !diaM[7] && !diaP[4] && outTemp[2] <= 1 ) begin
						outTemp[2] <= 2;
						col[2] <= 1;
						diaM[7] <= 1;
						diaP[4] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[3] && !diaM[6] && !diaP[5] && outTemp[2] <= 2 ) begin
						outTemp[2] <= 3;
						col[3] <= 1;
						diaM[6] <= 1;
						diaP[5] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[4] && !diaM[5] && !diaP[6] && outTemp[2] <= 3 ) begin
						outTemp[2] <= 4;
						col[4] <= 1;
						diaM[5] <= 1;
						diaP[6] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[5] && !diaM[4] && !diaP[7] && outTemp[2] <= 4 ) begin
						outTemp[2] <= 5;
						col[5] <= 1;
						diaM[4] <= 1;
						diaP[7] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[6] && !diaM[3] && !diaP[8] && outTemp[2] <= 5 ) begin
						outTemp[2] <= 6;
						col[6] <= 1;
						diaM[3] <= 1;
						diaP[8] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[7] && !diaM[2] && !diaP[9] && outTemp[2] <= 6 ) begin
						outTemp[2] <= 7;
						col[7] <= 1;
						diaM[2] <= 1;
						diaP[9] <= 1;
						CS <= CAL3;
						outTemp[3] <= 0;
						UPorDOWN <= DOWN;
					end
					else begin
						CS <= CAL1;
						UPorDOWN <= UP;
					end
				end
				else if( UPorDOWN == DOWN ) begin
					CS <= CAL3;
					outTemp[3] <= 0;
				end
				else begin
					CS <= CAL1;
				end
			end
			CAL3: begin
				if( Irow[0] != 3 && Irow[1] != 3 ) begin
					case( outTemp[3] )
						0: begin
							if( UPorDOWN == UP ) begin
								col[0] <= 0;
								diaM[10] <= 0;
								diaP[3] <= 0;
							end
						end
						1: begin
							col[1] <= 0;
							diaM[9] <= 0;
							diaP[4] <= 0;
						end
						2: begin
							col[2] <= 0;
							diaM[8] <= 0;
							diaP[5] <= 0;
						end
						3: begin
							col[3] <= 0;
							diaM[7] <= 0;
							diaP[6] <= 0;
						end
						4: begin
							col[4] <= 0;
							diaM[6] <= 0;
							diaP[7] <= 0;
						end
						5: begin
							col[5] <= 0;
							diaM[5] <= 0;
							diaP[8] <= 0;
						end
						6: begin
							col[6] <= 0;
							diaM[4] <= 0;
							diaP[9] <= 0;
						end
						7: begin
							col[7] <= 0;
							diaM[3] <= 0;
							diaP[10] <= 0;
						end
					endcase
					if( !col[0] && !diaM[10] && !diaP[3] && UPorDOWN == DOWN ) begin
						outTemp[3] <= 0;
						col[0] <= 1;
						diaM[10] <= 1;
						diaP[3] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[1] && !diaM[9] && !diaP[4] && outTemp[3] == 0 ) begin
						outTemp[3] <= 1;
						col[1] <= 1;
						diaM[9] <= 1;
						diaP[4] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[2] && !diaM[8] && !diaP[5] && outTemp[3] <= 1 ) begin
						outTemp[3] <= 2;
						col[2] <= 1;
						diaM[8] <= 1;
						diaP[5] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[3] && !diaM[7] && !diaP[6] && outTemp[3] <= 2 ) begin
						outTemp[3] <= 3;
						col[3] <= 1;
						diaM[7] <= 1;
						diaP[6] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[4] && !diaM[6] && !diaP[7] && outTemp[3] <= 3 ) begin
						outTemp[3] <= 4;
						col[4] <= 1;
						diaM[6] <= 1;
						diaP[7] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[5] && !diaM[5] && !diaP[8] && outTemp[3] <= 4 ) begin
						outTemp[3] <= 5;
						col[5] <= 1;
						diaM[5] <= 1;
						diaP[8] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[6] && !diaM[4] && !diaP[9] && outTemp[3] <= 5 ) begin
						outTemp[3] <= 6;
						col[6] <= 1;
						diaM[4] <= 1;
						diaP[9] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[7] && !diaM[3] && !diaP[10] && outTemp[3] <= 6 ) begin
						outTemp[3] <= 7;
						col[7] <= 1;
						diaM[3] <= 1;
						diaP[10] <= 1;
						CS <= CAL4;
						outTemp[4] <= 0;
						UPorDOWN <= DOWN;
					end
					else begin
						CS <= CAL2;
						UPorDOWN <= UP;
					end
				end
				else if( UPorDOWN == DOWN ) begin
					CS <= CAL4;
					outTemp[4] <= 0;
				end
				else begin
					CS <= CAL2;
				end
			end
			CAL4: begin
				if( Irow[0] != 4 && Irow[1] != 4 ) begin
					case( outTemp[4] )
						0: begin
							if( UPorDOWN == UP ) begin
								col[0] <= 0;
								diaM[11] <= 0;
								diaP[4] <= 0;
							end
						end
						1: begin
							col[1] <= 0;
							diaM[10] <= 0;
							diaP[5] <= 0;
						end
						2: begin
							col[2] <= 0;
							diaM[9] <= 0;
							diaP[6] <= 0;
						end
						3: begin
							col[3] <= 0;
							diaM[8] <= 0;
							diaP[7] <= 0;
						end
						4: begin
							col[4] <= 0;
							diaM[7] <= 0;
							diaP[8] <= 0;
						end
						5: begin
							col[5] <= 0;
							diaM[6] <= 0;
							diaP[9] <= 0;
						end
						6: begin
							col[6] <= 0;
							diaM[5] <= 0;
							diaP[10] <= 0;
						end
						7: begin
							col[7] <= 0;
							diaM[4] <= 0;
							diaP[11] <= 0;
						end
					endcase
					if( !col[0] && !diaM[11] && !diaP[4] && UPorDOWN == DOWN ) begin
						outTemp[4] <= 0;
						col[0] <= 1;
						diaM[11] <= 1;
						diaP[4] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[1] && !diaM[10] && !diaP[5] && outTemp[4] == 0 ) begin
						outTemp[4] <= 1;
						col[1] <= 1;
						diaM[10] <= 1;
						diaP[5] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[2] && !diaM[9] && !diaP[6] && outTemp[4] <= 1 ) begin
						outTemp[4] <= 2;
						col[2] <= 1;
						diaM[9] <= 1;
						diaP[6] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[3] && !diaM[8] && !diaP[7] && outTemp[4] <= 2 ) begin
						outTemp[4] <= 3;
						col[3] <= 1;
						diaM[8] <= 1;
						diaP[7] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[4] && !diaM[7] && !diaP[8] && outTemp[4] <= 3 ) begin
						outTemp[4] <= 4;
						col[4] <= 1;
						diaM[7] <= 1;
						diaP[8] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[5] && !diaM[6] && !diaP[9] && outTemp[4] <= 4 ) begin
						outTemp[4] <= 5;
						col[5] <= 1;
						diaM[6] <= 1;
						diaP[9] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[6] && !diaM[5] && !diaP[10] && outTemp[4] <= 5 ) begin
						outTemp[4] <= 6;
						col[6] <= 1;
						diaM[5] <= 1;
						diaP[10] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[7] && !diaM[4] && !diaP[11] && outTemp[4] <= 6 ) begin
						outTemp[4] <= 7;
						col[7] <= 1;
						diaM[4] <= 1;
						diaP[11] <= 1;
						CS <= CAL5;
						outTemp[5] <= 0;
						UPorDOWN <= DOWN;
					end
					else begin
						CS <= CAL3;
						UPorDOWN <= UP;
					end
				end
				else if( UPorDOWN == DOWN ) begin
					CS <= CAL5;
					outTemp[5] <= 0;
				end
				else begin
					CS <= CAL3;
				end
			end
			CAL5: begin
				if( Irow[0] != 5 && Irow[1] != 5 ) begin
					case( outTemp[5] )
						0: begin
							if( UPorDOWN == UP ) begin
								col[0] <= 0;
								diaM[12] <= 0;
								diaP[5] <= 0;
							end
						end
						1: begin
							col[1] <= 0;
							diaM[11] <= 0;
							diaP[6] <= 0;
						end
						2: begin
							col[2] <= 0;
							diaM[10] <= 0;
							diaP[7] <= 0;
						end
						3: begin
							col[3] <= 0;
							diaM[9] <= 0;
							diaP[8] <= 0;
						end
						4: begin
							col[4] <= 0;
							diaM[8] <= 0;
							diaP[9] <= 0;
						end
						5: begin
							col[5] <= 0;
							diaM[7] <= 0;
							diaP[10] <= 0;
						end
						6: begin
							col[6] <= 0;
							diaM[6] <= 0;
							diaP[11] <= 0;
						end
						7: begin
							col[7] <= 0;
							diaM[5] <= 0;
							diaP[12] <= 0;
						end
					endcase						
					if( !col[0] && !diaM[12] && !diaP[5] && UPorDOWN == DOWN ) begin
						outTemp[5] <= 0;
						col[0] <= 1;
						diaM[12] <= 1;
						diaP[5] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[1] && !diaM[11] && !diaP[6] && outTemp[5] == 0 ) begin
						outTemp[5] <= 1;
						col[1] <= 1;
						diaM[11] <= 1;
						diaP[6] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[2] && !diaM[10] && !diaP[7] && outTemp[5] <= 1 ) begin
						outTemp[5] <= 2;
						col[2] <= 1;
						diaM[10] <= 1;
						diaP[7] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[3] && !diaM[9] && !diaP[8] && outTemp[5] <= 2 ) begin
						outTemp[5] <= 3;
						col[3] <= 1;
						diaM[9] <= 1;
						diaP[8] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[4] && !diaM[8] && !diaP[9] && outTemp[5] <= 3 ) begin
						outTemp[5] <= 4;
						col[4] <= 1;
						diaM[8] <= 1;
						diaP[9] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[5] && !diaM[7] && !diaP[10] && outTemp[5] <= 4 ) begin
						outTemp[5] <= 5;
						col[5] <= 1;
						diaM[7] <= 1;
						diaP[10] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[6] && !diaM[6] && !diaP[11] && outTemp[5] <= 5 ) begin
						outTemp[5] <= 6;
						col[6] <= 1;
						diaM[6] <= 1;
						diaP[11] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[7] && !diaM[5] && !diaP[12] && outTemp[5] <= 6 ) begin
						outTemp[5] <= 7;
						col[7] <= 1;
						diaM[5] <= 1;
						diaP[12] <= 1;
						CS <= CAL6;
						outTemp[6] <= 0;
						UPorDOWN <= DOWN;
					end
					else begin
						CS <= CAL4;
						UPorDOWN <= UP;
					end
				end
				else if( UPorDOWN == DOWN ) begin
					CS <= CAL6;
					outTemp[6] <= 0;
				end
				else begin
					CS <= CAL4;
				end
			end
			CAL6: begin
				if( Irow[0] != 6 && Irow[1] != 6 ) begin
					case( outTemp[6] )
						0: begin
							if( UPorDOWN == UP ) begin
								col[0] <= 0;
								diaM[13] <= 0;
								diaP[6] <= 0;
							end
						end
						1: begin
							col[1] <= 0;
							diaM[12] <= 0;
							diaP[7] <= 0;
						end
						2: begin
							col[2] <= 0;
							diaM[11] <= 0;
							diaP[8] <= 0;
						end
						3: begin
							col[3] <= 0;
							diaM[10] <= 0;
							diaP[9] <= 0;
						end
						4: begin
							col[4] <= 0;
							diaM[9] <= 0;
							diaP[10] <= 0;
						end
						5: begin
							col[5] <= 0;
							diaM[8] <= 0;
							diaP[11] <= 0;
						end
						6: begin
							col[6] <= 0;
							diaM[7] <= 0;
							diaP[12] <= 0;
						end
						7: begin
							col[7] <= 0;
							diaM[6] <= 0;
							diaP[13] <= 0;
						end
					endcase
					if( !col[0] && !diaM[13] && !diaP[6] && UPorDOWN == DOWN ) begin
						outTemp[6] <= 0;
						col[0] <= 1;
						diaM[13] <= 1;
						diaP[6] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[1] && !diaM[12] && !diaP[7] && outTemp[6] == 0 ) begin
						outTemp[6] <= 1;
						col[1] <= 1;
						diaM[12] <= 1;
						diaP[7] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[2] && !diaM[11] && !diaP[8] && outTemp[6] <= 1 ) begin
						outTemp[6] <= 2;
						col[2] <= 1;
						diaM[11] <= 1;
						diaP[8] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[3] && !diaM[10] && !diaP[9] && outTemp[6] <= 2 ) begin
						outTemp[6] <= 3;
						col[3] <= 1;
						diaM[10] <= 1;
						diaP[9] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[4] && !diaM[9] && !diaP[10] && outTemp[6] <= 3 ) begin
						outTemp[6] <= 4;
						col[4] <= 1;
						diaM[9] <= 1;
						diaP[10] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[5] && !diaM[8] && !diaP[11] && outTemp[6] <= 4 ) begin
						outTemp[6] <= 5;
						col[5] <= 1;
						diaM[8] <= 1;
						diaP[11] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[6] && !diaM[7] && !diaP[12] && outTemp[6] <= 5 ) begin
						outTemp[6] <= 6;
						col[6] <= 1;
						diaM[7] <= 1;
						diaP[12] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else if( !col[7] && !diaM[6] && !diaP[13] && outTemp[6] <= 6 ) begin
						outTemp[6] <= 7;
						col[7] <= 1;
						diaM[6] <= 1;
						diaP[13] <= 1;
						CS <= CAL7;
						outTemp[7] <= 0;
						UPorDOWN <= DOWN;
					end
					else begin
						CS <= CAL5;
						UPorDOWN <= UP;
					end
				end
				else if( UPorDOWN == DOWN ) begin
					CS <= CAL7;
					outTemp[7] <= 0;
				end
				else begin
					CS <= CAL5;
				end
			end	
			CAL7: begin				
				if( Irow[0] != 7 && Irow[1] != 7 ) begin
					if( !col[0] && !diaP[7] ) begin
						outTemp[7] <= 0;
						CS <= OUT_0;
					end
					else if( !col[1] && !diaM[13] && !diaP[8]) begin
						outTemp[7] <= 1;
						CS <= OUT_0;
					end
					else if( !col[2] && !diaM[12] && !diaP[9] ) begin
						outTemp[7] <= 2;
						CS <= OUT_0;
					end
					else if( !col[3] && !diaM[11] && !diaP[10] ) begin
						outTemp[7] <= 3;
						CS <= OUT_0;
					end
					else if( !col[4] && !diaM[10] && !diaP[11] ) begin
						outTemp[7] <= 4;
						CS <= OUT_0;
					end
					else if( !col[5] && !diaM[9] && !diaP[12] ) begin
						outTemp[7] <= 5;
						CS <= OUT_0;
					end
					else if( !col[6] && !diaM[8] && !diaP[13] ) begin
						outTemp[7] <= 6;
						CS <= OUT_0;
					end
					else if( !col[7] && !diaM[7] ) begin
						outTemp[7] <= 7;
						CS <= OUT_0;
					end
					else begin
						CS <= CAL6;
						UPorDOWN <= UP;
					end
				end
				else begin
					CS <= OUT_0;
				end
			end	
			OUT_0: begin
				outTemp[ Irow[0] ] <= Icol[0];
				outTemp[ Irow[1] ] <= Icol[1];
				CS <= OUT;
			end
			OUT: begin
				out_valid <= 1;
				out <= outTemp[counter];
				counter <= counter + 1;
				if( counter > 7 ) begin
					CS <= IDLE;
					out_valid <= 0;
					out <= 0;
					counter <= 0;
				end
			end
		endcase
	end
end

always_comb begin
	NS = CS;
	IdiaP_temp = 0;
	IdiaM_temp = 0;
	case( CS )
		IDLE: begin
			if( in_valid ) begin
				IdiaP_temp = in_col + in_row;
				IdiaM_temp = 7 + in_row - in_col;
				NS = GET0;
			end
		end
		GET1: begin
			IdiaP_temp = in_col + in_row;
			IdiaM_temp = 7 + in_row - in_col;
		end
	endcase
end
	
		


endmodule