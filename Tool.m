//
//  Tool.m
//  Ecommunity
//
//  Created by TONG on 2019/1/16.
//  Copyright © 2019 IntelligentAntenna. All rights reserved.
//

#import "Tool.h"
#import "MD5.h"
#import "ECRMFoundMessageContent.h"
#import <RongIMKit/RongIMKit.h>

@implementation Tool



#pragma mark - 生成签名
+(NSString *)createSignWithDic:(NSDictionary*)dic{
    
    NSArray *keyArray = [dic allKeys];
    keyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString * strM = [NSMutableString string];
    for (int index = 0; index < keyArray.count; index ++) {
        NSString *key = keyArray[index];
        if (index < keyArray.count - 1) {
            [strM appendFormat:@"%@=%@&",key,dic[key]];
        }else {
            [strM appendFormat:@"%@=%@",key,dic[key]];
        }
    }
    NSString * md5_parameter = [MD5 md532BitLower:strM];
    return [MD5 md532BitLower:[NSString stringWithFormat:@"%@%@",md5_parameter,SING_KEY]];
}

#pragma mark - 生成签名
+(NSString *)createSignWithDic1:(NSDictionary*)dic{
    
    NSArray *keyArray = [dic allKeys];
    keyArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString * strM = [NSMutableString string];
    for (int index = 0; index < keyArray.count; index ++) {
        NSString *key = keyArray[index];
        if (index < keyArray.count - 1) {
            [strM appendFormat:@"%@=%@&",key,dic[key]];
        }else {
            [strM appendFormat:@"%@=%@",key,dic[key]];
        }
    }
    NSString * md5_parameter = [MD5 md532BitLower:strM];
    return md5_parameter;
}

/**
 *  字典的Value为nil的情况下，把Value替换为空字符串
 *
 *  @param dic 获取到的字典
 *
 *  @return 返回自已Value不为nil的字典
 */
+(NSDictionary *)replaceKey:(NSDictionary *)dic {
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    for (NSString *key in dic) {
        if ((NSNull *)dic[key] == [NSNull null]) {
            [dic setValue:@"" forKey:key];
        }
    }
    return mutableDic;
}


/**
 *  中心点弹出动画
 *
 *  @param view 给定一个View
 */
+(void)centerAnimation:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.15;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:1];
    [view.layer addAnimation:animation forKey:nil];     //@"scale-layer"
}

//隐藏手机中间4位
+(NSString *)changeOnePhoneNumWithPhoneStr:(NSString*)phoneString{
    
    if(![Tool isMobile:phoneString] ||phoneString.length != 11) return phoneString;
    
    NSMutableString * muStr = [NSMutableString stringWithString:phoneString];
    
    [muStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    return muStr;
}

//打电话
+(void)callNumber:(NSString *)phoneNum{
    if (phoneNum) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]]];
    }else{
        [UIWindow showTips:@"电话号码为nil"];
    }
}

//图片转Base64的字符串
+(NSString *)getImgFilesString:(NSArray *)imageArray{
    NSMutableArray *base64ImageStrArr = [NSMutableArray array];
    for ( UIImage *image in imageArray) {
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        if (data.length > 1024 * 1024) {
            //1M以及以上
            data = UIImageJPEGRepresentation(image, 0.1);
        }else if (data.length > 512 * 1024) {
            //0.5M-1M
            data = UIImageJPEGRepresentation(image, 0.5);
        }else if (data.length > 200 * 1024){
            //0.25M-0.5M
            data = UIImageJPEGRepresentation(image, 0.9);
        }
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [base64ImageStrArr addObject:encodedImageStr];
    }
    return [base64ImageStrArr componentsJoinedByString:@","];
}

//更改textFiled的placeHolder的字体颜色，大小
+(void)changePlaceHolder:(UITextField *)textFiled Color:(UIColor *)color Font:(CGFloat )fontSize {
    
    if ([Tool isBlank:textFiled.placeholder]) {
        
        NSAttributedString *placeholderString = [[NSAttributedString alloc]initWithString:textFiled.placeholder attributes:@{NSFontAttributeName: fontSize ? FONT(fontSize):textFiled.font,NSForegroundColorAttributeName:color}];
        
        textFiled.attributedPlaceholder = placeholderString;
        
    }
 
    
}

