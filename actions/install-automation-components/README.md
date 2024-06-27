# install-automation-components

This action will install various basic tools/components used during automation, since we are using very thin images when testing. Installs include: `git`, `curl`, `gh` cli, etc.

## Requirements

This action is currently designed to be used in a Debian-based environment — specifically, one using `apt` or `apt-get` as the package manager.

## Usage

### Example

```yaml
steps:
  - name: Install automation components
    uses: neuralmagic/nm-actions/actions/install-automation-components@main
```
