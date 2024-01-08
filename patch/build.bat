cp code_template.bin code.bin
make clean && make
python build.py
lunarIPS.exe -CreateIPS code.ips code_template.bin code.bin
rem cp code.bin f:/luma/titles/00040000001d9300/code.bin
pause