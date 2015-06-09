// http://www.cocoadev.com/index.pl?BaseSixtyFour
#import <Foundation/Foundation.h>
@interface NSData (Base64)

+(NSString *)base64Encode:(NSString *)str;
+(NSString *)base64Decode:(NSString *)str;

+ (id)dataWithBase64EncodedString:(NSString *)string;     //  Padding '=' characters are optional. Whitespace is ignored.
- (NSString *)base64Encoding;



@end
