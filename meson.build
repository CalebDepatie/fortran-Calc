project('Calc', ['fortran'])

srcs = ['src/main.for']

add_project_arguments(['-ffree-form'], language : 'fortran')

gtk3 = dependency('gtk-3-fortran')

executable('calc', srcs,
          dependencies : gtk3)
