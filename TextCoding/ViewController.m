//
//  ViewController.m
//  TextCoding
//
//  Created by NS on 2017/9/23.
//  Copyright © 2017年 Decin. All rights reserved.
//

#import "ViewController.h"

#import "uchardet.h"

#define NUMBER_OF_SAMPLES   (2048)

@interface ViewController ()
{
    NSString *_encodeStr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *pathaa = [[NSBundle mainBundle] pathForResource:@"TextCoding" ofType:@"txt"];
    
    int result = [self haveTextBianMa:[pathaa UTF8String]];
    CFStringEncoding cfEncode = 0;
    
    if (result == 0) {
        
        if ([_encodeStr isEqualToString:@"gb18030"]) {
            cfEncode= kCFStringEncodingGB_18030_2000;
            
        }else if([_encodeStr isEqualToString:@"Big5"]){
            cfEncode= kCFStringEncodingBig5;
            
        }else if([_encodeStr isEqualToString:@"UTF-8"]){
            cfEncode= kCFStringEncodingUTF8;
            
        }else if([_encodeStr isEqualToString:@"Shift_JIS"]){
            cfEncode= kCFStringEncodingShiftJIS;
            
        }else if([_encodeStr isEqualToString:@"windows-1252"]){
            cfEncode= kCFStringEncodingWindowsLatin1;
            
        }else if([_encodeStr isEqualToString:@"x-euc-tw"]){
            cfEncode= kCFStringEncodingEUC_TW;
            
        }else if([_encodeStr isEqualToString:@"EUC-KR"]){
            cfEncode= kCFStringEncodingEUC_KR;
            
        }else if([_encodeStr isEqualToString:@"EUC-JP"]){
            cfEncode= kCFStringEncodingEUC_JP;
            
        }
        
    }
    
    
    
    NSError *err;
    NSString *str = [NSString stringWithContentsOfFile:pathaa encoding:CFStringConvertEncodingToNSStringEncoding(cfEncode) error:&err];
    NSString *st = [str substringToIndex:100];
    
    NSLog(@"%@", st);
}


- (int)haveTextBianMa:(const char *)strTxtPath {
    
    
    FILE* file;
    char buf[NUMBER_OF_SAMPLES];
    size_t len;
    uchardet_t ud;
    
    /* 打开被检测文本文件，并读取一定数量的样本字符 */
    file = fopen(strTxtPath, "rt");
    len = fread(buf, sizeof(char), NUMBER_OF_SAMPLES, file);
    fclose(file);
    
    /* 通过样本字符分析文本编码 */
    ud = uchardet_new();
    if(uchardet_handle_data(ud, buf, len) != 0) /* 如果样本字符不够，那么有可能导致分析失败 */
    {
        printf("分析编码失败！\n");
        return -1;
    }
    uchardet_data_end(ud);
    
    _encodeStr = [NSString stringWithUTF8String:uchardet_get_charset(ud)];
    printf("文本的编码方式是%s。\n", uchardet_get_charset(ud));  /* 获取并打印文本编码 */
    uchardet_delete(ud);
    
    
    return 0;
    
}


@end
