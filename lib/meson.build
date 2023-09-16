libryokucha_sources = files(
    'DropDownText.vala'
)

ryokucha_lib = library(
    'ryokucha',
    libryokucha_sources,
    dependencies: libryokucha_deps,
    vala_header: 'ryokucha.h',
    install: true,
    install_dir: [true, true, true]
)

install_data(
    'ryokucha.deps',
    install_dir: get_option('datadir') / 'vala' / 'vapi'
)

libryokucha = declare_dependency(
    dependencies: libryokucha_deps,
    include_directories: include_directories('.'),
    link_with: ryokucha_lib
)

ryokucha_pc = pkgconfig.generate(
    ryokucha_lib,
    name: 'ryokucha',
    requires: libryokucha_deps,
    subdirs: ['ryokucha'],
    description: 'A GTK4 library that includes customized widgets I commonly use in my projects',
    version: meson.project_version(),
    url: 'https://github.com/ryonakano/ryokucha',
)
