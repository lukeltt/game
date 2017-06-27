//
//  IdiomModel.h
//  game
//
//  Created by luke on 2017/4/19.
//  Copyright © 2017年 imooc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdiomModel : NSObject

@property(copy,nonatomic) NSString * answer;
@property(copy,nonatomic) NSString * title;
@property(strong,nonatomic) NSArray * options;

@end
