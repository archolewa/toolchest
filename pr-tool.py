#!/usr/local/bin python3
"""
A tool that allows the user to view and reply to PR comments on github from
the command line. For now, it defaults to hitting git.ouroath.com using a
token saved in $GITHUB_TOKEN.

Over time, we'll probably add a configuration file that allows us to customize
these things.

The tool has the following options:
    request-changes
    approve
    reject

The tool also takes in a yaml file formatted as follows:
    relative-path-to-file:
        linenumber: Comment
        linenumber2: Comment2
    review-body: Summary

`relative-path-to-file` entries describe review comments that should appear in
the review. `review-body` is the body of the review (i.e. the comment that's
submitted when the user requests-changes, approves or rejects the PR).

`linenumber` is the line in the file that the comment should appear on. If
`linenumber` is negative (i.e. -20) then it's the number in the original
file. If it's positive (i.e. 20 or +20), then it's the number in the new 
file.

So `pr-tool request-changes comments.yaml` will read in a list of comments
from `comments.yaml` and submit them as a `request-changes` review.

If no file is given, then the status is submitted without any comments.
"""
from __future__ import print_function

import os
import requests
import sys
import yaml

def main():
    arguments = sys.argv
    try: 
        review_status = sys.argv[1]
    except KeyError:
        print("Example usage:")
        print("pr-tool review-status comments.yaml")
        return 0
    try:
        comments = extract_comments(sys.arv[2])
    except IndexError:
        comments = []
    open_review(review_status, comments)

def extract_comments(comments_file_name):
    """
    Given the name of a file containing the review comments for a PR,
    returns a map of maps that map relative-file names to maps that map
    comment position to the comment to post. So if we have the yaml file:

    com/example/foo.java:
        -20: This is a comment.
        +25: This is another comment.
    review-body: This looks pretty good!

    returns
    
    [
        "com/example/foo.java"=[
            6="This is a comment.",
            7="This is another comment."
        ]
    ]

    Note that this function converts the line numbers to the position in the
    github diff.

    If there is no position for a given file, this function raises a ValueError
    with an error message that points out the bad line number.
    """
    with open(comments_file_name, 'r') as comments:
        yaml_dictionary = yaml.load(comments)
    git_token = os.environ['GITHUB_TOKEN']
    # Need to work on extracting the owner and repo from git remote -v origin.
    pr_diff = requests.get('https://api.git.ouroath.com/api3/v3/repos

main()
