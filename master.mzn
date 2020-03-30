%%minizinc -m bind

include "globals.mzn";
set of int: slotsPerDay = 1..6;
set of int: daysPerWeek = 1..5;

set of int: properties = 1..3; 
%property0 = teacher
%property1 = section
%property2 = hours per week

int: classes;
int: rooms;
int: sections;
int: teachers;

set of int: sectionList = 1..sections;
set of int: teacherList = 1..teachers;
set of int: roomList = 1..rooms;
set of int: classList = 1..classes;
set of int: classIndex = 0..classes;

array[classList,properties] of int: classDetails;

array[teacherList,daysPerWeek,slotsPerDay] of var classIndex: teacherRoutine;
array[teacherList,daysPerWeek,slotsPerDay] of 0..1: teacherBusy;
array[sectionList,daysPerWeek,slotsPerDay] of var classIndex: sectionRoutine;
array[roomList,daysPerWeek,slotsPerDay] of var classIndex: roomRoutine;

% a class will not be repeated in the same day
constraint 
forall(i in classList, d in daysPerWeek)
    (
        count(teacherRoutine[classDetails[i,1],d,..],i)<=1
    );

% total hours of each course will be equal to the credit hour
constraint 
forall(i in classList)
    (
        sum(d in daysPerWeek)(count(teacherRoutine[classDetails[i,1],d,..],i))==classDetails[i,3]
    );

% matching teacher's routine with students'
constraint 
forall(i in classList,d in daysPerWeek, s in slotsPerDay)
    (
        if teacherRoutine[classDetails[i,1],d,s] == i 
        then sectionRoutine[classDetails[i,2],d,s] == i 
        else true 
        endif
    );

% considering teacher's availability
constraint
forall(t in teacherList, d in daysPerWeek, s in slotsPerDay)
    (
        if teacherBusy[t,d,s] == 1
        then teacherRoutine[t,d,s] = 0
        else true
        endif
    );


solve satisfy;