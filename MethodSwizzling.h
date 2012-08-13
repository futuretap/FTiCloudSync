/*
 *  MethodSwizzling.h
 *
 *  by MikeAsh
 *  http://cocoadev.com/index.pl?MethodSwizzling
 *
 */

void Swizzle(Class c, SEL orig, SEL new);
void SwizzleClassMethod(Class c, SEL orig, SEL new);