#if [ ! -f "$2" ]; then
    gcc -fverbose-asm -m32 -march=i386 -S -g -O0 $1 -o $1.s
    ./inline.py $1.s
    head -n $(calc $(cat $1.s.2 | grep -n "\.Letext0:" | awk '{gsub(":", " "); print $1}')-1) $1.s.2 | awk '!/^\t.cfi|^\t.loc 1|^#/' > $2
    rm $1.s
    rm $1.s.2

#fi
