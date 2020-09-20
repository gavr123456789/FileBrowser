katana_sources = [
  'main.vala',
  'window.vala',
  'Page.vala',
  'RowWidget.vala'
]

valadeps = [dependency('glib-2.0'), dependency('gobject-2.0')]
model_inc = include_directories('Model')

subdir('Model')
subdir('Console_app')


katana_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('gee-0.8'),
  dependency('libhandy-1', version: '>= 0.90'),
]

gnome = import('gnome')

katana_sources += gnome.compile_resources('katana-resources',
  'katana.gresource.xml',
  c_name: 'katana'
)

executable('katana', katana_sources,
  link_with: model_lib,
  include_directories: model_inc,
  vala_args: '--target-glib=2.50',  dependencies: katana_deps,
  install: true,
)
