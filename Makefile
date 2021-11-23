bitonic:
	verilator -Wall --trace --cc rtl/bitonic.sv --exe bench/bitonic_tb.cpp
	$(MAKE) -C obj_dir -f Vbitonic.mk Vbitonic
