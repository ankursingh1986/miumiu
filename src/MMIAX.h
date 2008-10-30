//
//  MMIAX.h
//  MiuMiu
//
//  Created by Peter Zion on 09/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MMProtocol.h"

#include <iax-client.h>

@class MMIAXCall;

#define MM_IAX_MAX_NUM_CALLS 8

@interface MMIAX : MMProtocol
{
@private
	unsigned numCalls;
	struct
	{
		struct iax_session *session;
		MMIAXCall *iaxCall;
	} calls[MM_IAX_MAX_NUM_CALLS];
	struct iax_session *session;
	CFSocketContext socketContext;
	struct iax_session *callingSession;
	unsigned callingFormat;
}

-(void) registerIAXCall:(MMIAXCall *)call withSession:(struct iax_session *)callSession;
-(void) unregisterIAXCall:(MMIAXCall *)call withSession:(struct iax_session *)callSession;

-(void) socketCallbackCalled;

@end
