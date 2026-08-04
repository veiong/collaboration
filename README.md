# Git Collaboration Lab

这是一个用于练习 Git 与 GitHub 协作流程的仓库，重点是分支、合并和冲突处理。

完整的真实 Pull Request 操作记录见 [`case-study/PR_WALKTHROUGH.md`](case-study/PR_WALKTHROUGH.md)。

## 日常同步

```bash
# 查看当前状态和分支
git status
git branch --show-current

# 获取远程更新，但暂不修改本地文件
git fetch origin

# 拉取并以 rebase 方式应用远程提交
git pull --rebase origin main

# 推送当前分支；第一次推送时建立跟踪关系
git push -u origin <branch-name>
```

## 功能分支与合并

```bash
# 从最新的 main 创建功能分支
git switch main
git pull --rebase origin main
git switch -c feature/my-change

# 修改文件后提交
git add <file>
git commit -m "feat: describe the change"
git push -u origin feature/my-change

# 本地合并练习
git switch main
git merge feature/my-change
git push origin main
```

在 GitHub 上更常见的做法是推送功能分支，然后创建 Pull Request，经检查后合并到 `main`。

## 冲突练习

1. 创建两个分支，并在两个分支中修改 `practice.txt` 的同一行。
2. 先将第一个分支合并到 `main`。
3. 再合并第二个分支，Git 会报告冲突。
4. 编辑冲突文件，删除 `<<<<<<<`、`=======`、`>>>>>>>` 标记并保留正确内容。
5. 执行 `git add practice.txt` 和 `git commit` 完成合并。

如果想放弃尚未完成的合并，可以执行 `git merge --abort`。

## 查看历史

```bash
git log --oneline --graph --decorate --all
```
