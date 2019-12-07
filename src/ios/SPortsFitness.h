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



- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end
