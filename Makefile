bitonic:
	verilator -Wall --trace --cc rtl/bitonic.sv --exe bench/bitonic_tb.cpp --top-module bitonic4
	$(MAKE) -C obj_dir -f Vbitonic.mk Vbitonic

sorter:
	verilator -Wall --trace --cc rtl/sorter.sv rtl/bitonic.sv --exe bench/sorter_tb.cpp --top-module sorter
	$(MAKE) -C obj_dir -f Vsorter.mk Vsorter

run_bitonic: bitonic
	./obj_dir/Vbitonic

run_sorter: sorter
	./obj_dir/Vsorter
