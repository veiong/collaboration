# Rejected Pull Request Walkthrough

This branch is an intentionally incomplete MBSE change for learning how a Pull
Request can fail and be closed without merging.

## Intentional defect

`BatteryIsolationRequirement` was added to `requirements.sysml`, and a satisfy
relationship was added, but the change does not include:

1. A row in `model/vehicle/TRACEABILITY.md`.
2. A verification objective in `model/vehicle/verification.sysml`.

The `MBSE validation` GitHub Actions workflow checks both conditions. The PR is
expected to show a failed `model-validation` check and should be closed without
merging.

## What to observe on GitHub

1. The PR remains open while the check is red.
2. The merge button is unavailable while the required check is failing.
3. A reviewer can request changes; the author would push new commits to the
   same branch and the PR would run again.
4. Closing the PR without merging records a rejected change. The branch and
   commits remain available for inspection.

The main branch should continue to contain only the validated model.
