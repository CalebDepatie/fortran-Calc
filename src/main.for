module handlers
  use iso_c_binding
  use gtk, only: gtk_application_new, G_APPLICATION_FLAGS_NONE, gtk_application_window_new, &
               g_signal_connect, gtk_widget_show_all, gtk_window_set_title, gtk_container_add, &
               gtk_box_new, GTK_ORIENTATION_VERTICAL, gtk_button_new_with_label, gtk_widget_set_size_request, &
               GTK_ORIENTATION_HORIZONTAL, gtk_text_view_new, gtk_text_view_get_buffer, gtk_text_view_set_editable, &
               gtk_text_view_set_cursor_visible
  use g, only: g_application_run, g_object_unref

  implicit none

  ! ops : add = 1, sub = 2,

  integer(c_int) :: op
  integer(c_int) :: left_value
  integer(c_int) :: right_value
  type(c_ptr)    :: display_buf

  contains

  subroutine activate(app, gdata) bind(c)
    type(c_ptr), value, intent(in) :: app, gdata
    type(c_ptr)                    :: window
    type(c_ptr)                    :: main_box, enter_btn
    type(c_ptr)                    :: num_btn0, num_btn1, num_btn2, num_btn3, num_btn4, num_btn5, &
                                      num_btn6, num_btn7, num_btn8, num_btn9, addsub_btn
    type(c_ptr)                    :: num_box1, num_box2, num_box3, num_box4, txt_view

    window = gtk_application_window_new(app)
    call gtk_window_set_title(window, "Calculator"//c_null_char)
    call gtk_widget_set_size_request(window, 170_c_int, 200_c_int)

    main_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10_c_int)
    call gtk_container_add(window, main_box)

    txt_view = gtk_text_view_new()
    call gtk_text_view_set_editable(txt_view, 0)
    call gtk_text_view_set_cursor_visible(txt_view, 0)
    call gtk_container_add(main_box, txt_view)
    display_buf = gtk_text_view_get_buffer(txt_view)

    num_box1 = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10_c_int)
    call gtk_container_add(main_box, num_box1)
    num_box2 = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10_c_int)
    call gtk_container_add(main_box, num_box2)
    num_box3 = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10_c_int)
    call gtk_container_add(main_box, num_box3)
    num_box4 = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10_c_int)
    call gtk_container_add(main_box, num_box4)

    ! num button setup is not dry, but to my knowledge it could only be made so with a preprocessor
    num_btn1 = gtk_button_new_with_label("1"//c_null_char)
    call gtk_container_add(num_box1, num_btn1)
    call g_signal_connect(num_btn1, "clicked"//c_null_char, c_funloc(num1_btn_clicked))

    num_btn2 = gtk_button_new_with_label("2"//c_null_char)
    call gtk_container_add(num_box1, num_btn2)
    call g_signal_connect(num_btn2, "clicked"//c_null_char, c_funloc(num2_btn_clicked))

    num_btn3 = gtk_button_new_with_label("3"//c_null_char)
    call gtk_container_add(num_box1, num_btn3)
    call g_signal_connect(num_btn3, "clicked"//c_null_char, c_funloc(num3_btn_clicked))

    num_btn4 = gtk_button_new_with_label("4"//c_null_char)
    call gtk_container_add(num_box2, num_btn4)
    call g_signal_connect(num_btn4, "clicked"//c_null_char, c_funloc(num4_btn_clicked))

    num_btn5 = gtk_button_new_with_label("5"//c_null_char)
    call gtk_container_add(num_box2, num_btn5)
    call g_signal_connect(num_btn5, "clicked"//c_null_char, c_funloc(num5_btn_clicked))

    num_btn6 = gtk_button_new_with_label("6"//c_null_char)
    call gtk_container_add(num_box2, num_btn6)
    call g_signal_connect(num_btn6, "clicked"//c_null_char, c_funloc(num6_btn_clicked))

    num_btn7 = gtk_button_new_with_label("7"//c_null_char)
    call gtk_container_add(num_box3, num_btn7)
    call g_signal_connect(num_btn7, "clicked"//c_null_char, c_funloc(num7_btn_clicked))

    num_btn8 = gtk_button_new_with_label("8"//c_null_char)
    call gtk_container_add(num_box3, num_btn8)
    call g_signal_connect(num_btn8, "clicked"//c_null_char, c_funloc(num8_btn_clicked))

    num_btn9 = gtk_button_new_with_label("9"//c_null_char)
    call gtk_container_add(num_box3, num_btn9)
    call g_signal_connect(num_btn9, "clicked"//c_null_char, c_funloc(num9_btn_clicked))

    addsub_btn = gtk_button_new_with_label("+/-"//c_null_char)
    call gtk_container_add(num_box4, addsub_btn)
    call g_signal_connect(addsub_btn, "clicked"//c_null_char, c_funloc(addsub_btn_clicked))

    num_btn0 = gtk_button_new_with_label("0"//c_null_char)
    call gtk_container_add(num_box4, num_btn0)
    call g_signal_connect(num_btn0, "clicked"//c_null_char, c_funloc(num0_btn_clicked))

    enter_btn = gtk_button_new_with_label("<-"//c_null_char)
    call gtk_container_add(num_box4, enter_btn)
    call g_signal_connect(enter_btn, "clicked"//c_null_char, c_funloc(enter_btn_clicked))

    call gtk_widget_show_all(window)
  end subroutine activate

  subroutine enter_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    print *, "test", left_value, " ", right_value
    op          = 0_c_int
    left_value  = 0_c_int
    right_value = 0_c_int
  end subroutine enter_btn_clicked

  subroutine addsub_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    if (op == 1_c_int) then
      op = 2_c_int
    else
      op = 1_c_int
    end if
  end subroutine addsub_btn_clicked

  subroutine writetext() bind(c)
    character(len=5) :: str

    if (op == 1_c_int) then
    else
    endif
  end subroutine writetext

  ! this could be better. it's certainly not DRY and it's just brute forcing
  subroutine num0_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 0_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num0_btn_clicked
  subroutine num1_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 1_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num1_btn_clicked
  subroutine num2_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 2_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num2_btn_clicked
  subroutine num3_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 3_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num3_btn_clicked
  subroutine num4_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 4_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num4_btn_clicked
  subroutine num5_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 5_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num5_btn_clicked
  subroutine num6_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 6_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num6_btn_clicked
  subroutine num7_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 7_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num7_btn_clicked
  subroutine num8_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 8_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num8_btn_clicked
  subroutine num9_btn_clicked(widget, gdata) bind(c)
    type(c_ptr), value, intent(in) :: widget, gdata
    integer(c_int)                 :: num = 9_c_int
    if (op == 0_c_int) then
      left_value = num
    else
      right_value = num
    end if
  end subroutine num9_btn_clicked
end module handlers

program calculator
  use handlers
  implicit none

  type(c_ptr)    :: app
  integer(c_int) :: status

  app    = gtk_application_new("gtk-fortran.fortran-calc"//c_null_char, &
                                & G_APPLICATION_FLAGS_NONE)

  call g_signal_connect(app, "activate"//c_null_char, c_funloc(activate), c_null_ptr)

  status = g_application_run(app, 0_c_int, c_null_ptr)
  call g_object_unref(app)
end program calculator
