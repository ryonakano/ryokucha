project('ryokucha',
    'vala', 'c',
    version: '0.2.0'
)

pkgconfig = import('pkgconfig')

libryokucha_deps = [
    dependency('gtk4')
]

subdir('lib')

if get_option('doc')
    subdir('doc')
endif

if get_option('demo')
    subdir('demo')
endif
