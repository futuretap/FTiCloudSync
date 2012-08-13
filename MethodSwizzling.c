/*
 *  MethodSwizzling.c
 *
 *  by MikeAsh
 *  http://cocoadev.com/index.pl?MethodSwizzling
 *
 */

#import <objc/runtime.h>
#include "MethodSwizzling.h"

void Swizzle(Class c, SEL orig, SEL new) {
	
    Method origMethod = class_getInstanceMethod(c, orig);
	Method newMethod = class_getInstanceMethod(c, new);
	
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
		method_exchangeImplementations(origMethod, newMethod);
}

void SwizzleClassMethod(Class c, SEL orig, SEL new) {
	
    Method origMethod = class_getClassMethod(c, orig);
	Method newMethod = class_getClassMethod(c, new);
	
	c = object_getClass((id)c);
	
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
		method_exchangeImplementations(origMethod, newMethod);
}
