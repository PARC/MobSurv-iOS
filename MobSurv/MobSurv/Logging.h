/*
 * Logging.h
 *
 * $Version: Logging 1.0 (1e09f90c5fec) on 2010-07-22 $
 * Author: Bill Hollings
 * Copyright (c) 2010 The Brenwill Workshop Ltd. 
 * http://www.brenwill.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * http://en.wikipedia.org/wiki/MIT_License
 *
 * Thanks to Nick Dalton for providing the underlying ideas for using variadic macros as
 * well as for outputting the code location as part of the log entry. For his ideas, see:
 *   http://iphoneincubator.com/blog/debugging/the-evolution-of-a-replacement-for-nslog
 */

/**
 * Code modified and extended by G. Michael Youngblood
 * Extensions Copyright (c) 2012 PARC, a Xerox company
 *
 * Changes:
 * - Reorganized levels from a 4 to a 5 tier system
 * - Allow for setting an overall logging level, which will allow all log elements at or below that level to be displayed
 * - 
 */

/**
 * For Objective-C code, this library adds flexible, non-intrusive logging capabilities
 * that can be efficiently enabled or disabled via compile switches.
 *
 * There are five levels of logging: debug, info, warning, error and fatal, and each can be enabled
 * independently via the LOGGING_LEVEL_DEBUG, LOGGING_LEVEL_INFO, LOGGING_LEVEL_WARNING, LOGGING_LEVEL_ERROR and
 * LOGGING_LEVEL_FATAL switches, respectively.
 *
 * In addition, ALL logging can be enabled or disabled via the LOGGING_ENABLED switch.
 *
 * Logging functions are implemented here via macros. Disabling logging, either entirely, or
 * at a specific level, completely removes the corresponding log invocations from the compiled
 * code, thus eliminating both the memory and CPU overhead that the logging calls would add.
 * You might choose, for example, to completely remove all logging from production release code,
 * by setting LOGGING_ENABLED off in your production builds settings. Or, as another example,
 * you might choose to include Error logging in your production builds by turning only
 * LOGGING_ENABLED and LOGGING_LEVEL_ERROR on, and turning the others off.
 *
 * To perform logging, use any of the following function calls in your code:
 *
 *		LogDebug(fmt, ...)	- recommended for temporary use during debugging to provide maximum visibility into actions
 *							- will print if LOGGING_LEVEL_DEBUG is set on.
 *                          - will print if LOGGING_LEVEL_VERBOSITY is set to 5
 *
 *		LogInfo(fmt, ...)	- recommended for general, infrequent, information messages
 *                          - useful for watching the system move through operations, but with less detail than debug
 *							- will print if LOGGING_LEVEL_INFO is set on.
 *                          - will print if LOGGING_LEVEL_VERBOSITY is set to 4 or higher
 *
 *		LogWarning(fmt, ...)- recommended for detailed warnings of improper usage, but will still execute
 *							- will print if LOGGING_LEVEL_WARNING is set on.
 *                          - will print if LOGGING_LEVEL_VERBOSITY is set to 3 or higher
 *
 *		LogError(fmt, ...)	- recommended for use only when there is an error to be logged
 *							- will print if LOGGING_LEVEL_ERROR is set on.
 *                          - will print if LOGGING_LEVEL_VERBOSITY is set to 2 or higher
 *
 *		LogFatal(fmt, ...)	- recommended for use only when there is a fatal problem to be logged
 *							- will print if LOGGING_LEVEL_FATAL is set on.
 *                          - will print if LOGGING_LEVEL_VERBOSITY is set to 1 or higher
 *
 *
 * In each case, the functions follow the general NSLog/printf template, where the first argument
 * "fmt" is an NSString that optionally includes embedded Format Specifiers, and subsequent optional
 * arguments indicate data to be formatted and inserted into the string. As with NSLog, the number
 * of optional arguments must match the number of embedded Format Specifiers. For more info, see the
 * core documentation for NSLog and String Format Specifiers.
 *
 * You can choose to have each logging entry automatically include class, method and line information
 * by enabling the LOGGING_INCLUDE_CODE_LOCATION switch.
 *
 * Although you can directly edit this file to turn on or off the switches below, the preferred
 * technique is to set these switches via the compiler build setting GCC_PREPROCESSOR_DEFINITIONS
 * in your build configuration.
 *
 * Example usage:
 *
 * LogDebug(@"Simple message");
 * LogDebug(@"Message with %i argument...oops I mean %.1f arguments", 1, 2.0f);
 * LogInfo(@"Do you object to this %@ date object?", [NSDate new]);
 * LogWarning(@"I'll take this out if you stop using the method incorrectly.");
 * LogError(@"Don't do that: %@", [NSException exceptionWithName: @"CRYING" reason: @"Spilled milk" userInfo:nil]);
 *
 */

/**
 * Set this switch to  enable or disable logging capabilities.
 * This can be set either here or via the compiler build setting GCC_PREPROCESSOR_DEFINITIONS
 * in your build configuration. Using the compiler build setting is preferred for this to
 * ensure that logging is not accidentally left enabled by accident in release builds.
 */
#ifndef LOGGING_ENABLED
#	define LOGGING_ENABLED		1
#endif

