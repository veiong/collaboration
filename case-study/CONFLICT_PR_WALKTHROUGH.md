# 冲突 Pull Request 完整案例

真实 PR：<https://github.com/veiong/collaboration/pull/2>

## 先区分两组“三种方法”

### PR 发生冲突后，更新功能分支的方法

| 方法 | 是否改写功能分支历史 | 推送方式 | 适用情况 |
| --- | --- | --- | --- |
| Merge `main` into feature | 否 | 普通 `git push` | 共享分支，最稳妥；本案例实际采用 |
| Rebase feature onto `main` | 是 | 通常需要 `--force-with-lease` | 个人分支，希望历史线性 |
| GitHub 网页 Resolve conflicts | 否 | GitHub 自动提交 | 简单文本冲突且按钮可用 |

### 冲突解决后，GitHub 最终合并 PR 的方法

| 方法 | `main` 上的结果 | 是否保留分支结构 |
| --- | --- | --- |
| Create a merge commit | 新增一个双父提交 | 是；本案例实际采用 |
| Squash and merge | 将 PR 压缩成一个新提交 | 否 |
| Rebase and merge | 将功能提交重放到 `main`，提交 ID 改变 | 否，历史保持线性 |

一个 PR 最终只能选择其中一种合并方式。解决冲突的方法和最终合并 PR 的方法是两个不同阶段。

## 1. 创建共同基线

先在 `main` 中创建 `case-study/conflict.txt`：

```text
Release owner: unassigned
Release status: draft
```

真实提交与推送输出：

```console
$ git add case-study/conflict.txt
$ git commit -m "test: add shared conflict baseline"
[main 4de773e] test: add shared conflict baseline
 1 file changed, 2 insertions(+)
 create mode 100644 case-study/conflict.txt

$ git push origin main
To https://github.com/veiong/collaboration.git
   f69946d..4de773e  main -> main
```

`4de773e` 将成为后续两个分支的共同祖先。

## 2. 功能分支从 A 迭代到 A1

```console
$ git switch -c feature/conflict-a
Switched to a new branch 'feature/conflict-a'
```

先把共同基线的第一行改为：

```text
Release owner: feature-team-a
```

```console
$ git diff -- case-study/conflict.txt
diff --git a/case-study/conflict.txt b/case-study/conflict.txt
index a4a72c6..451bffb 100644
--- a/case-study/conflict.txt
+++ b/case-study/conflict.txt
@@ -1,2 +1,2 @@
-Release owner: unassigned
+Release owner: feature-team-a
 Release status: draft

$ git add case-study/conflict.txt
$ git commit -m "feat: assign release to feature team A"
[feature/conflict-a 39b0f8c] feat: assign release to feature team A
 1 file changed, 1 insertion(+), 1 deletion(-)
```

再迭代为 A1：

```text
Release owner: feature-team-a1
```

```console
$ git diff -- case-study/conflict.txt
diff --git a/case-study/conflict.txt b/case-study/conflict.txt
index 451bffb..0d991dc 100644
--- a/case-study/conflict.txt
+++ b/case-study/conflict.txt
@@ -1,2 +1,2 @@
-Release owner: feature-team-a
+Release owner: feature-team-a1
 Release status: draft

$ git add case-study/conflict.txt
$ git commit -m "feat: iterate release owner from A to A1"
[feature/conflict-a 56a14f4] feat: iterate release owner from A to A1
 1 file changed, 1 insertion(+), 1 deletion(-)

$ git push -u origin feature/conflict-a
To https://github.com/veiong/collaboration.git
 * [new branch]      feature/conflict-a -> feature/conflict-a
branch 'feature/conflict-a' set up to track 'origin/feature/conflict-a'.
```

## 3. main 修改同一行

切回 `main`，将同一行改成另一个值：

```text
Release owner: main-platform-team
```

