# Summary

Used to build and publish packages to internal and public package indexes using tox automation engine.

## Usage

```yaml
steps:
  - name:
    uses: neuralmagic/nm-actions/actions/publisher@main
    with:
      publish_pypi: false
      publish_pypi_internal: true
      timestamp: true
      prefix: "-nightly"
      build_number: ${{ github.event.pull_request.number }}
```
