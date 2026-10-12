#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>

static NSString *ReadSysctl(const char *key) {
    size_t size = 0;

    if (sysctlbyname(key, NULL, &size, NULL, 0) != 0 || size == 0) {
        return @"Unknown";
    }

    char *buffer = (char *)calloc(size + 1, 1);

    if (!buffer) {
        return @"Unknown";
    }

    NSString *result = @"Unknown";

    if (sysctlbyname(key, buffer, &size, NULL, 0) == 0) {
        result = [NSString stringWithUTF8String:buffer] ?: @"Unknown";
    }

    free(buffer);
    return result;
}

int main(int argc, char *argv[]) {
    @autoreleasepool {
        NSProcessInfo *process = [NSProcessInfo processInfo];

        NSString *version =
            [process operatingSystemVersionString] ?: @"Unknown";

        NSString *device = ReadSysctl("hw.machine");
        NSString *build = ReadSysctl("kern.osversion");

        printf("Singularity diagnostic\n");
        printf("----------------------\n");
        printf("Device: %s\n", [device UTF8String]);
        printf("iOS: %s\n", [version UTF8String]);
        printf("OS build: %s\n", [build UTF8String]);
        printf("Architecture: ARM64\n");
        printf("Package scheme: rootful\n");

        if ([device hasPrefix:@"iPad4,"] &&
            [build isEqualToString:@"16H88"]) {
            printf("Target match: iPad mini 2 / iOS 12.5.8\n");
        } else {
            printf("Target match: this is not the exact target combination\n");
        }

        printf("\n");
        printf("This diagnostic does not exploit the kernel,\n");
        printf("modify boot files, or re-jailbreak the device.\n");

        return 0;
    }
}
