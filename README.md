# pipenv-virtualenvs-maintainer
managing your virtualenvs created by pipenv. You can view a list of virtual environments and delete virtual environments that are no longer needed.

## Support OS
- MacOS (tested on 12.3)
- Linux (not tested)
- Windows (not tested, maybe work with WSL, Cygwin and so on)

## Usage
### 1. Listing virtualenvs
```bash
$ bash list_projects.sh
```

**example**

```bash
PROJECT_PATH	CODE_PATH	UNLINKED	VIRTUALENV_SIZE
/Users/niccari/.local/share/virtualenvs/foo-project-7KRJjpxu/.project	/Users/niccari/dev/foo-project	-	 24M
/Users/niccari/.local/share/virtualenvs/hoge-project-Pw7hUalW/.project	/Users/niccari/dev/hoge-project	-	105M
/Users/niccari/.local/share/virtualenvs/bar-project-NTU4ZjA2/.project	/Users/niccari/dev/bar-project	-	201M
```

### 2. Removing unused(source code has been removed) virtualenvs

```bash
$ bash delete_pipenv_removable_projects.sh
```

**example**

```bash
$ bash delete_unused_projects.sh
## Deletable projects ##
/Users/niccari/.local/share/virtualenvs/hoge-project-Pw7hUalW <-x- /Users/niccari/dev/hoge-project(size: 105M)
/Users/niccari/.local/share/virtualenvs/bar-project-NTU4ZjA2 <-x- /Users/niccari/dev/bar-project(size: 201M)
Delete unused virtualenvs? (y/N): y
succeeded.

$ bash delete_pipenv_removable_projects.sh
no deletable virtualenvs found.
```

## License
MIT

