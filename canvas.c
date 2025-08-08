#include "canvas.h"
#include "sqlcarto.h"


// 内存地址转换成16进制字符串
text* address_to_hex(void* address) {
    char buf[19];
    sprintf(buf, "%016llX", (unsigned long long)address);
    return cstring_to_text(buf);
}


// 从16进制字符串获取内存地址
void* hex_to_address(text* hex) {
    unsigned long long address = strtoull(text_to_cstring(hex), NULL, 16);
    return (void*)address;
}

