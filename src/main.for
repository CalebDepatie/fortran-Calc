module handlers
  use iso_c_binding
  use gtk, only: gtk_application_new, G_APPLICATION_FLAGS_NONE, gtk_application_window_new, &
               & g_signal_connect, gtk_widget_show_all
  use g, only: g_application_run, g_object_unref

  implicit none
  contains

  subroutine activate(app, gdata) bind(c)
    type(c_ptr), value, intent(in) :: app, gdata
    type(c_ptr)                    :: window

    window = gtk_application_window_new(app)
    call gtk_widget_show_all(window)

  end subroutine activate

end module handlers

program calculator
  use handlers
  implicit none

  integer        :: left_val
  integer        :: right_val
  type(c_ptr)    :: app
  integer(c_int) :: status

  app    = gtk_application_new("gtk-fortran.fortran-calc"//c_null_char, &
                                & G_APPLICATION_FLAGS_NONE)

  call g_signal_connect(app, "activate"//c_null_char, c_funloc(activate), c_null_ptr)

  status = g_application_run(app, 0_c_int, c_null_ptr)
  call g_object_unref(app)

end program calculator