//加载网络图片
+(void)loadImageView:(UIImageView *)imageView withURL:(NSString *)imageUrlString {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrlString]];
    [imageView sd_setImageWithURL:url placeholderImage:k_Placeholder_image];
}

//解析UTF8格式Json
+(NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    
    return str;
}


//json格式化为字符串
+(NSString*)ObjectTojsonString:(id)object

{
    
    NSString *jsonString = [[NSString
                             
                             alloc]init];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization
                        
                        dataWithJSONObject:object
                        
                        options:NSJSONWritingPrettyPrinted
                        
                        error:&error];
    
    if (! jsonData) {
        
        NSLog(@"error: %@", error);
        
    } else {
        
        jsonString = [[NSString
                       
                       alloc] initWithData:jsonData
                      
                      encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString
                               
                               stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    [mutStr replaceOccurrencesOfString:@" "
     
                            withString:@""
     
                               options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    [mutStr replaceOccurrencesOfString:@"\n"
     
                            withString:@""
     
                               options:NSLiteralSearch range:range2];
    NSRange range3 = {0, mutStr.length};
    NSString * str = @"\\";
    [mutStr replaceOccurrencesOfString:str withString:@"" options:NSLiteralSearch range:range3];
    return mutStr;
}

/**
 url解码
 */
+(NSString *)decodeString:(NSString*)encodedString {
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,(__bridge CFStringRef)encodedString,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/**
 json字符串转字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    if ([Tool stringContainsEmoji:jsonString]) {
        //如果json返回有表情，不进行json解析
        return nil;
    }
    
    if (![jsonString hasPrefix:@"{\""]) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/**
 json字符串转数组
 */
+(NSArray *)arrayWithJsonString:(NSString *)jsonString{
    if (![Tool isBlank:jsonString]) {
        return nil;
    }
    
    if ([Tool stringContainsEmoji:jsonString]) {
        //如果json返回有表情，不进行json解析
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSArray *array = [NSJSONSerialization

    JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers

    error:&err];
 
    
    if(err)
    {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}


///URl链接截取转字典（参数）
+(NSDictionary *)dictionarytToUrlString:(NSString *)urlStr
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//传入的文字
+(CGFloat)checkLableTextHeight:(NSString *)text width:(CGFloat )width font:(UIFont *)font {
    
    CGSize lableSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return lableSize.height + 10;
}

//获取文字的宽度
+ (CGFloat)getStringWidthWithText:(NSString *)text font:(UIFont *)font viewHeight:(CGFloat)height {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, height);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.width);
}
 

//清除web缓存
+(void)clearWebCache {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //缓存web清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


/**
 更换窗口根视图

 @param controller 把本视图控制器设置为根视图控制器
 */
+(void)changeWindowRootViewController:(UIViewController *)controller{
    
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    window.rootViewController = controller;
}

/**
 限制TextField的输入长度
 
 @param numString 输入的字符text
 @param range 范围
 @param string 替换字符串
 @param stringLenght 控制的长度
 @return 范围中返回NO,达到限制范围返回YES
 */
+ (BOOL)limitTheLength:(NSString *)numString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(NSInteger)stringLenght{
    if (string.length == 0){
        return YES;
    }
    NSInteger existedLength = numString.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > stringLenght) {
        return NO;
    }
    return YES;
}

/**
 更改数组中某个下标的状态
 
 @param array 传进的数组
 @param index 需要改状态的下标
 */
+(void)replaceObiect:(NSMutableArray *)array index:(NSInteger)index {
    
    for (int i = 0; i < array.count; i++) {
        [array replaceObjectAtIndex:i withObject:@0];
    }
    [array replaceObjectAtIndex:index withObject:@1];
}



/**
 CGFloat保留几位小数
 
 @param value CGFloat数值
 @return   CGFloat保留几位小数
 */
+(float)keepTwoDecimal:(CGFloat)value{
    
    return [[NSString stringWithFormat:@"%.2f",value] floatValue];
    
}


/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;  //设置行间距
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

/**
设置固定字间距文本

@param WordSpace 字间距
@param text 文本内容
@param label 要设置的label
*/
+(void)setWordSpace:(CGFloat)WordSpace withText:(NSString *)text inLabel:(UILabel *)label{
    if (!text || !label) {
        return;
    }
    //富文本属性
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    //字间距(字符串)
    textDict[NSKernAttributeName] = @(WordSpace);
    label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:textDict];
}



/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}
 
/*
 control 是要设置渐变字体的控件   bgVIew是control的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
 
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = control.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = control.layer;
    control.frame = gradientLayer1.bounds;
}
 

/**
 跳转权限管理
 */
+(void)goToSetting {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }
}


