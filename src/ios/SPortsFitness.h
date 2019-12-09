//
//  SPortsFitness.h
//  MyApp
//
//  Created by zl on 2019/12/7.
//

#import <Cordova/CDV.h>
#import <CoreMotion/CoreMotion.h>
#import <HealthKit/HealthKit.h>
@interface SPortsFitness : CDVPlugin {
  // Member variables go here.
}
@property (strong, nonatomic) CMPedometer *pedometer;
@property (strong, nonatomic) HKHealthStore *healthStore;


/*
*    command.arguments[0]  某一天的日期yyyy-MM-dd 今天的传@""
 即cordova.plugins.SPortsFitness.coolMethod("", success, error);或者cordova.plugins.SPortsFitness.coolMethod("2019-12-07", success, error);
 
 返回参数
*    numberOfSteps 用户行走的步数
*    distance 用户行走的距离，以米为单位
*    floorsAscended 楼梯上升的楼层数目。值是零
*    floorsDescended 下降的楼层数目。值是零
*    currentPace 它返回当前的速度，单位是s/m(秒/米)
*    currentCadence 返回的是每秒钟的步数。
*    averageActivePace 返回自那时以来的平均活动速度
*/
- (void)sportsMethod:(CDVInvokedUrlCommand*)command;
@end
