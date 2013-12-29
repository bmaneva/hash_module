static const char ar[] = { 0x1F, 0xAF, 0x55, 0x4B,
                           0xF5, 0xAA, 0x11, 0x77,
                           0x00, 0xFF, 0x5A, 0x49,
                           0x81, 0x99, 0x10, 0xDD };
#ifndef TEST
__attribute__((regparm(3)))
#endif
unsigned int xor(char *data, unsigned int len)
{
    unsigned int hash = (unsigned int)-1;
    unsigned char xor = 0xF0;
    unsigned int i = 0;
    unsigned int shiftpos = 8;

    while (len) {
        len--;

        xor += (data[len] ^ ar[i]);
        hash ^= ((unsigned int)(xor) << shiftpos);

        ++i;
        if (i == sizeof(ar))
            i = 0;

        shiftpos += 8;
        if (shiftpos == 8 * sizeof(hash))
            shiftpos = 8;
    }

    return hash;
}
