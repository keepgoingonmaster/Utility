cp MSIReg.reg MSIReg.reg.orig 
diff MSIReg.reg MSIReg.reg.orig 

sed -i  's|\[HKEY_LOCAL_MACHINE\\SOFTWARE\\MicroStrategy\\Diagnostics\\Log2\\Cube Server\\Trace\]|&\n"cube"=""|' MSIReg.reg

sed -i  's|\[HKEY_LOCAL_MACHINE\\SOFTWARE\\MicroStrategy\\Log Destinations\\LicenseSummary\]|\[HKEY_LOCAL_MACHINE\\SOFTWARE\\MicroStrategy\\Log Destinations\\cube\]\n"MaxSize"=dword:00032000\n"Type"=dword:00000003\n\n&|' MSIReg.reg

sed -i  's|\[HKEY_LOCAL_MACHINE\\SOFTWARE\\MicroStrategy\\Diagnostics\\Log2\\Report Server\\Cache Trace\]|&\n"report"=""|' MSIReg.reg

sed -i  's|\[HKEY_LOCAL_MACHINE\\SOFTWARE\\MicroStrategy\\Log Destinations\\LicenseSummary\]|\[HKEY_LOCAL_MACHINE\\SOFTWARE\\MicroStrategy\\Log Destinations\\report\]\n"MaxSize"=dword:00032000\n"Type"=dword:00000003\n\n&|' MSIReg.reg

diff MSIReg.reg MSIReg.reg.orig
