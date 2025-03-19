# Summary

Used to filter changed files in the current push/pull request.

## Usage

### Inputs

* `include-patterns` (required): one or more newline-separated patterns to match changed files. To match any file, use `.*`.
* `exclude-patterns` (optional): one or more newline-separated patterns to exclude matching changed files. If a file matches an exclude pattern, it will be excluded even if it matches an include pattern.

Notes: Patterns are regex-based, as evaluated by Bash’s `=~` operator.

### Outputs

* `all_changed_files`: space-delimited list of all changed files that match the include pattern(s) but not the exclude pattern(s)

### Example

#### Using with individual pattern values

This will match any changed file unless it's in the root-level `.github` folder.

```yaml
steps:
  - name:
    uses: neuralmagic/nm-actions/actions/changed-files@main
    with:
      include-patterns: .*
      exclude-patterns: ^\.github/*
```

#### Using with multiple pattern values

This will match any file in the root-level `.github` folder, unless it ends in `.md` or `.rst`.

> [!IMPORTANT]
> When using multi-line values, make sure to use the `|-` syntax as below to eliminate trailing newlines.

```yaml
steps:
  - name:
    uses: neuralmagic/nm-actions/actions/changed-files@main
    with:
      include-patterns: |-
        ^\.github/
      exclude-patterns: |-
        \.md$
        \.rst$
```
