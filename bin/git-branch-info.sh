#/bin/sh
for k in `git branch -r|awk '{print $1}'|grep -v "*"`; do \
  echo `git show --color=always --pretty=format:"%Cgreen%ci %Cblue%cr %Cred%cn %Creset" $k| \
  head -n 1`$k
done | sort
#git for-each-ref --sort='-authordate' --format='%(authordate:short), %(authorname), %(refname:lstrip=2)' 'refs/remotes'
echo "If you're unable to remove a branch, it may already be gone from the remote. \
Try git remote prune origin (git remote prune --dry-run origin) to see what remote branch references will be deleted"
