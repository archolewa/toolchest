#! /bin/sh
# A script to translate the git remotes into a URL I can plop into a browser.
set +x
git remote -v | cut -f 2 | cut -d " "  -f 1 | sed 's#git@#https://#g' | sed 's#com:#com/#g' | sort | uniq
