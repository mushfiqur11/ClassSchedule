# Md. Mushfiqur Rahman
    # ID: 160041011


import os
import numpy as np
import pandas as pd
import pymzn
import time
import sys

def main(argv):

    # Parameters
    try:
        source = argv[0]
    except:
        source = "classDetails.csv"
    
    rooms = 8
    slots = 6
    days = 5


    data = pd.read_csv(source)
#     data = data[0:36]


    classDetails = data.to_numpy(dtype=int).tolist()
    # print(classDetails)
    sections = max(data["Section"].to_numpy(dtype=int))
    teachers = max(data["Teacher"].to_numpy(dtype=int))
    classes = int(len(data))
    print("Teachers: ",teachers)
    print("Sections: ",sections)
    print("Classes: ",classes)
    
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

    print("Starting Model")
    start = time.time()
    newData = pymzn.minizinc(mzn = "master.mzn", data = newDict, solver = pymzn.chuffed)
    end = time.time()
    print("Total time required to run the model ",end-start)


    if len(newData)>0:
        teacherRoutine = newData[0]["teacherRoutine"]
        sectionRoutine = newData[0]["sectionRoutine"]
        roomRoutine = newData[0]["roomRoutine"]

    else:
        print(newData)



    roomRoutine = np.zeros((rooms,days,slots),dtype=int)
    totalClasses = 0
    for i in range(5):
        for j in range(6):
            myRoom = 0
            for k in range(sections):
                if sectionRoutine[k][i][j] > 0:
                    roomRoutine[myRoom][i][j] = sectionRoutine[k][i][j]
                    myRoom += 1
    for rooms in roomRoutine:
        for day in rooms:
            for slot in day:
                if slot > 0:
                    totalClasses += 1

    print(roomRoutine)
    print(totalClasses)
if __name__ == "__main__":
    main(sys.argv[1:])

