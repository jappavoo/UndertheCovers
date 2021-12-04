#ifndef __MISC_H__
#define __MISC_H__

//#define ENABLE_VERBOSE
//#define ENABLE_TRACE_LOOP
//#define ENABLE_TRACE_MEM

#ifdef ENABLE_VERBOSE
#define VPRINT(fmt, ...) fprintf(stderr, "%s: " fmt, __func__,__VA_ARGS__)
#else
#define VPRINT(...)
#endif

#ifdef ENABLE_TRACE_LOOP
#define TRACE_LOOP(stmt) { stmt; }
#else
#define TRACE_LOOP(stmt)
#endif

#ifdef ENABLE_TRACE_MEM
#define TRACE_MEM(stmt) { stmt; }
#else
#define TRACE_MEM(stmt)
#endif

#define NYI fprintf(stderr, "%s: NYI\n", __func__)
#endif
