//
//  Settings.h
//  FantasyFootballCalc
//
//  Created by Justin Port on 7/5/14.
//  Copyright (c) 2014 Chabot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

 - (void) setProperty:(NSString *)property:(NSString *)value;
 - (NSString *)getProperty:(NSString *)property;
 - (bool)propertyExists:(NSString *)property;


@end