```console
$ git switch main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

$ git diff -- case-study/conflict.txt
diff --git a/case-study/conflict.txt b/case-study/conflict.txt
index a4a72c6..eb18fae 100644
--- a/case-study/conflict.txt
+++ b/case-study/conflict.txt
@@ -1,2 +1,2 @@
-Release owner: unassigned
+Release owner: main-platform-team
 Release status: draft

$ git add case-study/conflict.txt
$ git commit -m "feat: assign release to main platform team"
[main 5fcc71d] feat: assign release to main platform team
 1 file changed, 1 insertion(+), 1 deletion(-)

$ git push origin main
To https://github.com/veiong/collaboration.git
   4de773e..5fcc71d  main -> main
```

此时的提交图：

```text
          39b0f8c---56a14f4  feature/conflict-a
         /
4de773e
         \
          5fcc71d            main
```

两个分支都从 `4de773e` 出发，并将 `conflict.txt` 第一行修改成不同内容。

## 4. 创建 PR 并确认冲突

```console
$ gh pr create --repo veiong/collaboration \
    --base main \
    --head feature/conflict-a \
    --title "feat: demonstrate conflicting pull request" \
    --body "..."
https://github.com/veiong/collaboration/pull/2
```

PR 刚创建时，GitHub 后台还没有计算完成：

```json
{
  "mergeStateStatus": "UNKNOWN",
  "mergeable": "UNKNOWN",
  "number": 2,
  "state": "OPEN"
}
```

再次查询后得到稳定状态：

```console
$ gh pr view 2 --repo veiong/collaboration \
    --json number,url,state,mergeable,mergeStateStatus
{"mergeStateStatus":"DIRTY","mergeable":"CONFLICTING","number":2,"state":"OPEN","url":"https://github.com/veiong/collaboration/pull/2"}
```

这就是 GitHub 确认 PR 无法自动合并的证据。

## 5. 方法一：把 main 合并进功能分支

本案例实际采用此方法：

```console
$ git switch feature/conflict-a
Switched to branch 'feature/conflict-a'
Your branch is up to date with 'origin/feature/conflict-a'.

$ git merge main
Auto-merging case-study/conflict.txt
CONFLICT (content): Merge conflict in case-study/conflict.txt
Automatic merge failed; fix conflicts and then commit the result.
```

此时 `git status`：

```console
$ git status
On branch feature/conflict-a
Your branch is up to date with 'origin/feature/conflict-a'.

You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
        both modified:   case-study/conflict.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

Git 写入文件的真实冲突标记：

```text
<<<<<<< HEAD
Release owner: feature-team-a1
=======
Release owner: main-platform-team
>>>>>>> main
Release status: draft
```

含义是：

- `HEAD` 部分来自当前所在的 `feature/conflict-a`。
- 分隔线下方来自正在合入的 `main`。
- Git 不知道应该选择哪一个，因此必须由开发者根据业务语义决定。

本案例决定同时保留双方意图，手工编辑为：

```text
Release owner: feature-team-a1 with main-platform-team review
Release status: draft
```

然后标记冲突已经解决，提交并推送：

```console
$ git add case-study/conflict.txt
$ git status --short
M  case-study/conflict.txt

$ git commit -m "merge: resolve release owner conflict with main"
[feature/conflict-a a52e928] merge: resolve release owner conflict with main

$ git push origin feature/conflict-a
To https://github.com/veiong/collaboration.git
   56a14f4..a52e928  feature/conflict-a -> feature/conflict-a
```

如果不想继续这次本地合并，可在提交前执行：

```bash
git merge --abort
```

## 6. 原 PR 自动恢复为可合并

不需要关闭或重建 PR。推送功能分支后，GitHub 自动重新计算：

```console
$ gh pr view 2 --repo veiong/collaboration \
    --json number,url,state,mergeable,mergeStateStatus
{"mergeStateStatus":"CLEAN","mergeable":"MERGEABLE","number":2,"state":"OPEN","url":"https://github.com/veiong/collaboration/pull/2"}
```

PR 的最终净差异：

```console
$ gh pr diff 2 --repo veiong/collaboration
diff --git a/case-study/conflict.txt b/case-study/conflict.txt
index eb18fae..d3289df 100644
--- a/case-study/conflict.txt
+++ b/case-study/conflict.txt
@@ -1,2 +1,2 @@
-Release owner: main-platform-team
+Release owner: feature-team-a1 with main-platform-team review
 Release status: draft
