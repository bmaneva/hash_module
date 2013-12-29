#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
#include "sha1/sha1.h"
#include "md5/md5.h"
#include "xor/xor.h"

#define DEVICE_NAME "hashdev"
#define BUF_LEN 1024

static int major;
static int device_opened = 0;
static char msg[BUF_LEN];
static char *msg_Ptr;

static char digest_buff[256];
static char *digest;
static unsigned char md5digest[128];
unsigned int xorh;

static int device_open(struct inode *inode, struct file *file)
{
    if (device_opened)
        return -EBUSY;

    device_opened++;
    try_module_get(THIS_MODULE);

    return 0;
}

static int device_release(struct inode *inode, struct file *file)
{
    device_opened--;
    module_put(THIS_MODULE);
    return 0;
}

static ssize_t device_read(struct file *filp, char *buffer,
        size_t length, loff_t * offset)
{
    int bytes_read = 0;

    if (*digest) {
        bytes_read = strlen(digest);
        copy_to_user(buffer, digest, bytes_read);
        memset(digest, 0, sizeof(digest_buff));
    }

    return bytes_read;
}

static unsigned shadigest[5];
static ssize_t device_write(struct file *filp, const char *buff,
        size_t len, loff_t * off)
{
    int i;
    memset(msg_Ptr, 0, sizeof(msg));
    copy_from_user(msg_Ptr, buff, len);
    memset(digest, 0, sizeof(digest_buff));

    switch (msg_Ptr[0]) {
    case 's':
        sha1(msg_Ptr + 1, len - 1, shadigest);
        for (i = 0; i < 5; ++i) {
            sprintf(digest + 8 * i, "%08x", shadigest[i]);
        }
        sprintf(digest + 8 * i, "\n");
        break;
    case 'm':
        md5(msg_Ptr + 1, len - 1, md5digest);
        for (i = 0; i < 16; ++i) {
            sprintf(digest + 2 * i, "%02x", md5digest[i]);
        }
        sprintf(digest + 2 * i, "\n");
        break;
    case 'x':
        xorh = xor(msg_Ptr + 1, len - 1);
        sprintf(digest, "%08x\n", xorh);
        break;
    }

    return len;
}

static struct file_operations fops = {
    .read = device_read,
    .write = device_write,
    .open = device_open,
    .release = device_release
};

int init_module(void)
{
    major = register_chrdev(0, DEVICE_NAME, &fops);

    if (major < 0) {
        printk(KERN_ALERT "Failed to register %s (%d)\n",
                DEVICE_NAME, major);
        return major;
    }

    printk(KERN_INFO "'mknod /dev/%s c %d 0'.\n",
            DEVICE_NAME, major);

    msg_Ptr = msg;
    digest = digest_buff;
    return 0;
}

void cleanup_module(void)
{
    unregister_chrdev(major, DEVICE_NAME);
    printk(KERN_ALERT "Hash device unregistered");
}
