//
//  Tool.h
//  Ecommunity
//
//  Created by TONG on 2019/1/16.
//  Copyright © 2019 IntelligentAntenna. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject



//MARK : - 基本工具类

/** 得到网络请求参数签名*/
+ (NSString*)createSignWithDic:(NSDictionary*)dic;

/** 得到网络请求参数签名*/
+(NSString *)createSignWithDic1:(NSDictionary*)dic;

/** 当字典的Value为nil的情况下，把Value替换为空字符串*/
+ (NSDictionary *)replaceKey:(NSDictionary *)dic;

/** 中心点弹出动画效果*/
+ (void)centerAnimation:(UIView *)view;

/** 清除web缓存 */
+(void)clearWebCache;

/** 打电话 */
+ (void)callNumber:(NSString *)phoneNum;

/** 隐藏手机中间4位*/
+ (NSString *)changeOnePhoneNumWithPhoneStr:(NSString*)string;

/** 加载网络图片 */
+(void)loadImageView:(UIImageView *)imageView withURL:(NSString *)imageUrlString;

/**
 *  图片转Base64的字符串(带压缩)
 *  @param imageArray 传进的图片数组
 *  @return 拼接好的字符串
 */
+(NSString *)getImgFilesString:(NSArray *)imageArray;

/** 解析UTF8格式Json */
+(NSString *)logDic:(NSDictionary *)dic;

//json格式化为字符串
+(NSString*)ObjectTojsonString:(id)object;

/**
 计算text的高度
 
 @param text 传入的文字
 @param width 内容的范围宽度
 @param font 字体
 @return 返回高度
 */
+(CGFloat)checkLableTextHeight:(NSString *)text width:(CGFloat )width font:(UIFont *)font;

/**
计算text的宽度

@param text 传入的文字
@param height 文字高度
@param font 字体
@return 返回高度
*/
+ (CGFloat)getStringWidthWithText:(NSString *)text font:(UIFont *)font viewHeight:(CGFloat)height;

/** 更改textFiled的placeHolder的字体颜色，大小 */
+(void)changePlaceHolder:(UITextField *)textFiled Color:(UIColor *)color Font:(CGFloat )fontSize;

/*
 *更换窗口根视图
 @param controller 根视图
 */
+(void)changeWindowRootViewController:(UIViewController*)controller;


/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;


/*
 control 是要设置渐变字体的控件   bgVIew是control的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;


/**
 *  根据图片url获取图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL;


/**
 限制TextField的输入长度
 
 @param numString 输入的字符text
 @param range 范围
 @param string 替换字符串
 @param stringLenght 控制的长度
 @return 范围中返回NO,达到限制范围返回YES
 */
+ (BOOL)limitTheLength:(NSString *)numString shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string length:(NSInteger)stringLenght;


/**
 更改数组中某个下标的状态
 
 @param array 传进的数组(数组的内容必须为@0,或者@1)
 @param index 需要改状态的下标
 */
+(void)replaceObiect:(NSMutableArray *)array index:(NSInteger)index;


/**
 CGFloat保留几位小数
 
 @param value CGFloat数值
 @return   CGFloat保留几位小数
 */
+(float)keepTwoDecimal:(CGFloat)value;


/**
 设置固定行间距文本
 
 @param lineSpace 行间距
 @param text 文本内容
 @param label 要设置的label
 */
