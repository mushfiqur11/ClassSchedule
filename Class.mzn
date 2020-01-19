set of int: slotsPerDay = 1..6;
set of int: daysPerWeek = 1..5;

set of int: properties = 1..3; 
%property1 = teacher
%property2 = section
%property3 = hours per week

int: classes = 24;
int: rooms = 6;
int: sections = 6;
int: teachers = 24;

set of int: sectionList = 1..sections;
set of int: teacherList = 1..teachers;
set of int: roomList = 1..rooms;
set of int: classList = 0..classes;

%array[classList,properties] of int: classDetails;

array[teacherList,daysPerWeek,slotsPerDay] of var classList: teacherRoutine;
array[sectionList,daysPerWeek,slotsPerDay] of var classList: sectionRoutine;
array[roomList,daysPerWeek,slotsPerDay] of var classList: roomRoutine;

solve satisfy;

