#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <limits.h>

extern char *__progname;

static char pwd[PATH_MAX];

typedef struct {
  const char *const c_name;
  int c_val;
} CODE;

CODE prioritynames[] = {
	{ "alert", LOG_ALERT },
	{ "crit", LOG_CRIT },
	{ "debug", LOG_DEBUG },
	{ "emerg", LOG_EMERG },
	{ "err", LOG_ERR },
	{ "error", LOG_ERR },
	{ "info", LOG_INFO },
	{ "notice", LOG_NOTICE },
	{ "panic", LOG_EMERG },
	{ "warn", LOG_WARNING },
	{ "warning", LOG_WARNING },
	{ 0, -1 }
};

CODE facilitynames[] = {
	{ "auth", LOG_AUTH },
	{ "authpriv", LOG_AUTHPRIV },
	{ "cron", LOG_CRON },
	{ "daemon", LOG_DAEMON },
	{ "ftp", LOG_FTP },
	{ "kern", LOG_KERN },
	{ "lpr", LOG_LPR },
	{ "mail", LOG_MAIL },
	{ "news", LOG_NEWS },
	{ "security", LOG_AUTH },
	{ "syslog", LOG_SYSLOG },
	{ "user", LOG_USER },
	{ "uucp", LOG_UUCP },
	{ "local0", LOG_LOCAL0 },
	{ "local1", LOG_LOCAL1 },
	{ "local2", LOG_LOCAL2 },
	{ "local3", LOG_LOCAL3 },
	{ "local4", LOG_LOCAL4 },
	{ "local5", LOG_LOCAL5 },
	{ "local6", LOG_LOCAL6 },
	{ "local7", LOG_LOCAL7 },
	{ 0, -1 }
};

static void
strpriority(char *s, int *facility, int *level)
{
	char *p;
	CODE *cp;

	if ((p = strchr(s, '.'))) {
		*p++ = 0;
		for (cp = prioritynames; cp->c_name; cp++) {
			if (strcmp(cp->c_name, p) == 0)
				*level = cp->c_val;
		}
	}
	if (*s)
		for (cp = facilitynames; cp->c_name; cp++) {
			if (strcmp(cp->c_name, s) == 0)
				*facility = cp->c_val;
		}
}

int
main(int argc, char *argv[])
{
	char buf[1024];
	char *p, *argv0;
	char *tag = NULL;
	int c;
	int Sflag = 0;
	int logflags = 0;
	int facility = LOG_USER;
	int level = LOG_NOTICE;

	argv0 = *argv;

	if (strcmp(argv0, "./run") == 0) {
		p = getcwd(pwd, sizeof (pwd));
		if (p != NULL && *pwd == '/') {
			if (*(p = pwd+(strlen(pwd)-1)) == '/')
				*p = '\0';
			if ((p = strrchr(pwd, '/')) && strncmp(p+1, "log", 3) == 0 &&
			    (*p = '\0', (p = strrchr(pwd, '/'))) && (*(p+1) != '\0')) {
				tag = p+1;
				facility = LOG_DAEMON;
				level = LOG_NOTICE;
			}
		}
	} else if (strcmp(__progname, "logger") == 0) {
		/* behave just like logger(1) and only use syslog */
		Sflag++;
	}

	while ((c = getopt(argc, argv, "f:ip:Sst:")) != -1)
		switch (c) {
		case 'f':
			if (freopen(optarg, "r", stdin) == NULL) {
				fprintf(stderr, "vlogger: %s: %s\n", optarg, strerror(errno));
				return 1;
			}
			break;
		case 'i': logflags |= LOG_PID; break;
		case 'p': strpriority(optarg, &facility, &level); break;
		case 'S': Sflag++; break;
		case 's': logflags |= LOG_PERROR; break;
		case 't': tag = optarg; break;
		default:
			fprintf(stderr, "usage: vlogger [-isS] [-f file] [-p pri] [-t tag] [message ...]\n");
			exit(1);
		}
	argc -= optind;
	argv += optind;

	if (argc > 0)
		Sflag++;

	if (!Sflag && access("/etc/vlogger", X_OK) != -1) {
		CODE *cp;
		const char *sfacility = "", *slevel = "";
		for (cp = prioritynames; cp->c_name; cp++) {
			if (cp->c_val == level)
				slevel = cp->c_name;
		}
		for (cp = facilitynames; cp->c_name; cp++) {
			if (cp->c_val == facility)
				sfacility = cp->c_name;
		}
		execl("/etc/vlogger", argv0, tag ? tag : "", slevel, sfacility, (char *)0);
		fprintf(stderr, "vlogger: exec: %s\n", strerror(errno));
		exit(1);
	}

	openlog(tag ? tag : getlogin(), logflags, facility);

	if (argc > 0) {
		size_t len;
		char *p, *e;
		p = buf;
		*p = '\0';
		e = buf + sizeof buf - 2;
		for (; *argv;) {
			len = strlen(*argv);
			if (p + len > e && p > buf) {
				syslog(level|facility, "%s", buf);
				p = buf;
				*p = '\0';
			}
			if (len > sizeof buf - 1) {
				syslog(level|facility, "%s", *argv++);
			} else {
				if (p != buf) {
					*p++ = ' ';
					*p = '\0';
				}
				strncat(p, *argv++, e-p);
				p += len;
			}
		}
		if (p != buf)
			syslog(level|facility, "%s", buf);
		return 0;
	}

	while (fgets(buf, sizeof buf, stdin) != NULL)
		syslog(level|facility, "%s", buf);

	return 0;
}
