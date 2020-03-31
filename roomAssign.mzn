include "globals.mzn";
include "alldifferent.mzn";
int:days;
set of int: slotsPerDay = 1..6;
int:slots;
set of int: daysPerWeek = 1..5;
set of int: properties = 1..3; 

int: classes;
int: rooms;
int: teachers;

set of int: roomList = 1..rooms;
set of int: classList = 1..classes;
set of int: classIndex = 0..classes;
set of int: teacherList = 1..teachers;
set of int: periods = 1..3;

array[classList,properties] of int: classDetails;
array[teacherList,daysPerWeek,slotsPerDay] of classIndex: teacherRoutine;
array[roomList,daysPerWeek,slotsPerDay] of var classIndex: roomRoutine;

set of int: allSlots = 1..rooms*days*slots;
array[classList,periods] of var allSlots: assignedSlots;

%tested
constraint alldifferent(assignedSlots);

constraint
forall(i in classList,p in periods)
    (
        teacherRoutine[classDetails[i,1],getDay(assignedSlots[i,p]),getSlot(assignedSlots[i,p])] == i
    );

%tested
constraint
forall(i in classList,p in periods)
    (
        roomRoutine[getRoom(assignedSlots[i,p]),getDay(assignedSlots[i,p]),getSlot(assignedSlots[i,p])] == i
    );

%tested
constraint
forall(i in classList)
    (
        getDay(assignedSlots[i,1]) < getDay(assignedSlots[i,2]) 
        /\ 
        getDay(assignedSlots[i,2]) < getDay(assignedSlots[i,3])
    );

%tested
function var int: getSlot(var int: x) = if x mod slots == 0 then slots else x mod slots endif;

%tested
function var int: getDay(var int: x) = ((x - getSlot(x)) mod days) + 1 ;

%tested
function var int: getRoom(var int: x) = (x - getSlot(x) - (getDay(x)-1)*slots) div (days*slots) + 1;

%tested
function var int: getExcess(var int: x) = x - (getRoom(x)-1)*days*slots;

solve satisfy;