#ifndef __SHA1_H__
#define __SHA1_H__

__attribute__((regparm(3)))
void sha1(const unsigned char *data, unsigned len, unsigned *digest);

#endif
