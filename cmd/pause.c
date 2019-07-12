#include <unistd.h>
#include <signal.h>

static void
nop(int sig)
{
}

int
main()
{
  signal(SIGTERM, nop);
  signal(SIGINT, nop);
  signal(SIGHUP, SIG_IGN);

  pause();

  return 0;
}