+(void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text inLabel:(UILabel *)label;



/**
 设置固定字间距文本
 
 @param WordSpace 字间距
 @param text 文本内容
 @param label 要设置的label
 */
+(void)setWordSpace:(CGFloat)WordSpace withText:(NSString *)text inLabel:(UILabel *)label;

/**
 跳转权限管理
 */
+(void)goToSetting;

/**
 获取视频／音频文件的总时长
 
 @param URL 音频和视频URl
 */
+(CGFloat)getFileDuration:(NSURL*)URL;

/**
 获取视频的大小
 
 @param path 视频的本地地址
 */
+(CGFloat)getFileVideoSize:(NSString *)path;


/**
总共秒数转换成时分秒
 */
+(NSString *)timeFormatted:(int)totalSeconds;


/**
图片字符串转数组

 @param imageString 图片字符串
 */
+(NSArray *)imageStringToArray:(NSString *)imageString;

/**
 图片字符串转数组,末尾没有逗号
*/
+(NSArray *)imageStringToArray1:(NSString *)imageString;


/**
 label拼接图片icon
 
 @param string label内容
 @param icon 拼接的图片icon
 @param size icon大小
 @param index 插入到文字内容的下标
 @return 图文label
 */
+(NSMutableAttributedString *)changeString:(NSString *)string icon:(UIImage *)icon bounds:(CGRect )size atIndex:(NSInteger)index;


 

/// 根据url获取视频第一帧图片
/// @param videoURL 视频url
/// @param time 转化时长
/// @param completeBlock 完成block
+(void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time completeBlock:(void(^)(id objc))completeBlock;


@end



//MARK: - 用户信息类
@interface Tool (Accout)

/**
 用户是否在登录状态
 
 @return 是/否
 */
+ (BOOL)isLogining;


/**
 是否有默认房屋
 
 @return 返回默认房屋
 */
+ (BOOL)isDefaultHouse;

/**
 获取版本号

 @return 版本号
 */
+(NSString *)getVersion;


/**
 获取用户ssoid

 @return ssoid
 */
+(NSString*)getSsoid;

@end




//MARK: - 判断BooL类
@interface Tool (Validation)

/**
 是否第一次启动程序
 
 @return 是/否
 */
+ (BOOL)isFirstStartUp;

/**
 字符串是否为浮点型
 
 @param string 待验证字符串
 @return 是/否
 */
+ (BOOL)isPureFloat:(NSString*)string;

/**
 字符串是否包含中文
 
 @param string 待验证字符串
 @return 是/否
 */
+ (BOOL)isChinese:(NSString *)string;

/**
 字符串是否为邮箱
 
 @param email 待验证字符串
 @return 是/否
 */
+(BOOL)isValidateEmail:(NSString *)email;


/**
 字符串是否为移动电话
 
 @param mobileNumbel 待验证字符串
 @return 是/否
 */
+ (BOOL)isMobile:(NSString *)mobileNumbel;

/**
 字符串是否符合密码格式
 
 @param passWord 待验证字符串
 @return 是/否
 */
+ (BOOL)isValidatePassword:(NSString *)passWord;

/**
 字符串是否为身份证
 
 @param idCard 待验证字符串
 @return 是/否
 */
+ (BOOL)isCheckUserIdCard:(NSString *)idCard;

/**
 字符串是否为银行卡
 
 @param bankCardNumber 待验证字符串
 @return 是/否
 */
+ (BOOL)isValidateBankCardNumber:(NSString *)bankCardNumber;

/**
 *  检查字符串是否全由指定字符(如空格)组成
 *
 *  @param string 待测字符串
 *  @param ch     对比字符
 *
 *  @return YES 是 NO 不
 */
+(BOOL)checkupString:(NSString*)string WithCharacter:(char)ch;


/**
 判断是字符是否null类型
 
 @param str 测字符串
 @return YES 不是 NO 是
 */
+(BOOL)isBlank:(NSString *)str;



/**
 判断是否输入了emoji 表情

 @param string 输入的文字
 @return 返回是否含有字符
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
  url解码
 */
+(NSString *)decodeString:(NSString*)encodedString;

/**
 json字符串转字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 json字符串转数组
 */
+(NSArray *)arrayWithJsonString:(NSString *)jsonString;


/**
 URl链接截取转字典（参数)
 */
+(NSDictionary *)dictionarytToUrlString:(NSString *)urlStr;


@end


@interface Tool(Price)


/**
 *  转换价格显示样式
 *
 *  @param price 传入价格字符串
 *
 *  @param textColor 字体的颜色
 *
 *  @return 转换好样式的字符串
 */
+(NSMutableAttributedString *)priceChange:(NSString *)price withColor:(UIColor *)textColor maxFont:(UIFont *)maxFont mixFont:(UIFont *)mixFont;


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
+(NSMutableAttributedString *)priceChange:(NSString *)price withColor:(UIColor *)textColor maxFont:(UIFont *)maxFont mixFont:(UIFont *)mixFont  unitString:(NSString *)unit;

+(NSMutableAttributedString *)priceChangeSecond:(NSString *)price withColor:(UIColor *)textColor maxFont:(UIFont *)maxFont mixFont:(UIFont *)mixFont;

@end


//MARK: - 时间类
@interface Tool (Time)

/**
 时间戳转时间
 
 @param str 时间戳转时间
 @return 时间
 */
+ (NSString *)dateString:(NSString *)str;

 //时间戳转日期
+(NSString *)getDateStr:(NSString *)str;

 
//获取当前日期
+ (NSString *)getCurrentTime;

/**
 时间转时间戳

 @param str 时间字符串
 @return 返回时间戳
 */
+(NSTimeInterval)getTimeStampWithString:(NSString *)str;


/**
 获取当前时间
 
 @return 时间
 */
+ (NSString *)getNowTime;


/**
 获取指定的时间
 
 @return 时间
 */
+ (NSString *)getAppointTime:(NSInteger)day;

/**
 比较两个日期的大小
 
 @param date01 日期一
 @param date02 日期二
 @return 时间差
 */
+ (int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

///获取当前时间戳
+(NSString *)getTimeStamp;


///判断当前时间在某一时间的前面还是后面（YES:前面）
+(BOOL)compareAppointTime:(NSString *)time currentTime:(NSString *)currentTime;

//判断时间是不是今天
+ (BOOL)checkTheDate:(NSString *)string;


///获取当前时间（主要用于融云聊天页面展示)
+(NSString *)timeAgoWithDate:(NSTimeInterval)date;

//友盟分享，错误信息
+(void)alertWithError:(NSError *)error;

@end




//MARK: - 推送管理类
@interface  Tool (JPushTool)

///获取极光badge
+(NSInteger )getJPushBadgeValue;


///存储本地极光角标数量
+(void)saveJpushBadgeValue;


///清理极光本地角标
+(void)clearJpushBadgeValue;


///获取总数量角标
+(NSInteger)getAllBadgeValue;


@end


//MARK: - 融云聊天管理类
@interface Tool (rongyunTool)

//删除某个会话中的所有历史消息(conversaionType:回话类型  targetId:聊天对象融云id)
+(void)clearHistoryMessages:(RCConversationType)conversaionType targetId:(NSString *)targetId;

@end





































NS_ASSUME_NONNULL_END
