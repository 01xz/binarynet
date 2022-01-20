IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave
PYTHON   = python3

.PHONY: sim
sim: mem vcd
	@echo "All done!"

.PHONY: vcd
vcd: control_and_fetch1_tb.vcd
	@echo "Waveform generation done!"

control_and_fetch1_tb.vcd: control_and_fetch1_tb.out
	@echo "Waveform generation in progress ..."
	$(VVP) $^

control_and_fetch1_tb.out: control_and_fetch1_tb.v sram_sim.v ../rtl/control_and_fetch1.v
	@echo "Simulation in progress ..."
	$(IVERILOG) -o $@ -s control_and_fetch1_tb $^

.PHONY: mem
mem: gen_mem.py
	@echo "Memory file generation in progress ..."
	$(PYTHON) $^ > mem.txt

.PHONY: clean
clean:
	rm -f *.out
	rm -f *.vcd
	rm -f *.txt
