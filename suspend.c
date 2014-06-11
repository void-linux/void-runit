/*-
 * Copyright (c) 2014 Juan Romero Pardines.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <getopt.h>

#define SYS_STATE	"/sys/power/state"
#define SYS_DISK	"/sys/power/disk"

#define MODE_RAM	0x1
#define MODE_DISK	0x2

static void
usage(bool fail)
{
	fprintf(stdout,
	    "Usage: suspend [OPTIONS]\n\n"
	    "OPTIONS\n"
	    " -s --show       Show supported modes\n"
	    " -h --help       Show usage\n"
	    " -H --hibernate  Hibernate rather than suspend-to-ram\n\n");
	exit(fail ? EXIT_FAILURE : EXIT_SUCCESS);
}

static int
getmodes(void)
{
	FILE *f;
	char v[LINE_MAX];
	int mode = 0;

	if ((f = fopen(SYS_STATE, "r"))) {
		fgets(v, sizeof(v), f);
		fclose(f);
		if (strstr(v, "mem"))
			mode |= MODE_RAM;
		if (strstr(v, "disk"))
			mode |= MODE_DISK;
	}
	return mode;
}

static void
writemode(int mode)
{
	FILE *f;

	if ((f = fopen("/sys/power/state", "w")) == NULL) {
		perror("cannot open /sys/power/state");
		exit(EXIT_FAILURE);
	}
	if (mode & MODE_RAM) {
		fputs("mem", f);
	} else {
		fputs("disk", f);
	}
	fclose(f);
}

int
main(int argc, char **argv)
{
	const char *shortopts = "shH";
	const struct option longopts[] = {
		{ "show", no_argument, NULL, 's' },
		{ "help", no_argument, NULL, 'h' },
		{ "hibernate", no_argument, NULL, 'H' },
		{ NULL, 0, NULL, 0 }
	};
	int c, modes = 0;
	bool show = false, hibernate = false;

	while ((c = getopt_long(argc, argv, shortopts, longopts, NULL)) != -1) {
		switch (c) {
		case 's':
			show = true;
			break;
		case 'h':
			usage(false);
			/* NOTREACHED */
		case 'H':
			hibernate = true;
			break;
		case '?':
		default:
			usage(true);
			/* NOTREACHED */
		}
	}
	argc -= optind;
	argv += optind;

	if (show) {
		modes = getmodes();
		if (modes & MODE_RAM)
			printf("suspend-to-ram ");
		if (modes & MODE_DISK)
			printf("suspend-to-disk ");

		printf("\n");
	} else if (hibernate) {
		writemode(MODE_DISK);
	} else {
		writemode(MODE_RAM);
	}

	exit(EXIT_SUCCESS);
}
