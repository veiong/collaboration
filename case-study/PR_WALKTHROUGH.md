# Pull Request 完整案例：主线与功能分支同时前进

真实 PR：<https://github.com/veiong/collaboration/pull/1>

## 场景

1. 从 `main` 创建 `feature/a`。
2. `feature/a` 提交功能版本 `A`。
3. `feature/a` 再提交迭代版本 `A1`。
4. `main` 独立提交版本 `M1`。
5. 创建从 `feature/a` 到 `main` 的 Pull Request。
6. GitHub 判断没有冲突，通过 merge commit 合并。

这里的 `A1` 表示 `feature/a` 上的第二次迭代提交，不是另一个 Git 分支。

## 1. 操作前的状态

```console
$ git status --short --branch
## main...origin/main

$ git log --oneline --graph --decorate --all
*   d8c7e12 (HEAD -> main, origin/main) merge: complete first branch exercise
|\
| * 0dcc7bd (origin/feature/first-merge, feature/first-merge) docs: add first branch exercise
|/
* 7b76cb7 chore: initialize Git collaboration lab
```

## 2. 创建 feature/a 并提交版本 A

```console
$ git switch -c feature/a
Switched to a new branch 'feature/a'
```

创建 `case-study/feature-a.txt`：

```text
Feature version: A
Status: initial implementation
```

```console
$ git status --short
?? case-study/

$ git add case-study/feature-a.txt
$ git commit -m "feat: add feature A"
[feature/a 986c85f] feat: add feature A
 1 file changed, 2 insertions(+)
 create mode 100644 case-study/feature-a.txt
```

## 3. 在 feature/a 上迭代到 A1

将 `case-study/feature-a.txt` 修改为：

```text
Feature version: A1
Status: iteration completed
Change: refined after the initial A implementation
```

修改差异与提交日志：

```console
$ git diff -- case-study/feature-a.txt
diff --git a/case-study/feature-a.txt b/case-study/feature-a.txt
index 297a246..aee605e 100644
--- a/case-study/feature-a.txt
+++ b/case-study/feature-a.txt
@@ -1,2 +1,3 @@
-Feature version: A
-Status: initial implementation
+Feature version: A1
+Status: iteration completed
+Change: refined after the initial A implementation

$ git add case-study/feature-a.txt
$ git commit -m "feat: iterate feature A to A1"
[feature/a 92f2253] feat: iterate feature A to A1
 1 file changed, 3 insertions(+), 2 deletions(-)
```

推送远程功能分支：

```console
$ git push -u origin feature/a
remote: Create a pull request for 'feature/a' on GitHub by visiting:
remote:      https://github.com/veiong/collaboration/pull/new/feature/a
To https://github.com/veiong/collaboration.git
 * [new branch]      feature/a -> feature/a
branch 'feature/a' set up to track 'origin/feature/a'.
```

## 4. main 独立向前推进到 M1

```console
$ git switch main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
```

在主线上创建 `case-study/main-v2.txt`：

```text
Main version: M1
Status: main advanced while feature/a was in development
```

```console
$ git add case-study/main-v2.txt
$ git commit -m "feat: advance main to M1"
[main b1d83ec] feat: advance main to M1
 1 file changed, 2 insertions(+)
 create mode 100644 case-study/main-v2.txt

$ git push origin main
To https://github.com/veiong/collaboration.git
   d8c7e12..b1d83ec  main -> main
```

这时已经形成目标场景：

```console
$ git log --oneline --graph --decorate --all
* b1d83ec (HEAD -> main, origin/main) feat: advance main to M1
| * 92f2253 (origin/feature/a, feature/a) feat: iterate feature A to A1
| * 986c85f feat: add feature A
|/
*   d8c7e12 merge: complete first branch exercise
```

含义如下：

- `d8c7e12` 是两个分支的共同祖先。
- `main` 独立增加了 `b1d83ec`。
- `feature/a` 独立增加了 `986c85f` 和 `92f2253`。

## 5. 创建真实 Pull Request

```console
$ gh pr create --repo veiong/collaboration \
    --base main \
    --head feature/a \
    --title "feat: merge feature A1 into main" \
    --body "..."
https://github.com/veiong/collaboration/pull/1
```

