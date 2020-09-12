
include "globals.mzn";
include "alldifferent.mzn";
int:days;
set of int: slotsPerDay = 1..6;
int:slots;
set of int: daysPerWeek = 1..5;

set of int: properties = 1..3; 
%property0 = teacher
%property1 = section1
%property2 = section2

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
array[teacherList,daysPerWeek,slotsPerDay] of 0..1: teacherBusy;
array[classList] of int: classCredits;

array[teacherList,daysPerWeek,slotsPerDay] of var classIndex: teacherRoutine;
array[sectionList,daysPerWeek,slotsPerDay] of var classIndex: sectionRoutine;
array[roomList,daysPerWeek,slotsPerDay] of var classIndex: roomRoutine;

% room numbers considered
% (tested)
constraint 
forall(d in daysPerWeek,s in slotsPerDay)
    (
           sum(t in teacherList)
           (if teacherRoutine[t,d,s]!=0 
               then 1 
               else 0 
           endif) <= rooms
    );

% Only assigned sections can attend a class. And a section can attend a class only once in a given day
% (tested)
constraint 
forall(i in classList,sec in sectionList)
    (if classDetails[i,2] != sec /\
        classDetails[i,3] != sec
        then forall(d in daysPerWeek,s in slotsPerDay)
           (sectionRoutine[sec,d,s] != i) 
        else 
          forall(d in daysPerWeek)
            (sum(s in slotsPerDay)
               (if sectionRoutine[sec,d,s] == i 
                   then 1 
                   else 0 
               endif) <= 1)
    endif);

% only assigned teachers will conduct a class and same class will not be repeated in the same day
% (tested)

constraint 
forall(i in classList,t in teacherList)
    (if classDetails[i,1] != t
      then forall(d in daysPerWeek,s in slotsPerDay)
        (teacherRoutine[t,d,s] != i) 
      else forall(d in daysPerWeek)
        (sum(s in slotsPerDay)
        (if teacherRoutine[classDetails[i,1],d,s] == i 
            then 1 
            else 0 
        endif) <= 1)
    endif);

% total hours of each course will be equal to credits
% (tested)

constraint 
forall(i in classList)
    (sum(d in daysPerWeek,s in slotsPerDay)
    (if teacherRoutine[classDetails[i,1],d,s] == i 
        then 1 
        else 0 
    endif) == classCredits[i]
    );



% matching teachers' routine with students'
% (tested)

constraint 
forall(t in teacherList,d in daysPerWeek, s in slotsPerDay)
    (if teacherRoutine[t,d,s] > 0
      then 
        sectionRoutine[classDetails[teacherRoutine[t,d,s],2],d,s] 
            == teacherRoutine[t,d,s] 
        /\ 
        sectionRoutine[classDetails[teacherRoutine[t,d,s],3],d,s] 
            == teacherRoutine[t,d,s]
      else true 
    endif);

% matching students' routine with teachers'
% (tested)

constraint 
forall(sec in sectionList,d in daysPerWeek, s in slotsPerDay)
    (if sectionRoutine[sec,d,s] > 0
      then teacherRoutine[classDetails[sectionRoutine[sec,d,s],1],d,s] 
          == sectionRoutine[sec,d,s]
      else true 
    endif
    );

% considering teacher's availability
% (tested)

constraint
forall(t in teacherList, d in daysPerWeek, s in slotsPerDay)
    (
        if teacherBusy[t,d,s] == 1
        then teacherRoutine[t,d,s] = 0
        else true
        endif
    );

solve satisfy;
