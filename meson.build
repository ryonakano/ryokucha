project('ryokucha',
    'vala', 'c',
    version: '0.1.0'
)

pkgconfig = import('pkgconfig')

libryokucha_deps = [
    dependency('gtk4')
]

subdir('lib')

if get_option('doc')
    subdir('doc')
endif
