//
//  Dropitehavior.h
//  Dropit
//
//  Created by myqiqiang on 14-6-15.
//  Copyright (c) 2014年 myqiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Dropitehavior : UIDynamicBehavior

-(void)addItem:(id <UIDynamicItem>)item;
-(void)removeItem:(id <UIDynamicItem>)item;

@end
