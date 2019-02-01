#! /usr/bin/python
"""
A script that takes five arguments:
1. The absolute path to the diff file to read.
2. The organization that owns the repo with a PR to be reviewed
3. The project with a PR being reviewed.
4. The PR number that needs to be reviewed.
5. The commit ID being committed to.
6. The authentication token to be used.
7. The github API to use (i.e. api.github.com or corporate.host.name/api)

The script extracts comments prefixed with `{##` from the specified (commented)
diff file and posts them to the specified pull request using the git.ouroath 
Github API.
"""
import requests
import json
import sys

github_url = "https://%s/v3/repos/%s/%s/pulls/%s/comments" % (sys.argv[7], sys.argv[2], sys.argv[3], sys.argv[4])

def post(comment):
    payload = {}
    if comment.has_key("in_reply_to") and comment["in_reply_to"]:
        payload = {
            "body": comment["body"],
            "in_reply_to": int(comment["in_reply_to"])
        }
    else:
        payload = {
            "body": comment["body"],
            "path": comment["path"],
            "position": comment["position"],
            "commit_id": sys.argv[5]
        }
    response = requests.post(github_url, data = json.dumps(payload), auth=("token", sys.argv[6]))
    if response.status_code != 201:
        sys.stderr.write("Failed request: "+ str(response) + response.text)

with open(sys.argv[1], 'r') as diff:
    body = []
    in_reply_to = None
    position = 0
    path = ""
    multi_line_old_comment = False
    multi_line_comment = False
    comments = []
    bracket_count = 0
    file_start = False
    for line in diff:
        if line.startswith("diff"):
            # diff --git a/relative/path b/relative/path
            path = line.split()[3].strip("b/")
            in_reply_to = None
            file_start = True
        elif file_start and line.startswith("@@"):
            position = 0
            file_start = False
        elif line.strip().startswith("{##"):
            bracket_count += 1
            # {##<comment-id> I think blah blah blah. ##}
            in_reply_to = line.split()[0].strip("{##").strip()
            comment = line.strip().strip("{##").strip("##}").strip()
            if in_reply_to:
                # Strip out the comment ID from the comment if one 
                # exists.
                comment = " ".join(comment.split()[1:])
            multi_line_comment = not line.strip().endswith("##}")
            body.append(comment)
            if not multi_line_comment:
                bracket_count -= 1
                comment = {
                    "body": "\n".join(body),
                    "position": position,
                    "path": path,
                    "in_reply_to": in_reply_to or None
                }
                comments.append(comment)
                body = []
        elif multi_line_comment:
            multi_line_comment = not line.strip().endswith("##}")
            body.append(line.strip().strip("##}").strip())
            if not multi_line_comment:
                bracket_count -= 1
                comment = {
                    "body": "\n".join(body),
                    "position": position,
                    "path": path,
                    "in_reply_to": in_reply_to or None
                }
                comments.append(comment)
                body = []
        elif multi_line_old_comment or line.strip().startswith("{#"):
            multi_line_old_comment = not line.strip().endswith("#}")
        else:
            position += 1
    if bracket_count > 0:
        sys.stderr.write("Unbalanced {##. Aborting. Num unbalanced brackets: " + str(bracket_count) + "\n Offending comment: " + "\n".join(body) + "\n")
    else:
        for comment in comments:
            post(comment)
