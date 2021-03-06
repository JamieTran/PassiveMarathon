library Constants;

import 'package:flutter/material.dart';
import './db_management.dart';

const Color pastel_green = Color(0xFF469DA0);
const Color pastel_yellow = Color(0xFFEBE280);
const Color pastel_red = Color(0xFFBE5968);
const Color pastel_black = Color(0xFF2F343C);
const Color pastel_darkGreen = Color(0xFF97BE54);

const Color nautical_tan = Color(0xFFC9BB89);
const Color nautical_yellow = Color(0xFFF5EF9F);
const Color nautical_lightBlue = Color(0xFF445680);
const Color nautical_mediumBlue = Color(0xFF2E3C61);
const Color nautical_darkBlue = Color(0xFF15264A);

const Color salmon_black = Color(0xFF3E454C);
const Color salmon_darkBlue = Color(0xFF2185C5);
const Color salmon_lightBlue = Color(0xFF7ECEFD);
const Color salmon_eggshell = Color(0xFFFFF6E5);
const Color salmon_orange = Color(0xFFFF7F66);

const Color bright_white = Color(0xfff5f0e7);
const Color bright_red = Color(0xffff461e);
const Color bright_blue = Color(0xff3cbee3);
const Color bright_yellow = Color(0xfffdb321);
const Color bright_purple = Color(0xffa862ac);

const List<Color> placement_colors = [bright_red,bright_blue,bright_yellow,bright_purple,pastel_darkGreen,pastel_red,pastel_black];

const Color place_first = Color(0xFFF2DFA7);
const Color place_second = Color(0xFFF2F2F2);
const Color place_third = Color(0xFFD9AB9A);
const Color place_back = Color(0xFF591902);

const String create_group = 'Create Group';
const String add_group = 'Add Group';
const String leave_group = 'Leave Group';

const int add_friend = 0;
const int remove_friend = 1;
const int join_group = 2;
const int delete_group = 3;
const int exit_group = 4;
const int restart_group = 5;

const String friend_request = 'Friend Request';
const String group_request = 'Group Request';
const String edit_profile = 'Edit';

//TODO: will have to change this to marathon login page
const String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiIxIiwiaXNzIjoiTWFyYXRob24ifQ.1iZiWav2Ya6-jvQLkzQzoOuGCzjBK56R8pAiqnkF2UU";
const String callback = "passivemarathon://";
const String login_url = "https://mrthn.dev/service.html?token=" + token;

// USER/Profile Data

int user_id = 0;
String user_name = "";

DatabaseManagement dbManagement = new DatabaseManagement(); // singleton

const List<String> choices = <String>[
  create_group,
  add_group,
  leave_group,
];

const int add_friend_to_group = 0;