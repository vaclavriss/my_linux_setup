Modular install scripts

Place small installation steps into separate scripts inside this directory.

Usage:

- From the top-level `install.sh` (recommended): it will `source` each module in order.
- To run a single module standalone: `bash modules/20-zsh.sh` (some helpers like `copy_file_if_exists` are defined in top-level `install.sh`, so running standalone may require exporting or redefining them).

Naming:

- Files are prefixed with numbers to control execution order, e.g. `10-basic.sh`, `20-zsh.sh`.
