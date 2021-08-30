project('com.github.leggettc18.emojiclip', 'vala', 'c')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

asresources = gnome.compile_resources(
    'as-resources', join_paths('data', 'gresource.xml'),
    source_dir: 'data',
    c_name: 'as'
)

executable(
    meson.project_name(),
    asresources,
    'src' / 'Application.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('glib-2.0'),
        dependency('gdk-x11-3.0'),
        dependency('xtst'),
        dependency('x11'),
        dependency('granite'),
    ],
    install: true
)

subdir('data')
subdir('po')
