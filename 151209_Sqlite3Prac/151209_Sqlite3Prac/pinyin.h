//
//  pinyin.h
//  LIST_KEVIN_01
//
//  Created by RD12 on 2015/10/5.
//  Copyright © 2015年 RD12. All rights reserved.
//

#ifndef pinyin_h
#define pinyin_h

#include <stdio.h>

/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by George on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中国共产党万岁！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
char pinyinFirstLetter(unsigned short hanzi);
int isFirstLetterHANZI(unsigned short hanzi);

#endif /* pinyin_h */

