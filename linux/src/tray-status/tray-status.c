#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <limits.h>
#include <linux/cdrom.h>

#define INFO_TXT(s) "\e[92m***\e[22m " s "\e[0m\n"
#define WARN_TXT(s) "\e[93m***\e[91m " s "\e[0m\n"

int main(int argc, char* argv[]) {
    int drive;
    int result;
    int prev_result = INT_MIN;


    drive = open(argv[1], O_RDONLY | O_NONBLOCK);
    if (drive == -1) {
        perror("Could not open drive: ");
        return 1;
    }

    do {
        result = ioctl(drive, CDROM_DRIVE_STATUS, CDSL_NONE);

        if (prev_result != result) {
            switch(result) {
                case CDS_NO_INFO:
                    fputs(WARN_TXT("No information available."), stderr);
                    break;
                case CDS_NO_DISC:
                    fputs(WARN_TXT("No disc."), stderr);
                    break;
                case CDS_TRAY_OPEN:
                    fputs(WARN_TXT("Tray is open."), stderr);
                    break;
                case CDS_DRIVE_NOT_READY:
                    fputs(WARN_TXT("Drive is not ready."), stderr);
                    break;
                case CDS_DISC_OK:
                    fputs(INFO_TXT("Disc is OK."), stderr);
                    goto drive_is_ready;
                default:
                    fprintf(stderr, WARN_TXT("Weird value: %i"), result);
                    break;
            }
            prev_result = result;
        }
        sleep(1);
    } while (1);

drive_is_ready:
#ifdef DVD_STUFF
    // Now figure out what kind of disc it is.
    result = ioctl(drive, CDROM_DISC_STATUS, 0);
    printf("CDROM_DISC_STATUS=%i\n", result);

    // Is it a DVD?
    dvd_struct ds;
    ds.type = DVD_STRUCT_PHYSICAL;
    ds.physical.layer_num=0;
    result = ioctl(drive, DVD_READ_STRUCT, &ds);

    if (result == -1) {
        perror("IS_DVD=");
    } else {
        printf("Layer 0: %i to %i.\n", ds.physical.layer[0].start_sector, ds.physical.layer[0].end_sector);
    }
#endif

    close(drive);
}
