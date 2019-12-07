/********* SPortsFitness.m Cordova Plugin Implementation *******/

#import "SPortsFitness.h"



@implementation SPortsFitness
/*
*    command.arguments[0] 某一天的日期yyyy-MM-dd 今天的不传或@""
 
 返回参数
*    numberOfSteps 用户行走的步数
*    distance 用户行走的距离，以米为单位
*    floorsAscended 楼梯上升的楼层数目。值是零
*    floorsDescended 下降的楼层数目。值是零
*    currentPace 它返回当前的速度，单位是s/m(秒/米)
*    currentCadence 返回的是每秒钟的步数。
*    averageActivePace 返回自那时以来的平均活动速度
*/

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    

//    str = @"{\"start\":\"\", \"sex\":\"女\", \"age\":\"20\" }";
      /// 创建计步器对象
        if ([CMPedometer isStepCountingAvailable]) {
             NSDate *lastDate;
             NSDate *toDate ;
            NSString *str = command.arguments[0];
            if (!str||[str isEqualToString:@""]) {
                lastDate = [self getDate:@"00:01"];
                toDate = [self getDate:@"23:59"];
            }else{
                lastDate = [self getsOfTheDay:str withStartOrEndTime:@"00:01"];
                toDate = [self getsOfTheDay:str withStartOrEndTime:@"23:59"];
            }
            
            self.pedometer = [[CMPedometer alloc] init];
        
            __weak SPortsFitness * weakSelf = self;
            [self.pedometer startPedometerUpdatesFromDate:lastDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                // 如果没有错误，具体信息从pedometerData参数中获取

            }];
            [self.pedometer queryPedometerDataFromDate:lastDate toDate:toDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                // 如果没有错误，具体信息从pedometerData参数中获取
    //            pedometerData
                NSLog(@"步数: %zd", [pedometerData.numberOfSteps integerValue]);
                [weakSelf podPedometerData:pedometerData InvokedUrlCommand:command error:error];
                
            }];
        }else{
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的设备暂不支持" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertC addAction:alertA];
            [self.viewController presentViewController:alertC animated:YES completion:nil];
        }
    
}
- (void)podPedometerData:(CMPedometerData *)pedometerData InvokedUrlCommand:(CDVInvokedUrlCommand*)command error:(NSError *)error
{
    
//    numberOfSteps 用户行走的步数
//    distance 用户行走的距离，以米为单位
//    floorsAscended 楼梯上升的楼层数目。值是零
//    floorsDescended 下降的楼层数目。值是零
//    currentPace 它返回当前的速度，单位是s/m(秒/米)
//    currentCadence 返回的是每秒钟的步数。
//    averageActivePace 返回自那时以来的平均活动速度
    CDVPluginResult* pluginResult = nil;
//    NSString* echo = [command.arguments objectAtIndex:0];
    if (error) {
          NSLog(@"error--%@",error);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];

    }else{
    NSString* echo = [NSString stringWithFormat:@"%@",pedometerData.numberOfSteps];

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"numberOfSteps":echo?:@"",@"distance":pedometerData.distance?:@"",@"floorsAscended":pedometerData.floorsAscended?:@"",@"floorsDescended":pedometerData.floorsDescended?:@"",@"currentPace":pedometerData.currentPace?:@"",@"currentCadence":pedometerData.currentCadence?:@"",@"averageActivePace":pedometerData.averageActivePace?:@""}];
    echo = [self dictionaryToJson:dic];
    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSDate *)getDate:(NSString *)dateString {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd ";
    NSString *lastDateStr = [df stringFromDate:date];
    
    NSString *string = [lastDateStr stringByAppendingString:dateString];;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date1 = [fmt dateFromString:string];
    return date1;
}
-(NSDate *)getsOfTheDay:(NSString *)day withStartOrEndTime:(NSString *)time
{
        NSString *string = [day stringByAppendingString:[NSString stringWithFormat:@" %@",time]];;
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *date = [fmt dateFromString:string];
        return date;

}
-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
