git log HEAD~1..HEAD --pretty=format:%B > commit.txt && hub pull-request -F commit.txt | pbcopy && rm commit.txt && pbpaste
