bitonic:
	verilator -Wall --trace --cc rtl/bitonic.sv --exe bench/bitonic_tb.cpp --top-module bitonic4
	$(MAKE) -C obj_dir -f Vbitonic.mk Vbitonic

run_bitonic: bitonic
	./obj_dir/Vbitonic
