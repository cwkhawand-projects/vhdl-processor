vlib work

vcom -2008 ../../src/fdiv.vhd
vcom -2008 ../../src/uart_rx.vhd
vcom -2008 uart_rx_tb.vhd

vsim uart_rx_tb(Bench)

view signals
add wave *
add wave -radix unsigned /uart_rx_tb/uart_rx/count_bit
add wave /uart_rx_tb/uart_rx/State
add wave /uart_rx_tb/uart_rx/reg

run -all
wave zoom full