/**
总共秒数转换成时分秒
 */
+(NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;

    int minutes = (totalSeconds / 60) % 60;

    int hours = totalSeconds / 3600;

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


/**
 获取视频／音频文件的总时长(秒)

 @param URL 音频和视频URl
 */
+(CGFloat)getFileDuration:(NSURL*)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:URL options:opts];
    NSUInteger durationSeconds = 0;
    durationSeconds = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
    return durationSeconds;
}



/**
 *  根据图片url获取图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef =     CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    if (imageSourceRef) {
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
      if (imageProperties != NULL) {
          CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
          if (widthNumberRef != NULL) {
              CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
          }
          CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
          if (heightNumberRef != NULL) {
            CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
        }
        CFRelease(imageProperties);
    }
    CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}



/**
 获取视频的大小

 @param path 视频的本地地址
 */
+(CGFloat)getFileVideoSize:(NSString *)path {
    
    CGFloat fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return fileSize;
}


/// 根据url获取视频第一帧图片
/// @param videoURL 视频url
/// @param time 转化时长
/// @param completeBlock 完成block
+(void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time completeBlock:(void(^)(id objc))completeBlock{

    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        NSParameterAssert(asset);
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;

        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];

        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);

          UIImage * thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
            completeBlock(thumbnailImage);
        });
    }
}


/**
  图片字符串转数组
 */
+(NSArray *)imageStringToArray:(NSString *)imageString {
    
    if (imageString.length == 0) {
        return @[];
    }else{
       return [[imageString substringToIndex:imageString.length - 1] componentsSeparatedByString:@","];
    }
}

/**
 图片字符串转数组,末尾没有逗号
*/
+(NSArray *)imageStringToArray1:(NSString *)imageString {
    
    if (imageString.length == 0) {
        return @[];
    }else{
       return [[imageString substringToIndex:imageString.length] componentsSeparatedByString:@","];
    }
}


/**
 label拼接图片icon

 @param string label内容
 @param icon 拼接的图片icon
 @param size icon大小
 @param index 插入到文字内容的下标
 @return 图文label
 */
+(NSMutableAttributedString *)changeString:(NSString *)string icon:(UIImage *)icon bounds:(CGRect )size atIndex:(NSInteger)index{
    
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:[@" " stringByAppendingString:string]];
    
    /** 添加图片到指定的位置 */
    NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
    // 表情图片
    attchImage.image = icon;
    // 设置图片大小
    attchImage.bounds = size;
    
    NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
    
    [attriStr insertAttributedString:stringImage atIndex:index];
    
    return attriStr;
    
}


@end


@implementation Tool (Accout)

//是否登录
+(BOOL)isLogining{
    NSDictionary * userinfo = [k_DEFAULTS objectForKey:EC_KEY_USERINFO];
    if (userinfo) return YES;
    return NO;
}

//是否有默认房屋
+(BOOL)isDefaultHouse {
    
    if (![k_DEFAULTS objectForKey:EC_KEY_DEFAULTHOUSEINFO]) {
        return NO;
    }
    return YES;
}

//获取版本号
+(NSString *)getVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    return version;
}

//获取ssoid
+(NSString *)getSsoid{
    if (![k_DEFAULTS objectForKey:EC_KEY_USERINFO]) {
        return @"0";
    }
    return [k_DEFAULTS objectForKey:EC_KEY_USERINFO][@"ssoid"];
    
}



@end



@implementation Tool (Validation)

//是否第一次启动程序
+(BOOL)isFirstStartUp {

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    if (![k_DEFAULTS objectForKey:EC_KEY_VERSION]) {
        [k_DEFAULTS setValue:version forKey:EC_KEY_VERSION];
        [k_DEFAULTS synchronize];

        return YES;
    }else {
        if (![[k_DEFAULTS objectForKey:EC_KEY_VERSION] isEqualToString:version]) {
            [k_DEFAULTS setValue:version forKey:EC_KEY_VERSION];
            [k_DEFAULTS synchronize];
            return YES;
        }
    }
    return NO;
}

