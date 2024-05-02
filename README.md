# Ryokucha
Ryokucha (緑茶, meaning green tea in Japanese) is a GTK4 library that includes customized widgets I commonly use in my projects.

[API Reference](https://ryonakano.github.io/ryokucha/ryokucha)

## How to Use in Your Project
### Method 1. Flatpak Manifest
If you want to use Ryokucha in a Flatpak app, simply call it as a module in your Flatpak manifest:

```yaml
modules:
  - name: ryokucha
    buildsystem: meson
    sources:
      - type: git
        url: https://github.com/ryonakano/ryokucha.git
        tag: 'x.y.z'
```

Then call `ryokucha` in your meson file:

```meson
executable(
    meson.project_name(),
    'src/Application.vala',
    dependencies: [
        dependency('gtk4'),
        dependency('ryokucha')
    ],
    install: true
)
```

Now you can use Ryokucha in your project.

### Medhod 2. Use as Git Submodule
This library is not (yet) provided as a package for any distributions, so the best way to use it to your project is to embed it as a git submodule:

```bash
git submodule add https://github.com/ryonakano/ryokucha subprojects/ryokucha
```

Load the embeded library as a dependency in the root `meson.build`:

```meson
ryokucha_subproject = subproject('ryokucha')
ryokucha_deps = ryokucha_subproject.get_variable('libryokucha')
```

Add `ryokucha_deps` in the `dependencies` list in your `meson.build`:

```meson
executable(
    meson.project_name(),
    'src/Application.vala',
    dependencies: [
        dependency('gtk4'),
        ryokucha_deps,
    ],
    install: true
)
```

Now you can use Ryokucha in your project.

## Building and Installation
If you mean to perform code changes and create a pull request against this project, you may want to build and install the library from source code.

You'll need the following dependencies:

* libgtk-4-dev
* meson
* valac

Run `meson setup` to configure the build environment and run `meson compile` to build:

```bash
meson setup builddir --prefix=/usr
meson compile -C builddir
```

To install, use `meson install`:

```bash
meson install -C builddir
```
