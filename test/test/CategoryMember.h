//
//  CategoryMember.h
//  test
//
//  Created by Phoebe Li on 5/16/15.
//  Copyright (c) 2015 Mellmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CategoryMember : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * previousValue;

@end
