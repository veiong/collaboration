# GitHub and Teamwork Cloud: Collaboration Mapping

This repository is a learning aid for GitHub collaboration around SysML v2 artifacts. It is not a replacement for Teamwork Cloud.

| Git/GitHub concept | MagicDraw/Cameo + Teamwork Cloud concept | Practical rule |
| --- | --- | --- |
| `clone` / open repository | Log in and open a server project | Start from the latest project version before editing. |
| commit | **Commit Changes To Server** | Add a meaningful comment; Teamwork Cloud creates a new project version. |
| `pull` / update | **Collaborate > Update Project** | Refresh the local project before continuing work. |
| branch | Teamwork Cloud project branch/version line | Record the branch point and intended owner. |
| merge / PR | **Collaborate > Merge From** / Project Merge | Compare source, target, and common ancestor; review model-level changes. |
| file conflict markers | Conflicting model-element changes | Resolve by element meaning, not by blindly choosing one text side. |
| CODEOWNERS / reviewers | Teamwork Cloud roles, package permissions, and project governance | Keep ownership explicit for safety-critical packages. |

## Important differences

Teamwork Cloud is a model repository. Its change protocol is delta-based and its history is tracked at model-element level. Used projects are read-only in the consuming project and are updated to a selected version. Project Merge supports a three-way merge; for Teamwork Cloud projects the lowest common parent is identified as the default ancestor. During a locked merge, changed and merging elements are partially locked and other users cannot commit until the operation is complete.

Git, in contrast, sees text files and resolves line-level conflicts. A Git PR should therefore be treated as the review and automation layer around the textual model, not as proof that two graphical model repositories have merged safely.

## Recommended hand-off

1. Update the Teamwork Cloud project and inspect upcoming changes.
2. Lock the package or elements that need exclusive editing, when the modeling workflow requires it.
3. Make the model change and commit it to Teamwork Cloud with a version comment.
4. Export or synchronize the reviewable SysML v2 text and open a GitHub PR.
5. Review structure, requirements, allocations, and verification evidence.
6. Merge the PR only after the model tool has completed its own element-level merge and validation.

## Official references

- [Using Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136712990/Using+Teamwork+Cloud)
- [Committing changes to Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136713197/Committing+changes+to+Teamwork+Cloud)
- [Updating changes from Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136713205/Updating+changes+from+Teamwork+Cloud)
- [Model merge in Teamwork Cloud](https://docs.nomagic.com/spaces/MD2024x/pages/136713397/Model+merge+in+Teamwork+Cloud)
- [OMG SysML v2 specification](https://www.omg.org/sysml/SysML-2.htm)
- [Official SysML v2 Release examples](https://github.com/Systems-Modeling/SysML-v2-Release/tree/master/sysml/src/examples)

