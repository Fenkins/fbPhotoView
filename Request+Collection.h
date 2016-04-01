//
//  Request+Collection.h
//  fbPhotoView
//
//  Created by Fenkins on 01/04/16.
//  Copyright © 2016 Fenkins. All rights reserved.
//

#import "Request.h"

@interface Request (Collection)
-(NSDictionary*)requestWithGraphPath:(NSString*)graphPath
                          parameters:(NSDictionary*)parameters
                          httpMethod:(NSString*)httpMethod;
@end
