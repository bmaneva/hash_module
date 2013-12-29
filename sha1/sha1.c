/*
 *  sha1.c
 *
 *  Copyright (C) 1998, 2009
 *  Paul E. Jones <paulej@packetizer.com>
 *  All Rights Reserved
 *
 */

#include "sha1.h"

/*
 *  Define the circular shift macro
 */
#define CIRCULAR_SHIFT(bits,word) \
                ((((word) << (bits)) & 0xFFFFFFFF) | \
                ((word) >> (32-(bits))))

static unsigned message_digest[5]; /* Message Digest (output)          */
static unsigned length_low;        /* Message length in bits           */
static unsigned length_high;       /* Message length in bits           */
static unsigned char message_block[64]; /* 512-bit message blocks      */
static int message_block_index;    /* Index into message block array   */

static const unsigned K[] =            /* Constants defined in SHA-1   */
{
    0x5A827999,
    0x6ED9EBA1,
    0x8F1BBCDC,
    0xCA62C1D6
};

static int         t;                  /* Loop counter                 */
static unsigned    temp;               /* Temporary word value         */
static unsigned    W[80];              /* Word sequence                */
static unsigned    A, B, C, D, E;      /* Word buffers                 */


static void set_w(void)
{
    /*
     *  Initialize the first 16 words in the array W
     */

    for(t = 0; t < 16; t++)
    {
        W[t] = ((unsigned)  message_block[t * 4]) << 24;
        W[t] |= ((unsigned) message_block[t * 4 + 1]) << 16;
        W[t] |= ((unsigned) message_block[t * 4 + 2]) << 8;
        W[t] |= ((unsigned) message_block[t * 4 + 3]);
    }

    for(t = 16; t < 80; t++)
    {
       W[t] = CIRCULAR_SHIFT(1, W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16]);
    }
}

static void main_loop(void)
{
    for (t = 0; t < 80; ++t) {
        if (t < 20)
            temp =  CIRCULAR_SHIFT(5, A) +
                    ((B & C) | ((~B) & D)) + E + W[t] + K[0];
        else if (t < 40)
            temp = CIRCULAR_SHIFT(5, A) + (B ^ C ^ D) + E + W[t] + K[1];
        else if (t < 60)
            temp = CIRCULAR_SHIFT(5, A) +
                    ((B & C) | (B & D) | (C & D)) + E + W[t] + K[2];
        else
            temp = CIRCULAR_SHIFT(5, A) + (B ^ C ^ D) + E + W[t] + K[3];

        E = D;
        D = C;
        C = CIRCULAR_SHIFT(30,B);
        B = A;
        A = temp;
    }
}
/*
 * This function will process the next 512 bits of the message
 * stored in the message_block array.
 *
 */
static void process_block(void)
{
    set_w();
    A = message_digest[0];
    B = message_digest[1];
    C = message_digest[2];
    D = message_digest[3];
    E = message_digest[4];

    main_loop();
    message_digest[0] = (message_digest[0] + A) & 0xFFFFFFFF;
    message_digest[1] = (message_digest[1] + B) & 0xFFFFFFFF;
    message_digest[2] = (message_digest[2] + C) & 0xFFFFFFFF;
    message_digest[3] = (message_digest[3] + D) & 0xFFFFFFFF;
    message_digest[4] = (message_digest[4] + E) & 0xFFFFFFFF;

    message_block_index = 0;
}

__attribute__((regparm(3)))
void sha1(const unsigned char *data, unsigned len, unsigned *digest) {
    length_low             = 0;
    length_high            = 0;
    message_block_index    = 0;

    message_digest[0]      = 0x67452301;
    message_digest[1]      = 0xEFCDAB89;
    message_digest[2]      = 0x98BADCFE;
    message_digest[3]      = 0x10325476;
    message_digest[4]      = 0xC3D2E1F0;

    /*
      Accept an array of octets as the next portion of
      the message
    */
    while(len--)
    {
        message_block[message_block_index++] =  (*data & 0xFF);
        length_low += 8;
        length_low &= 0xFFFFFFFF;
        if (length_low == 0)
        {
            length_high++;
            length_high &= 0xFFFFFFFF;
        }
        if (message_block_index == 64)
        {
            process_block();
        }
        data++;
    }

    /* According to the standard, the message must be padded to an even
     *  512 bits.  The first padding bit must be a '1'.  The last 64
     *  bits represent the length of the original message.  All bits in
     *  between should be 0.  This function will pad the message
     *  according to those rules by filling the message_block array
     *  accordingly.  It will also call process_block()
     *  appropriately.  When it returns, it can be assumed that the
     *  message digest has been computed.

     *  Check to see if the current message block is too small to hold
     *  the initial padding bits and length.  If so, we will pad the
     *  block, process it, and then continue padding into a second
     *  block.
     */
    if (message_block_index > 55)
    {
        message_block[message_block_index++] = 0x80;
        while(message_block_index < 64)
        {
            message_block[message_block_index++] = 0;
        }
        process_block();
        while(message_block_index < 56)
        {
            message_block[message_block_index++] = 0;
        }
    }
    else
    {
        message_block[message_block_index++] = 0x80;
        while(message_block_index < 56)
        {
            message_block[message_block_index++] = 0;
        }
    }

    /*
     *  Store the message length as the last 8 octets
     */
    message_block[56] = (length_high >> 24) & 0xFF;
    message_block[57] = (length_high >> 16) & 0xFF;
    message_block[58] = (length_high >> 8) & 0xFF;
    message_block[59] = (length_high) & 0xFF;
    message_block[60] = (length_low >> 24) & 0xFF;
    message_block[61] = (length_low >> 16) & 0xFF;
    message_block[62] = (length_low >> 8) & 0xFF;
    message_block[63] = (length_low) & 0xFF;

    process_block();

    digest[0] = message_digest[0];
    digest[1] = message_digest[1];
    digest[2] = message_digest[2];
    digest[3] = message_digest[3];
    digest[4] = message_digest[4];
}
