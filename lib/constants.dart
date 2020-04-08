library Constants;

import 'package:flutter/material.dart';

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

const Color place_first = Color(0xFFF2DFA7);
const Color place_second = Color(0xFFF2F2F2);
const Color place_third = Color(0xFFD9AB9A);
const Color place_back = Color(0xFF591902);

const String create_group = 'Create Group';
const String add_group = 'Add Group';
const String leave_group = 'Leave Group';

const String edit_profile = 'Edit';
const int add_friend = 0;
const int remove_friend = 1;

//TODO: will have to change this to marathon login page
const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiIxIiwiaXNzIjoiTWFyYXRob24ifQ.1iZiWav2Ya6-jvQLkzQzoOuGCzjBK56R8pAiqnkF2UU";
const String callback = "passivemarathon://";
const String login_url = "https://api.mrthn.dev/login?service=fitbit&token=" + token;

int user_id = 0;

const List<String> choices = <String>[
  create_group,
  add_group,
  leave_group,
];

const int add_friend_to_group=0;
