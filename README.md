# README

这里是比较随性地使用中文记录自己对Coq这个语言的理解的场所

## 附录
[删除git仓库历史的方法](https://gist.github.com/stephenhardy/5470814)
```bash
-- Remove the history from 
rm -rf .git

-- recreate the repos from the current content only
git init
git add .
git commit -m "Initial commit"

-- push to the github remote repos ensuring you overwrite history
git remote add origin git@github.com:<YOUR ACCOUNT>/<YOUR REPOS>.git
git push -u --force origin master
```