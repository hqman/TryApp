//
//  HWManager+Question.h
//  Try_01
//
//  Created by hqman on 15/5/6.
//  Copyright (c) 2015年 tiziapp. All rights reserved.
//

#import "HWManager.h"

@interface HWManager (Question)
-(RACSignal *)importQuestionsWithTag:(NSString *) tag;
-(RACSignal *)getQuestionsWithTag:(NSString *) tag;
@end
