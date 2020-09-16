`timescale 1ns/1ns

module tester();
	parameter inputWidth = 8;
	parameter outputWidth = 9;
	parameter testCount = 8;
	
	reg [0:inputWidth-1] inp;
	wire [outputWidth - 1:0] out, outnet;
	
	reg detected = 0;
	integer i;
	integer testFile, faultFile, dictionaryFile, status;
	real numOfFaults = 16;
	real numOfDetecteds = 0;
	real coverage = 0;
	reg[inputWidth - 1:0] testVector;
	reg[60*8:1] wireName;
	reg[testCount - 1:0] syndrome;
	reg stuckAtVal;
	
	fourFunc_net GUT 		(inp[0],inp[1],inp[2],inp[3],inp[4],inp[5],inp[6],inp[7],inp[8],inp[9],inp[10],inp[11],inp[12],
  inp[13],inp[14],inp[15],inp[16],inp[17],inp[18],inp[19],inp[20],inp[21],inp[22],inp[23],inp[24],inp[25],inp[26],
  inp[27],inp[28],inp[29]);
	fourFunc_net FUT	(inp[0],inp[1],inp[2],inp[3],inp[4],inp[5],inp[6],inp[7],inp[8],inp[9],inp[10],inp[11],inp[12],
  inp[13],inp[14],inp[15],inp[16],inp[17],inp[18],inp[19],inp[20],inp[21],inp[22],inp[23],inp[24],inp[25],inp[26],
  inp[27],inp[28],inp[29]);
	
	initial
	begin
		faultFile = $fopen ("fourFunc_net_fault.flt", "w");
		$FaultCollapsing(tester.FUT,"fourFunc_net_fault.flt");
		$fclose(faultFile);
		#10
		dictionaryFile = $fopen("fourFunc_net.dct", "w");
		faultFile = $fopen ("fourFunc_net_fault.flt", "r");
		while ( !$feof(faultFile))
		begin
			i = 0;
			status = $fscanf (faultFile, "%s s@%b\n", wireName, stuckAtVal);
			$InjectFault ( wireName, stuckAtVal);
			testFile = $fopen ("fourFunc_net.pat", "r");
			detected = 1'b 0;
			while ( !$feof(testFile))
			begin
				#30
				status = $fscanf (testFile, "%b\n", testVector);
				inp = testVector;
				#60;
				if (out != outnet)
				begin
					detected = 1'b 1;
					syndrome[i] = 1'b 1;
				end
				else
					syndrome[i] = 1'b 0;
				i = i + 1;
			end

      if (syndrome != 0)
			  numOfDetecteds = numOfDetecteds + 1;
      
			$fclose (testFile);
			$RemoveFault(wireName);
			$fwrite (dictionaryFile, "%s, %b \n", wireName, syndrome);
			#30;
		end
		coverage = numOfDetecteds / numOfFaults;
		$fwrite (dictionaryFile, "Coverage: %f\n", coverage);
		$fclose(dictionaryFile);		
		$stop;
	end
endmodule