/**
 * Set any or all of these switches to enable or disable logging at specific levels.
 * These can be set either here or as a compiler build settings.
 * For these settings to be effective, LOGGING_ENABLED must also be defined and non-zero.
 */
#ifndef LOGGING_LEVEL_DEBUG
#	define LOGGING_LEVEL_DEBUG		0
#endif
#ifndef LOGGING_LEVEL_INFO
#	define LOGGING_LEVEL_INFO		0
#endif
#ifndef LOGGING_LEVEL_WARNING
#	define LOGGING_LEVEL_WARNING	0
#endif
#ifndef LOGGING_LEVEL_ERROR
#	define LOGGING_LEVEL_ERROR		0
#endif
#ifndef LOGGING_LEVEL_FATAL
#	define LOGGING_LEVEL_FATAL		0
#endif

/** 
 * Verbosity level to set an overall level that includes lower levels
 *   Maximum is 5, Minimum is 1, Quiescent is 0
 *
 *   (Debug = 5, Info = 4, Warning = 3, Error = 2, Fatal = 1, None = 0)
 */
#ifndef LOGGING_LEVEL_VERBOSITY
#   define LOGGING_LEVEL_VERBOSITY  5
#endif

/**
 * Set this switch to indicate whether or not to include class, method and line information
 * in the log entries. This can be set either here or as a compiler build setting.
 */
#ifndef LOGGING_INCLUDE_CODE_LOCATION
	#define LOGGING_INCLUDE_CODE_LOCATION	0
#endif


// *********** END OF USER SETTINGS  - Do not change anything below this line ***********


#if !(defined(LOGGING_ENABLED) && LOGGING_ENABLED)
	#undef LOGGING_LEVEL_DEBUG
	#undef LOGGING_LEVEL_INFO
    #undef LOGGING_LEVEL_WARNING
	#undef LOGGING_LEVEL_ERROR
	#undef LOGGING_LEVEL_FATAL
    #undef LOGGING_LEVEL_VERBOSITY
    #undef LOGGING_INCLUDE_CODE_LOCATION
#endif

// Logging format
#define LOG_FORMAT_NO_LOCATION(fmt, lvl, ...) NSLog((@"[%@] " fmt), lvl, ##__VA_ARGS__)
#define LOG_FORMAT_WITH_LOCATION(fmt, lvl, ...) NSLog((@"%s[Line %d] [%@] " fmt), __PRETTY_FUNCTION__, __LINE__, lvl, ##__VA_ARGS__)

#if defined(LOGGING_INCLUDE_CODE_LOCATION) && LOGGING_INCLUDE_CODE_LOCATION
	#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_WITH_LOCATION(fmt, lvl, ##__VA_ARGS__)
#else
	#define LOG_FORMAT(fmt, lvl, ...) LOG_FORMAT_NO_LOCATION(fmt, lvl, ##__VA_ARGS__)
#endif

// Debug logging - use only temporarily for highlighting and tracking down problems
#if (defined(LOGGING_LEVEL_DEBUG) && LOGGING_LEVEL_DEBUG) || (defined(LOGGING_LEVEL_VERBOSITY) && (LOGGING_LEVEL_VERBOSITY >= 5))
    #define LogDebug(fmt, ...) LOG_FORMAT(fmt, @"DEBUG", ##__VA_ARGS__)
#else
    #define LogDebug(...)
#endif

// Info logging - for general, non-performance affecting information messages
#if (defined(LOGGING_LEVEL_INFO) && LOGGING_LEVEL_INFO) || (defined(LOGGING_LEVEL_VERBOSITY) && (LOGGING_LEVEL_VERBOSITY >= 4))
	#define LogInfo(fmt, ...) LOG_FORMAT(fmt, @"Info", ##__VA_ARGS__)
#else
	#define LogInfo(...)
#endif

// Warning logging - recommended for detailed warnings of improper usage, but will still execute
#if (defined(LOGGING_LEVEL_WARNING) && LOGGING_LEVEL_WARNING) || (defined(LOGGING_LEVEL_VERBOSITY) && (LOGGING_LEVEL_VERBOSITY >= 3))
    #define LogWarning(fmt, ...) LOG_FORMAT(fmt, @"Warning", ##__VA_ARGS__)
#else
    #define LogWarning(...)
#endif

// Error logging - only when there is an error to be logged
#if (defined(LOGGING_LEVEL_ERROR) && LOGGING_LEVEL_ERROR) || (defined(LOGGING_LEVEL_VERBOSITY) && (LOGGING_LEVEL_VERBOSITY >= 2))
	#define LogError(fmt, ...) LOG_FORMAT(fmt, @"***ERROR***", ##__VA_ARGS__)
#else
	#define LogError(...)
 #endif

// Fatal logging - only when there is a fatal problem to be logged
#if (defined(LOGGING_LEVEL_FATAL) && LOGGING_LEVEL_FATAL) || (defined(LOGGING_LEVEL_VERBOSITY) && (LOGGING_LEVEL_VERBOSITY >= 1))
    #define LogFatal(fmt, ...) LOG_FORMAT(fmt, @"-*!!!~FATAL~!!!*-", ##__VA_ARGS__)
#else
    #define LogFatal(...)
#endif

// eof
