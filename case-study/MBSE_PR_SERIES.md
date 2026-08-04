# MBSE Pull Request Series

This series turns the Git learning repository into a small SysML v2 / MBSE collaboration workspace. All links below are real merged Pull Requests.

## PR #3: collaboration foundation

- PR: <https://github.com/veiong/collaboration/pull/3>
- Head: `docs/model-collaboration`
- Strategy: **Create a merge commit**
- Feature commits: `f2b545a`, `8eb6f64`
- Mainline merge commit: `3d1b565`

Result:

```text
*   3d1b565 Merge pull request #3
|\
| * 8eb6f64 map GitHub workflow to Teamwork Cloud
| * f2b545a define SysML v2 model workspace
|/
```

This strategy preserves the fact that the two documentation changes were developed together on one branch.

## PR #4: vehicle structure

- PR: <https://github.com/veiong/collaboration/pull/4>
- Head: `feature/vehicle-structure`
- Strategy: **Squash and merge**
- Feature commits: `e3d3964`, `f574d19`
- Mainline squash commit: `8753f6e`

Feature branch:

```text
e3d3964 model: define vehicle structure and ports
f574d19 docs: explain vehicle structure slice
```

Mainline result:

```text
8753f6e model: add SysML v2 vehicle structure
```

The individual feature commits remain visible in the PR, but they are not ancestors of later `main` commits. The complete model slice enters `main` as one atomic change.

## PR #5: requirements and verification

- PR: <https://github.com/veiong/collaboration/pull/5>
- Head: `feature/requirements-verification`
- Strategy: **Rebase and merge**
- Original feature commits: `91fd890`, `89bc395`
- Rewritten mainline commits: `bb32950`, `fec1fcb`

Result:

```text
fec1fcb docs: add vehicle traceability review matrix
bb32950 model: add vehicle requirements and verification
8753f6e model: add SysML v2 vehicle structure
```

The commit messages and order are retained, but GitHub creates new commit IDs because each change is replayed on the latest `main`.

## Choosing a strategy for model repositories

| Change type | Suggested strategy | Reason |
| --- | --- | --- |
| Cross-package model change with meaningful intermediate commits | Merge commit | Preserves topology and investigation history. |
| Small, single-purpose model slice with noisy work-in-progress commits | Squash | Gives `main` one atomic engineering change. |
| Carefully curated independent commits | Rebase | Keeps a linear history while retaining each logical commit. |

Repository policy should choose a default and document exceptions. A merge strategy only controls Git history; it does not replace model validation or an element-level merge in a modeling repository.

## What Teamwork Cloud adds beyond Git

The MagicDraw 2024x documentation describes Teamwork Cloud as a repository for collaborative development and versioned model storage. It uses delta-based transfer and provides change/history tracking at model-element level. A commit creates a new project version; other team members update their project to merge the server changes into their working version.

For branch merge, Teamwork Cloud Project Merge uses three-way merge and identifies a common ancestor. The default for server branches is the lowest common parent. It can merge with a lock or without a lock; the locked path prevents other commits during the merge and partially locks the affected elements. This is closer to semantic model collaboration than Git's line-oriented merge.

The practical combined workflow is:

```text
Teamwork Cloud update and model-level change
              |
              v
Teamwork Cloud commit / version / element history
              |
              v
Export or synchronize reviewable SysML v2 text
              |
              v
GitHub PR / automated checks / engineering review
              |
              v
Merge only after model and text validation agree
```

## Sources

- [Using Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136712990/Using+Teamwork+Cloud)
- [Committing changes to Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136713197/Committing+changes+to+Teamwork+Cloud)
- [Updating changes from Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136713205/Updating+changes+from+Teamwork+Cloud)
- [Model merge in Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136713397/Model+merge+in+Teamwork+Cloud)
- [Official SysML v2 Release repository](https://github.com/Systems-Modeling/SysML-v2-Release)

