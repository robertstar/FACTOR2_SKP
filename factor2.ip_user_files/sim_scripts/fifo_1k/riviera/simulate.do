onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+fifo_1k -L xpm -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.fifo_1k xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {fifo_1k.udo}

run -all

endsim

quit -force
