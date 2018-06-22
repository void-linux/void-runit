#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <limits.h>

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
	char*p, *argv0;
	char *tag = NULL;
	int c;
	int facility = LOG_DAEMON;
	int level = LOG_INFO;

	argv0 = *argv;

	if (strcmp(argv0, "./run") == 0) {
		p = getcwd(pwd, sizeof (pwd));
		if (p != NULL && *pwd == '/') {
			if (*(p = pwd+(strlen(pwd)-1)) == '/')
				*p = '\0';
			if ((p = strrchr(pwd, '/')) && strncmp(p+1, "log", 3) == 0 &&
			    (*p = '\0', (p = strrchr(pwd, '/'))) && (*(p+1) != '\0')) {
				tag = strdup(p+1);
			}
		}
	}

	while ((c = getopt(argc, argv, "p:t:")) != -1)
		switch (c) {
		case 'p': strpriority(optarg, &facility, &level); break;
		case 't': tag = optarg; break;
		default:
usage:
			fprintf(stderr, "usage: vlogger [-p priority] [-t tag]\n");
			exit(1);
		}

	if (tag == NULL)
		goto usage;

	if (access("/etc/vlogger", X_OK) != -1) {
		execl("/etc/vlogger", argv0, tag, (char *)0);
		fprintf(stderr, "vlogger: exec: %s\n", strerror(errno));
		exit(1);
	}

	openlog(tag, 0, facility);

	char *line = NULL;
	size_t linelen = 0;
	ssize_t rd;
	while ((rd = getline(&line, &linelen, stdin)) != -1) {
		if (line[rd-1] == '\n')
			line[rd-1] = '\0';
		syslog(level|facility, "%s", line);
		free(line);
		line = NULL;
		linelen = 0;
	}

	return 1;
}
