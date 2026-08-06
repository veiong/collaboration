#!/usr/bin/env bash
set -euo pipefail

requirements_file="model/vehicle/requirements.sysml"
verification_file="model/vehicle/verification.sysml"
traceability_file="model/vehicle/TRACEABILITY.md"
failed=0
requirement_names="$(grep -Eo "requirement def [A-Za-z_][A-Za-z0-9_]*" "$requirements_file" | sed "s/requirement def //")"

if [[ -z "$requirement_names" ]]; then
    echo "::error file=${requirements_file}::No requirement definitions found"
    exit 1
fi

while IFS= read -r requirement; do
    if ! grep -Eq "satisfy requirement [A-Za-z_][A-Za-z0-9_]* : ${requirement}" "$requirements_file"; then
        echo "::error file=${requirements_file}::${requirement} has no satisfy relationship"
        failed=1
    fi

    if ! grep -Fq "\`${requirement}\`" "$traceability_file"; then
        echo "::error file=${traceability_file}::${requirement} is missing from the traceability matrix"
        failed=1
    fi

    if ! grep -Eq "objective [A-Za-z_][A-Za-z0-9_]* : ${requirement}" "$verification_file"; then
        echo "::error file=${verification_file}::${requirement} has no verification objective"
        failed=1
    fi
done <<< "$requirement_names"

if [[ "$failed" -ne 0 ]]; then
    echo "MBSE validation failed."
    exit 1
fi

echo "MBSE validation passed."
