#include "Vsorter.h"
#include <iostream>
#include <memory>
#include <verilated.h>
#include <verilated_vcd_c.h>

const int MAX_SIM_TIME = 30;
vluint64_t sim_time = 0;

int main(int argc, char *argv[]) {
  std::unique_ptr<Vsorter> dut = std::make_unique<Vsorter>();

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("waveform.vcd");

  for (int i = 0; i < 8; i++) {
    dut->din[i] = i;
  }

  for (sim_time = 0; sim_time < MAX_SIM_TIME; sim_time++) {
    dut->start = (sim_time / 2 == 1);
    dut->clk ^= 1;
    dut->eval();
    m_trace->dump(sim_time);
  }

  m_trace->close();
  return 0;
}
