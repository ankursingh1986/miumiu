//
//  MiuMiuAppDelegate.m
//  MiuMiu
//
//  Created by Peter Zion on 08/10/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "MMViewController.h"

//#define LOOPBACK_THROUGH_AUDIO
//#define LOOPBACK_THROUGH_SPEEX

@implementation MMViewController

-(id) init
{
	if ( self = [super init] )
	{
		speexEncoder = [[MMSpeexEncoder alloc] init];
		speexDecoder = [[MMSpeexDecoder alloc] init];
		
		audioController = [[MMAudioController alloc] init];
		
		iax = [[MMIAX alloc] init];
		iax.delegate = self;
		
#ifdef LOOPBACK_THROUGH_AUDIO
		[audioController connectToConsumer:audioController];
#else
		[audioController connectToConsumer:speexEncoder];
# ifdef LOOPBACK_THROUGH_SPEEX
		[speexEncoder connectToConsumer:speexDecoder];
# else
		[speexEncoder connectToConsumer:iax];
		[iax connectToConsumer:speexDecoder];
# endif
		[speexDecoder connectToConsumer:audioController];
#endif
	}
	return self;
}

-(void) dealloc
{
	[view release];
	[iax release];
	[audioController release];
	[speexEncoder release];
	[super dealloc];
}

-(void) loadView
{
	view = [[MMView alloc] initWithNumber:@"" inProgress:NO];
	view.delegate = self;
	self.view = view;
}

-(void) view:(MMView *)_ requestedBeginCallWithNumber:(NSString *)number
{
	[iax beginCall:number];
	
	[speexDecoder start];
	[speexEncoder start];

	[audioController start];

	[view didBeginCall:self];
}

-(void) viewRequestedEndCall:(MMView *)_
{
	[audioController stop];

	[speexEncoder stop];
	[speexDecoder stop];
	
	[iax endCall];
	
	[view didEndCall:self];
}

@end