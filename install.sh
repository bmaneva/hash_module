rmmod hashmod.ko
insmod hashmod.ko
rm -f /dev/hashdev
mknod /dev/hashdev c 251 0
chmod 777 /dev/hashdev
echo -n m$1 > /dev/hashdev
cat /dev/hashdev
echo -n $1 | md5sum
echo -n s$1 > /dev/hashdev
cat /dev/hashdev
echo -n $1 | sha1sum
echo -n x$1 > /dev/hashdev
cat /dev/hashdev
gcc -DTEST xor/xor.c xor/test.c -o xortest
./xortest $1
