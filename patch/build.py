import os,sys,struct,binascii

redirect_addr=0x17698c   # overwrites existing add r0, r5, #8, will re-add that in the patch code
patch_addr=0x34a600
newbranch=0xeb000000+((patch_addr-redirect_addr)//4)-8
#newbranch=0xe1a00000

# make sure this is the right codebin for Atooi Collection. there was never any other region or version of this title.
with open("code.bin","rb") as f:
	check=f.read()
if binascii.crc32(check) != 0x654e299a:
	print("ERROR: Atooi Collection's code.bin is incorrect. Make sure code_template.bin has crc32 checksum 0x654e299a")
	print("       Note this repo code will contain null codebins for copyright reasons - you add the correct codebin!")
	sys.exit(0)

# gather compiled patch data
with open("chickenfix.bin","rb") as f:
	buff=f.read()
	
# add redirect address and patch to codebin. later, use the diff between code.bin and code_template.bin to create an ips patch
with open("code.bin","rb+") as f:
	f.seek(redirect_addr-0x100000)
	f.write(struct.pack("<I", newbranch))
	f.seek(patch_addr-0x100000)
	f.write(buff)