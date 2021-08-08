//
//  main.c
//  dyld
//
//  Created by xindong on 2019/11/30.
//

#include <stdio.h>
#import <Foundation/Foundation.h>
#include "dyld.h"

static uintptr_t __slide(void) {
    static uintptr_t slide = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uint32_t count = _dyld_image_count();
        for (int i = 0; i < count; i++) {
            const struct mach_header *h = _dyld_get_image_header(i);
            if (h->filetype == MH_EXECUTE) {
                slide = _dyld_get_image_vmaddr_slide(i);
                break;
            }
        }
    });
    return slide;
}

static const struct mach_header *__header(void) {
    static const struct mach_header *header = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uint32_t count = _dyld_image_count();
        for (int i = 0; i < count; i++) {
            const struct mach_header *h = _dyld_get_image_header(i);
            if (h->filetype == MH_EXECUTE) {
                header = h;
                break;
            }
        }
    });
    return header;
}

int main(int argc, const char * argv[]) {
    const char *filePath = argv[1];
    printf("%s", filePath);
    
    const char* apple[] = {"/Users/momo/Desktop"};
    dyld::_main(__header(), __slide(), argc, argv, NULL, apple);
    
    return 0;
}
