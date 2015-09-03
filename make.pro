routines = ['idlPvVersion', $
	'idlPvInitialize']
cflags = '-I/usr/local/include/pvapi -D_LINUX -D_x64'
lflags = '-L/usr/local/lib -lPvAPI'
input_directory = './'
make_dll, 'idlpvapi', routines, $
	extra_cflags=cflags, extra_lflags=lflags, $
	input_directory=input_directory, /show_all_output, /verbose
