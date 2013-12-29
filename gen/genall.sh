for algo in md5 sha1 xor
do
    ./genasm.sh ../$algo/$algo.c ../$algo/$algo-i386.S
done
