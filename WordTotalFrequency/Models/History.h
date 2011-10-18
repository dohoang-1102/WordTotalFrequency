//
//  History.h
//  WordTotalFrequency
//
//  Created by Perry on 11-10-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface History : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * spell;
@property (nonatomic, retain) NSData * uriRepresentation;
@property (nonatomic, retain) NSString * translate;
@property (nonatomic, retain) NSString * date;

@end