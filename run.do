
vlib work
vlog buffer.v dsp_tb.v DSP48A1.v reg_Async.v reg_Sync.v
vsim -voptargs=+acc work.dsp_tb
add wave *

run -all