//字符串是否包含中文
+ (BOOL)isChinese:(NSString *)string {
    for(int i=0; i< [string length];i++)
    {
        int a = [string characterAtIndex:i];
        
        if( a > 0x4e00 && a < 0x9fff)
        {
            NSLog(@"a === %c",a);
            return YES;
        }
        
    }
    return NO;
}

//字符串是否为邮箱
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//字符串是否为浮点型
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//字符串是否为移动电话
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    
    //NSString *pattern = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSString *pattern = @"^1[0-9]{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:mobileNumbel];
    return isMatch;
}

//字符串是否为银行卡
+ (BOOL)isValidateBankCardNumber:(NSString *)bankCardNumber {
    BOOL flag;
    if (bankCardNumber.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{15,30})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

//字符串是否为身份证
+ (BOOL)isCheckUserIdCard:(NSString *)idCard {
    //NSString *pattern = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSString *pattern = @"^(\\d{17})(\\d|[xX])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}

//字符串是否符合密码格式
+ (BOOL)isValidatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

// 检查字符串是否全由指定字符(如空格)组成
+(BOOL)checkupString:(NSString *)string WithCharacter:(char)ch
{
    const char *s =[string cStringUsingEncoding:NSUTF8StringEncoding];
    BOOL flag = YES;
    while (*s) {
        if ( *s != ch && *s != '\0')
        {
            flag = NO;
        };
        s++;
    }
    return flag;
}

// 判断是字符是否null类型
+ (BOOL)isBlank:(NSString *)str
{
 
    if (str == nil || str == NULL) {
        return NO;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([str isEqualToString:@"<null>"]) {
        return NO;
    }
    if ([str isEqualToString:@"(null)"]) {
        return NO;
    }
    if ([str isEqualToString:@""]) {
        return NO;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

//判断是否输入了emoji 表情
+ (BOOL)stringContainsEmoji:(NSString *)string{
    
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
             
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
 
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;

                if (0x1d000 <= uc && uc <= 0x1f77f) {

                    returnValue = YES;

                }

            }

        } else if (substring.length > 1) {

            const unichar ls = [substring characterAtIndex:1];

            if (ls == 0x20e3) {

                returnValue = YES;

            }
        } else {
            
            if (0x2100 <= hs && hs <= 0x27ff) {

                returnValue = YES;

            } else if (0x2B05 <= hs && hs <= 0x2b07) {

                returnValue = YES;

            } else if (0x2934 <= hs && hs <= 0x2935) {

                returnValue = YES;

            } else if (0x3297 <= hs && hs <= 0x3299) {

                returnValue = YES;

            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {

                returnValue = YES;

            }else if (hs == 0x200d){

                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

@end


@implementation Tool(Price)

/**
 *  转换价格显示样式
 *
 *  @param price 传入价格字符串
 *
 *  @param textColor 字体的颜色
 *
 *  @return 转换好样式的字符串
 */
+(NSMutableAttributedString *)priceChange:(NSString *)price withColor:(UIColor *)textColor maxFont:(UIFont *)maxFont mixFont:(UIFont *)mixFont{
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f",[price floatValue]] attributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:maxFont}];
    [attributeString addAttributes:@{NSFontAttributeName:maxFont} range:NSMakeRange(1, attributeString.length-1)];
    [attributeString addAttributes:@{NSFontAttributeName:mixFont} range:NSMakeRange(0, 1)];
    [attributeString addAttributes:@{NSFontAttributeName:mixFont} range:NSMakeRange(attributeString.length-2, 2)];
    return attributeString;
}


/**
*  转换价格显示样式
*
*  @param price 传入价格字符串
*
*  @param textColor 字体的颜色
*
*  @param unit 单位
*
*  @return 转换好样式的字符串
*/
+(NSMutableAttributedString *)priceChange:(NSString *)price withColor:(UIColor *)textColor maxFont:(UIFont *)maxFont mixFont:(UIFont *)mixFont  unitString:(NSString *)unit{
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f /%@",[price floatValue],unit] attributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:maxFont}];
    [attributeString addAttributes:@{NSFontAttributeName:maxFont} range:NSMakeRange(1, attributeString.length-unit.length -3)];
    [attributeString addAttributes:@{NSFontAttributeName:mixFont} range:NSMakeRange(0, 1)];
    [attributeString addAttributes:@{NSFontAttributeName:mixFont} range:NSMakeRange(attributeString.length-unit.length -4, 2)];
    [attributeString addAttributes:@{NSFontAttributeName:FONT(13)} range:NSMakeRange(attributeString.length-unit.length -1, unit.length +1)];
    [attributeString addAttributes:@{NSForegroundColorAttributeName:k_GARYCOLOR} range:NSMakeRange(attributeString.length-unit.length -1, unit.length+1)];
    return attributeString;
}


+(NSMutableAttributedString *)priceChangeSecond:(NSString *)price withColor:(UIColor *)textColor maxFont:(UIFont *)maxFont mixFont:(UIFont *)mixFont{
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%.2f /盒",[price floatValue]] attributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:maxFont}];
    [attributeString addAttributes:@{NSFontAttributeName:maxFont} range:NSMakeRange(1, attributeString.length-4)];
    [attributeString addAttributes:@{NSFontAttributeName:mixFont} range:NSMakeRange(0, 1)];
    [attributeString addAttributes:@{NSFontAttributeName:mixFont} range:NSMakeRange(attributeString.length-5, 2)];
    [attributeString addAttributes:@{NSFontAttributeName:FONT(15)} range:NSMakeRange(attributeString.length-2, 2)];
  
    return attributeString;
}


@end





@implementation Tool (Time)



// 时间戳转成时间格式
+(NSString *)dateString:(NSString *)str {
    //    NSTimeInterval time = [str doubleValue]+28800;
    if ([str doubleValue] <= 0)  {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//时间戳转日期
+(NSString *)getDateStr:(NSString *)str {
    if ([str doubleValue] <= 0)  {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

//时间转时间戳
+(NSTimeInterval )getTimeStampWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *tempDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    return [tempDate timeIntervalSince1970];
//    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]*1000];//字符串转成时间戳,精确到毫秒*1000
//    return timeStr;
}

/**获取当前时间*/
+(NSString *)getNowTime {
    NSDate *date = [NSDate date];       //当前时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateTime = [selectDateFormatter stringFromDate:date];
    return dateTime;
}

/**获取当前日期*/
+ (NSString *)getCurrentTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

/**获取指定的时间*/
+ (NSString *)getAppointTime:(NSInteger)day{
    
    NSDate *date = [NSDate date];//当前时间
    NSDate *appointDate = [NSDate dateWithTimeInterval:day*24*60*60 sinceDate:date];//后一天
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"MM月dd日";
    NSString *AppointTime = [selectDateFormatter stringFromDate:appointDate];
    return AppointTime;
}

/**
 *  比较两个日期的大小
 *
 *  @param date01 第一个日期
 *  @param date02 第二额日期
 *
 *  @return 两个日期的差的天数
 */
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSLog(@"date01:%@ , date02:%@",date01,date02);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending:
            ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending:
            ci=-1;
            break;
            //date02=date01
        case NSOrderedSame:
            ci=0;
            break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


//获取当前时间戳
+(NSString *)getTimeStamp {
    NSTimeInterval date = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.f", date];
    return timeString;
}
 

//获取当前时间（主要用于融云聊天页面展示)
+(NSString *)timeAgoWithDate:(NSTimeInterval)date
{
    const NSInteger SECOND = 1;
    const NSInteger MINUTE = 60 * SECOND;
    const NSInteger HOUR   = 60 * MINUTE;
    const NSInteger DAY    = 24 * HOUR;
    const NSInteger MONTH  = 30 * DAY;
    //    const NSInteger YEAR   = 12 * MONTH;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval delta = timeInterval - date;
    
    if (delta < 1 * MINUTE)
    {
        return @"刚刚";
    }
    else if (delta < 2 * MINUTE)
    {
        return @"1分钟前";
    }
    else if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d分钟前", minutes];
    }
    else if (delta < 90 * MINUTE)
    {
        return @"1小时前";
    }
    else if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d小时前", hours];
    }
    else if (delta < 48 * HOUR)
    {
        return @"昨天";
    }
    else if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d天前", days];
    }
    else if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
    }
    
    int years = floor((double)delta/MONTH/12.0);
    return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}


//判断当前时间在某一时间的前面还是后面（YES:前面）
+(BOOL)compareAppointTime:(NSString *)time currentTime:(NSString *)currentTime{
    
    NSString *today =  [Tool getCurrentTime];
    
    NSString *spellTime =  [NSString stringWithFormat:@"%@ %@",today,time];
 
    NSTimeInterval spellStamp = [Tool getTimeStampWithString:spellTime];
    
   // NSString *nowTimeStr = [Tool getNowTime];
  
    NSTimeInterval nowStamp = [Tool getTimeStampWithString:currentTime];
    
    if (nowStamp >= spellStamp) {
        return 0;
    }else{
        return 1;
    }
    
}


//判断时间是不是今天
+ (BOOL)checkTheDate:(NSString *)string{
    
    BOOL isToday = NO;
    
    if (string.length >= 10) {
        NSString * dateString = [string substringToIndex:10];
        NSString *nowTime = [Tool getNowTime];
        if (nowTime.length >=10) {
            NSString * nowString = [nowTime substringToIndex:10];
            if ([dateString isEqualToString:nowString]) {
                isToday = YES;
            }
        }
        
    }
    
    return isToday;
    
}



//友盟分享，错误信息
+(void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    [UIAlertController alertMessage:result SuccessCommplete:nil];
}

@end










@implementation Tool (JPushTool)

//获取极光
+(NSInteger )getJPushBadgeValue {
    
    NSString *vlaue = [k_DEFAULTS objectForKey:NOTICE_PUSHNUMBER];
    
    DLog(@"-----------极光标识数量----------\n%@",vlaue);

    return [vlaue integerValue];
}

//存储本地极光角标数量
+(void)saveJpushBadgeValue {
    
    NSInteger value = [Tool getJPushBadgeValue];
    value++;
    [k_DEFAULTS setObject:@(value).stringValue forKey:NOTICE_PUSHNUMBER];
    [k_DEFAULTS synchronize];
    
    DLog(@"-----------存储极光标识数量----------\n%@",[k_DEFAULTS objectForKey:NOTICE_PUSHNUMBER]);
}


//清理极光本地角标
+(void)clearJpushBadgeValue {
    
    //[JPUSHService resetBadge];

    [k_DEFAULTS removeObjectForKey:NOTICE_PUSHNUMBER];
    [k_DEFAULTS synchronize];
    
    if ([k_DEFAULTS objectForKey:NOTICE_PUSHNUMBER]) {
        DLog(@"**************删除极光角标记录失败**************");
    }else{
        DLog(@"==============删除极光角标记录成功==============");

    }
}

//获取总数量角标
+(NSInteger)getAllBadgeValue {
    
    DLog(@"获取总数量角标:\n%ld\n%ld", (long)[[RCIMClient sharedRCIMClient] getTotalUnreadCount],(long)[Tool getJPushBadgeValue]);
    
   // NSInteger value = [[RCIMClient sharedRCIMClient] getTotalUnreadCount] + [Tool getJPushBadgeValue];
    NSInteger value = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    
    return value;
    
}

@end


@implementation Tool (rongyunTool)

//删除某个会话中的所有历史消息(conversaionType:回话类型  targetId:聊天对象融云id)
+(void)clearHistoryMessages:(RCConversationType)conversaionType targetId:(NSString *)targetId{
    
    //清除某个会话中的消息
    [[RCIMClient sharedRCIMClient]clearMessages:conversaionType targetId:targetId];
    //从本地存储中删除会话
    [[RCIMClient sharedRCIMClient]removeConversation:conversaionType targetId:targetId];
    //删除某个会话中的所有历史消息
    [[RCIMClient sharedRCIMClient]clearHistoryMessages:conversaionType targetId:targetId recordTime:0 clearRemote:YES success:^{
       
    } error:^(RCErrorCode status) {
        
    }];
    //从服务器端清除历史消息
    [[RCIMClient sharedRCIMClient]clearRemoteHistoryMessages:conversaionType targetId:targetId recordTime:0 success:^{
        
    } error:^(RCErrorCode status) {
        
    }];
}


@end
