function b = SetupBluetooth(name)
close all;
instrhwinfo('Bluetooth', name)
global b;
b = Bluetooth(name, 1)
fopen(b)


