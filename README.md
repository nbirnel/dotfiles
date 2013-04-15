First time setup is not fun:

```cd
git --work-tree=./ --git-dir="./.config/gitp/dot" init
sed 's,\(worktree = \).*,\1../../..' .config/gitp/dot/config /tmp/gitp-cfg
mv /tmp/gitp-cfg .config/gitp/dot/config
git --work-tree=./ --git-dir="./.config/gitp/dot" remote add origin\
  git@github.com:nbirnel/dotfiles.git
echo '[branch "master"]' >>.config/gitp/dot/config
echo '	remote = origin' >>.config/gitp/dot/config
echo '	merge = refs/heads/master' >>.config/gitp/dot/config
echo '/*' >>.config/gitp/dot/info/exclude
echo '!/.config/gitp/dot/info/exclude' >>.config/gitp/dot/info/exclude
#Now is a good time to delete or rename most of your dotfiles
#Otherwise you may have a lot of unpleasant merging.
git --work-tree=./ --git-dir="./.config/gitp/dot" add \
  .config/gitp/dot/info/exclude
git --work-tree=./ --git-dir="./.config/gitp/dot" commit
git --work-tree=./ --git-dir="./.config/gitp/dot" pull
```


