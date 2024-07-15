project('ryokucha',
    'vala', 'c',
    version: '0.3.1'
)

pkgconfig = import('pkgconfig')

glib_dep = dependency('glib-2.0')
if glib_dep.version() >= '2.74'
    add_project_arguments('--define=HAS_GLIB_2_74', language: 'vala')
endif

libryokucha_deps = [
    glib_dep,
    dependency('gio-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk4'),
    dependency('pango'),
]

subdir('lib')

if get_option('doc')
    subdir('doc')
endif

if get_option('demo')
    subdir('demo')
endif
