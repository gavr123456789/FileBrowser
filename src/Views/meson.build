katana_sources += files(
    'window.vala',
    'Page.vala',
    'RowWidget.vala')

# giodep = dependency('gio-2.0')
# geedep = dependency('gee-0.8')
gtkdep = dependency('gtk+-3.0', version: '>= 3.22')
hdydep = dependency('libhandy-1', version: '>= 0.90')
model_inc = include_directories('../Model')

katana_deps = [
  giodep,
  gtkdep,
  geedep,
  hdydep
]


gnome = import('gnome')

katana_sources += gnome.compile_resources('katana-resources',
  files('katana.gresource.xml'),
  c_name: 'katana'
)

executable('katana', katana_sources,
  link_with: model_lib,
  include_directories: model_inc,
  vala_args: '--target-glib=2.50',  dependencies: katana_deps,
  install: true,
)