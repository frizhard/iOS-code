//
//  ByBArcConditional.h
//  ByBExtras
//
//  Created by José Servet Font on 08/09/13.
//  Copyright (c) 2013 ByBDesigns. All rights reserved.
//

#ifndef ByBExtras_ByBArcConditional_h
#define ByBExtras_ByBArcConditional_h

#if __has_feature(objc_arc)
	#define arc_safe_retain(x)	x
	#define arc_safe_release(x)
#else
	#define	arc_safe_retain(x)	[x retain]
	#define	arc_safe_release(x)	[x release]
#endif

#endif
