//
//  CosjiServerHelper.m
//  CosjiApp
//
//  Created by Darsky on 13-9-27.
//  Copyright (c) 2013年 Cosji. All rights reserved.
//

#import "CosjiServerHelper.h"
#import "JSONKit.h"

#define login @"http://192.168.1.110"
#define shouye @"/mall/getAll"
#define httpAdd @"http://rest.cosji.com"
#define jiuyuan @"/product/ship/"
#define allItems @"/taobao/category/"

@implementation CosjiServerHelper
static CosjiServerHelper *shareCosjiServerHelper=nil;
+(CosjiServerHelper*)shareCosjiServerHelper
{
    if (shareCosjiServerHelper == nil) {
        shareCosjiServerHelper = [[super allocWithZone:NULL] init];
    }
    return shareCosjiServerHelper;
}

-(void)jsonTest
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",httpAdd,jiuyuan];
    NSLog(urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
        
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSMutableString *string=[[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *jsonString=[string stringByReplacingOccurrencesOfString:@"ok" withString:@""];
    NSMutableDictionary *tmpDic =[jsonString objectFromJSONString];
  //  NSLog(jsonString);
    if (tmpDic==nil) {
        NSLog(@"json error");
    }
}
-(NSDictionary*)getJsonDictionary:(NSString*)orderString
{
    NSString *urlString =[NSString stringWithFormat:@"%@%@",httpAdd,orderString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self getEncodedString:urlString]]];
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSMutableString *string=[[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSString *jsonString=[string stringByReplacingOccurrencesOfString:@"ok" withString:@""];
    NSDictionary *tmpDic =[jsonString objectFromJSONString];
    if (tmpDic==nil) {
        NSLog(@"json error!!!!:%@",jsonString);
        return nil;
    }else{
        NSLog(@"%@",jsonString);
        return tmpDic;
    }

}
-(NSString*)getEncodedString:(NSString*)urlString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)urlString,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

@end
