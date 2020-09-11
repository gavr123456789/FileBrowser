project('vala app', 'vala', 'c')

dependencies = [
    dependency('glib-2.0'),
    dependency('gee-0.8'),
]

add_global_arguments('--enable-experimental-non-null', language:'vala')

# add_project_arguments('-Warray-bounds', language:'c')
# add_project_arguments('-fstack-protector-all', language:'c')
# add_project_arguments('-Wall', language:'c')
# add_project_arguments('-O2', language:'c')
 
sources = files('DirectoryNavigator.vala','DirectoryMenu.vala')

executable('ModelTest', sources, dependencies: dependencies)