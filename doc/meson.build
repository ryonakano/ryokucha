valadoc = find_program('valadoc')

valadoc_vala_dir = 'docs'
valadoc_target = custom_target(
    'valadoc',
    command: [
        valadoc,
        '--pkg=gio-2.0',
        '--pkg=glib-2.0',
        '--pkg=gobject-2.0',
        '--pkg=gtk4',
        '--pkg=pango',
        libryokucha_sources,
        '--package-name=' + meson.project_name(),
        '--package-version=' + meson.project_version(),
        '--verbose',
        '--force',
        '--use-svg-images',
        '-o', meson.project_source_root() / valadoc_vala_dir,
    ],
    build_by_default: true,
    output: valadoc_vala_dir,
    depends: ryokucha_lib
)