这里最关键的参数是：

- `--base main`：准备接收修改的目标分支。
- `--head feature/a`：提供修改的来源分支。

## 6. GitHub 检查 PR

执行：

```console
$ gh pr view 1 --repo veiong/collaboration \
    --json number,title,url,state,mergeable,mergeStateStatus,baseRefName,headRefName,commits,files
```

GitHub 返回的关键结果：

```json
{
  "baseRefName": "main",
  "headRefName": "feature/a",
  "mergeStateStatus": "CLEAN",
  "mergeable": "MERGEABLE",
  "number": 1,
  "state": "OPEN",
  "title": "feat: merge feature A1 into main",
  "url": "https://github.com/veiong/collaboration/pull/1"
}
```

PR 中识别到两个功能分支提交：

```text
986c85f feat: add feature A
92f2253 feat: iterate feature A to A1
```

PR 文件差异：

```console
$ gh pr diff 1 --repo veiong/collaboration
diff --git a/case-study/feature-a.txt b/case-study/feature-a.txt
new file mode 100644
index 0000000..aee605e
--- /dev/null
+++ b/case-study/feature-a.txt
@@ -0,0 +1,3 @@
+Feature version: A1
+Status: iteration completed
+Change: refined after the initial A implementation
```

注意：PR 展示的是功能分支带来的最终净变化。因此版本 `A` 被 `A1` 替换后，Files changed 页面显示的是最终的 `A1` 内容，而不是先添加 `A` 再修改成 `A1` 的两个中间画面。两个过程仍完整保留在 Commits 页面。

检查 CI 状态：

```console
$ gh pr checks 1 --repo veiong/collaboration
no checks reported on the 'feature/a' branch
```

这表示仓库没有配置 CI 检查，不表示检查失败。

## 7. 在 GitHub 上合并 PR

本案例选择 `Create a merge commit`：

```console
$ gh pr merge 1 --repo veiong/collaboration \
    --merge \
    --subject "Merge pull request #1 from veiong/feature/a" \
    --body "Merge feature A1 after main advanced to M1."
```

该命令成功时没有输出。再次查询 PR：

```json
{
  "baseRefName": "main",
  "headRefName": "feature/a",
  "mergeCommit": {
    "oid": "c1aa8fe2d540e9b6dde95bddbebc59f813b42128"
  },
  "mergedBy": {
    "login": "veiong"
  },
  "number": 1,
  "state": "MERGED",
  "url": "https://github.com/veiong/collaboration/pull/1"
}
```

## 8. 将 GitHub 的合并结果拉回本地

合并发生在 GitHub 上，所以此时本地 `main` 还停留在 `b1d83ec`。执行：

```console
$ git pull --ff-only origin main
From https://github.com/veiong/collaboration
 * branch            main       -> FETCH_HEAD
   b1d83ec..c1aa8fe  main       -> origin/main
Updating b1d83ec..c1aa8fe
Fast-forward
 case-study/feature-a.txt | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 case-study/feature-a.txt
```

最终提交图：

```console
$ git log --oneline --graph --decorate --all
*   c1aa8fe (HEAD -> main, origin/main) Merge pull request #1 from veiong/feature/a
|\
| * 92f2253 (origin/feature/a, feature/a) feat: iterate feature A to A1
| * 986c85f feat: add feature A
* | b1d83ec feat: advance main to M1
|/
*   d8c7e12 merge: complete first branch exercise
```

这说明 merge commit `c1aa8fe` 有两个父提交：

1. `b1d83ec`：合并前最新的 `main`。
2. `92f2253`：合并前最新的 `feature/a`。

GitHub 并没有要求功能分支必须包含最新的 `main`。它以共同祖先 `d8c7e12` 为起点，计算两边分别发生的修改；由于双方修改不同文件，可以自动组成一个合并结果。

## 结论

主线在功能分支创建后继续前进，不会让 PR 自动失效。GitHub 会持续使用最新的 base 分支重新判断合并状态：

- `MERGEABLE` + `CLEAN`：可以自动合并。
- 修改相互兼容：GitHub 创建合并结果。
- 修改同一位置且无法自动判断：显示冲突，需要先更新功能分支并解决冲突。
