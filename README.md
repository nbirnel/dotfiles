First time setup is not fun:

```
dot="./.config/gitp/dot"
cfg="$dot/config"
excl="$dot/info/exclude"
git="git --work-tree=./ --git-dir=$dot"

cd
mkdir -p .config/gitp
$git init
sed 's,\(worktree = \).*,\1../../..,' $cfg >/tmp/gitp-cfg
mv /tmp/gitp-cfg $cfg
$git remote add origin\
  https://github.com/nbirnel/dotfiles.git
# for a trusted machine, use:
# git@github.com:nbirnel/dotfiles.git
echo '[branch "master"]
	remote = origin
	merge = refs/heads/master' >>$cfg
echo '/*
!/.config/
/.config/*
!/.config/gitp/
/.config/gitp/*
!/.config/gitp/dot/
/.config/gitp/dot/*
!/.config/gitp/dot/info/
/.config/gitp/dot/info/*
!/.config/gitp/dot/info/exclude' >>$excl
#Now is a good time to delete or rename most of your dotfiles
#Otherwise you may have a lot of unpleasant merging.
$git add $excl
$git commit
$git pull


```


