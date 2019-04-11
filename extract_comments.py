#! /usr/local/bin/python

"""
A script that takes five arguments:
1. The absolute path to the diff file to read.
2. The organization that owns the repo with a PR to be reviewed
3. The project with a PR being reviewed.
4. The PR number that needs to be reviewed.
5. The authentication token to be used.
6. The github API to use (i.e. api.github.com or corporate.host.name/api)

The script will query the Github API for the PR comments, extract the comments body and user ID,
and print out a copy of the diff file that includes the comments in the appropriate spot.
"""

# TODO: There's a bug in here, where the script finds the *first* line in the diff that matches
# the request. That's because we're using a rather naive search. What we should do instead is
# find the position in the diff. That will require a bit more involved use of the data from
# Github however (we'll need to extract the file, find it, and then count positions). So
# I'll work on this in lunch tomorrow.

import json
import requests
import sys

with open(sys.argv[1], 'r') as diff_file:
    diff_lines = diff_file.readlines()

github_url = "https://%s/repos/%s/%s/pulls/%s/comments?sort=created&direction=desc" % (sys.argv[6], sys.argv[2], sys.argv[3], sys.argv[4])
comments_blob = []
while github_url:
    request = requests.get(github_url, auth=("token", sys.argv[5]))
    if request.status_code != 200:
        sys.stderr.write("Failed request: " + str(request))
        sys.exit(1)

    comments_blob.extend(request.json())

    github_url = None
    try:
        links = [link.split(";") for link in request.headers["Link"].split(",")]
    except KeyError:
        pass
    else:
        for link, rel in links:
            if rel.split("=")[1].strip('"') == "next":
                github_url = link.strip().strip("<").strip(">")

commented_line = None
for comment in comments_blob:
    # If a comment doesn't have a position, it's outdated.
    if not comment["position"]:
        continue
    diff_hunk = comment["diff_hunk"].split("\n")
    commented_line = diff_hunk[-1].strip("+").strip("-").strip()
    count = 0
    for line_num, line in enumerate(diff_lines):
        if commented_line in line.strip("{+").strip("+}").strip("{-").strip("-}").strip():
            diff_lines.insert(line_num+1, "{#%s %s:%s #}\n" % (comment["id"], comment["user"]["login"], comment["body"]))
            commented_line = None
            break
    if commented_line:
        sys.stderr.write("\nWARNING: Failed to find blob for " + diff_hunk[0] + " body: " + comment["body"] + "\n")
print(''.join(diff_lines).encode("utf-8"))
