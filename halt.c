#include <sys/reboot.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/utsname.h>

#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <utmp.h>

extern char *__progname;

typedef enum {NOOP, HALT, REBOOT, POWEROFF} action_type;

#ifndef OUR_WTMP
#define OUR_WTMP "/var/log/wtmp"
#endif

#ifndef OUR_UTMP
#define OUR_UTMP "/run/utmp"
#endif

void write_wtmp(int boot) {
  int fd;

  if ((fd = open(OUR_WTMP, O_WRONLY|O_APPEND)) < 0)
    return;

  struct utmp utmp = {0};
  struct utsname uname_buf;
  struct timeval tv;

  gettimeofday(&tv, 0);
  utmp.ut_tv.tv_sec = tv.tv_sec;
  utmp.ut_tv.tv_usec = tv.tv_usec;

  utmp.ut_type = boot ? BOOT_TIME : RUN_LVL;

  strncpy(utmp.ut_name, boot ? "reboot" : "shutdown", sizeof utmp.ut_name);
  strncpy(utmp.ut_id , "~~", sizeof utmp.ut_id);
  strncpy(utmp.ut_line, boot ? "~" : "~~", sizeof utmp.ut_line);
  if (uname(&uname_buf) == 0)
    strncpy(utmp.ut_host, uname_buf.release, sizeof utmp.ut_host);

  write(fd, (char *)&utmp, sizeof utmp);
  close(fd);

  if (boot) {
    if ((fd = open(OUR_UTMP, O_WRONLY|O_APPEND)) < 0)
      return;
    write(fd, (char *)&utmp, sizeof utmp);
    close(fd);
  }
}

int main(int argc, char *argv[]) {
  int do_sync = 1;
  int do_force = 0;
  int do_wtmp = 1;
  int opt;
  action_type action = NOOP;

  if (strncmp(__progname, "halt", 4) == 0)
    action = HALT;
  else if (strncmp(__progname, "reboot", 6) == 0)
    action = REBOOT;
  else if (strncmp(__progname, "poweroff", 8) == 0)
    action = POWEROFF;
  else
    warnx("no default behavior, needs to be called as halt/reboot/poweroff.");

  while ((opt = getopt(argc, argv, "dfhinwB")) != -1)
    switch (opt) {
    case 'n':
      do_sync = 0;
      break;
    case 'w':
      action = NOOP;
      do_sync = 0;
      break;
    case 'd':
      do_wtmp = 0;
      break;
    case 'h':
    case 'i':
      /* silently ignored.  */
      break;
    case 'f':
      do_force = 1;
      break;
    case 'B':
      write_wtmp(1);
      return 0;
    default:
      errx(1, "Usage: %s [-n] [-f] [-d] [-w] [-B]", __progname);
    }

  if (do_wtmp)
    write_wtmp(0);

  if (do_sync)
    sync();

  switch (action) {
  case HALT:
    if (do_force)
      reboot(RB_HALT_SYSTEM);
    else
      execl("/bin/runit-init", "init", "0", (char*)0);
    err(1, "halt failed");
    break;
  case POWEROFF:
    if (do_force)
      reboot(RB_POWER_OFF);
    else
      execl("/bin/runit-init", "init", "0", (char*)0);
    err(1, "poweroff failed");
    break;
  case REBOOT:
    if (do_force)
      reboot(RB_AUTOBOOT);
    else
      execl("/bin/runit-init", "init", "6", (char*)0);
    err(1, "reboot failed");
    break;
  case NOOP:
    break;
  }

  return 0;
}
