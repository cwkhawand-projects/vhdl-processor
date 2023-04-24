vlib work

vcom -2008 ../../src/fdiv.vhd
vcom -2008 ../../src/uart_tx.vhd
vcom -2008 uart_tx_tb.vhd

vsim uart_tx_tb(Bench)

view signals
add wave *
add wave -radix unsigned /uart_tx_tb/uart_tx/count_bit
add wave /uart_tx_tb/uart_tx/State
add wave /uart_tx_tb/uart_tx/reg

run -all
wave zoom full