```

注意比较基准已经是最新 `main`，所以这里只显示从 `main-platform-team` 到人工解决结果的变化。

## 7. 最终使用 Merge commit 合并 PR

```console
$ gh pr merge 2 --repo veiong/collaboration \
    --merge \
    --subject "Merge pull request #2 from veiong/feature/conflict-a" \
    --body "Resolve the intentional release owner conflict and preserve both branch histories."
```

查询结果：

```json
{
  "mergeCommit": {
    "oid": "e394c75ce6c6f363325a5798422d09493b193c74"
  },
  "mergedBy": {
    "login": "veiong"
  },
  "number": 2,
  "state": "MERGED",
  "url": "https://github.com/veiong/collaboration/pull/2"
}
```

拉取 GitHub 上的合并结果：

```console
$ git switch main
$ git pull --ff-only origin main
From https://github.com/veiong/collaboration
 * branch            main       -> FETCH_HEAD
   5fcc71d..e394c75  main       -> origin/main
Updating 5fcc71d..e394c75
Fast-forward
 case-study/conflict.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
```

最终提交图：

```text
*   e394c75 Merge pull request #2 from veiong/feature/conflict-a
|\
| *   a52e928 merge: resolve release owner conflict with main
| |\
| |/
|/|
* | 5fcc71d feat: assign release to main platform team
| * 56a14f4 feat: iterate release owner from A to A1
| * 39b0f8c feat: assign release to feature team A
|/
* 4de773e test: add shared conflict baseline
```

`a52e928` 是在功能分支上解决冲突产生的 merge commit；`e394c75` 是 GitHub 最终合并 PR 产生的 merge commit。这是两个不同阶段，所以会看到两个 merge commit。

## 8. 方法二：使用 rebase 解决同类冲突

本案例没有实际执行 rebase，因为同一个 PR 已经使用 merge 方法解决；对同一个分支同时执行两种方法会改写已经记录的历史。等价流程为：

```bash
git switch main
git pull --ff-only origin main
git switch feature/conflict-a
git rebase main

# Git 停在冲突提交后，编辑冲突文件
git add case-study/conflict.txt
git rebase --continue

# rebase 改写了提交 ID
git push --force-with-lease origin feature/conflict-a
```

取消尚未完成的 rebase：

```bash
git rebase --abort
```

不要在多人共同开发的功能分支上随意 rebase。`--force-with-lease` 会先确认远程分支没有别人刚推送的新提交，比裸 `--force` 更安全。

## 9. 方法三：GitHub 网页解决

对于简单、受支持的文本冲突，PR 页面可能显示 **Resolve conflicts** 按钮：

1. 点击 **Resolve conflicts**。
2. 编辑冲突文件并删除冲突标记。
3. 点击 **Mark as resolved**。
4. 点击 **Commit merge**。

GitHub 会把解决冲突的提交直接写入 PR 的 head 分支。复杂冲突、二进制文件冲突或受保护分支等情况可能无法使用网页按钮，此时应在本地解决。

## 10. 三种最终合并方式的命令

冲突解决并且 PR 变为 `MERGEABLE` 后，三选一：

```bash
# 保留所有提交及分支图
gh pr merge 2 --merge

# 将整个 PR 压缩为 main 上的一个提交
gh pr merge 2 --squash

# 将功能分支提交逐个重放到 main
gh pr merge 2 --rebase
```

本案例使用第一种。PR #2 已经合并，因此后两个命令不能再对 PR #2 执行；要比较三种真实历史，需要使用三个内容等价但彼此独立的 PR。

## 结论

冲突不是 Git 出错，而是 Git 无法替人决定业务含义。Git 能准确找出冲突位置，开发者负责决定最终内容。解决后推送原功能分支，原 PR 会自动更新并重新判断合并状态。
