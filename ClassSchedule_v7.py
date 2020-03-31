
import os
import numpy as np
import pandas as pd
import pymzn
import time


rooms = 8
slots = 6
days = 5


data = pd.read_csv("classDetails.csv")
# data = data[0:36]


classDetails = data.to_numpy(dtype=int).tolist()
# print(classDetails)
sections = max(data["Section"].to_numpy(dtype=int))
teachers = max(data["Teacher"].to_numpy(dtype=int))
classes = int(len(data))
# print(teachers,sections,classes)

tBusy = np.zeros((teachers,5,6))
for i in range(0,6):
    tBusy[0,0,i] = 1
    tBusy[0,1,i] = 1
    tBusy[1,0,i] = 1

teacherBusy = tBusy.astype(int).tolist()


newDict = {}
newDict["days"] = days
newDict["slots"] = slots
newDict["classes"] = classes
newDict["rooms"] = rooms
newDict["sections"] = sections
newDict["teachers"] = teachers
newDict["classDetails"] = classDetails
newDict["teacherBusy"] = teacherBusy

start = time.time()
newData = pymzn.minizinc(mzn = "master_v7.mzn", data = newDict, solver = pymzn.chuffed)
end = time.time()
print(end-start)


if len(newData)>0:
    teacherRoutine = newData[0]["teacherRoutine"]
    sectionRoutine = newData[0]["sectionRoutine"]
    roomRoutine = newData[0]["roomRoutine"]

else:
    print(newData)



roomRoutine = np.zeros((rooms,days,slots),dtype=int)
for i in range(5):
    for j in range(6):
        myRoom = 0
        for k in range(sections):
            if sectionRoutine[k][i][j] > 0:
                roomRoutine[myRoom][i][j] = sectionRoutine[k][i][j]
                myRoom += 1





