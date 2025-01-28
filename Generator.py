from tkinter import *
import os
import sys
from utils import *
os.chdir(os.path.dirname(__file__))
mapfile = open("map0.csv", "r")
_map = mapfile.read().split("\n")
mapfile.close()
root = Tk()
_map = [list(_map[i].split(",")) for i in range(len(_map))]
_map = [[int(_map[i][j])for j in range(len(_map[i]))] for i in range(len(_map))]
map_metafile = open("map0_meta.csv", "r")
map_meta = map_metafile.read().split("\n")
map_metafile.close()
map_meta = [i.split(",") for i in map_meta]
map_reprs = []
availible_Inputs = [
    'RPM',
    'Power',
    'Torque',
    'Vol. Eff.',
    'throttle angle',
    'Fuel Flow rate',
    'intake flow rate',
]
availible_Outputs = [
    'Peak Power %',
    'Peak Power RPM',
    'Throttle Idle Min angle',
    'Throttle Idle RPM',
    'Max RPM',
    'Fuel Ratio',
    'Exhaust Effect'
]
def Return(event):
    if event.char == '\r':
        update()
        done= False
        for i in range(len(map_reprs)):
            for j in range(len(map_reprs[i])):
                if map_reprs[i][j] == root.focus_get():
                    map_reprs[i][j+1 if j+1 < len(_map[i]) else 0].focus_set()
                    done=True
                    break
                if done:
                    break
def key(event):
    done = False
    x,y = 0,0
    for i in range(len(map_reprs)):
        for j in range(len(map_reprs[i])):
            if map_reprs[i][j] == root.focus_get():
                done = True
                x,y = i,j
                break
        if done:
            break
    match event.keycode:
        case 38: #up
            if x > 0:
                x-=1
            else:
                x=len(map_reprs)-1
        case 37: #left
            if y > 0:
                y-=1
            else:
                y=len(map_reprs[x])-1
        case 40: #down
            if x < len(map_reprs)-1:
                x+=1
            else:
                x=0
        case 39: #right
            if y < len(map_reprs[x])-1:
                y+=1
            else:
                y=0
    map_reprs[x][y].focus_set()
def update(first=False, window=root):
    global _map
    if not first:
        #update map
        _map = [[int(map_reprs[i][j].get()) for j in range(len(map_reprs[i]))] for i in range(len(map_reprs))]
        minval = min([min(i) for i in _map])
        maxval = max([max(i) for i in _map])
        for i in range(len(_map)): #Rows
            for j in range(len(_map[0])): #Columns
                b=map_reprs[i][j]
                b.config(bg=rgb_to_hex(interpolate_color(_map[i][j],minval,maxval)))  # Red
                b.delete(0, END)
                b.insert(0, str(_map[i][j]))
    else:
        #populate map
        minval = min([min(i) for i in _map])
        maxval = max([max(i) for i in _map])
        for i in range(len(_map)): #Rows
            map_reprs.append([])
            for j in range(len(_map[0])): #Columns
                b = Entry(window, text="",width=10)
                b.grid(row=i, column=j)
                map_reprs[i].append(b)
                b.config(bg=rgb_to_hex(interpolate_color(_map[i][j],minval,maxval)))  # Red
                b.delete(0, END)
                b.insert(0, str(_map[i][j]))
def save():
    _map = [[int(map_reprs[i][j].get()) for j in range(len(map_reprs[i]))] for i in range(len(map_reprs))]
    tunefile = open("main.lua", "w")
    tunefile.write(luatemplate1)
    for i, row in enumerate(_map):
        tunefile.write(f"[{i}] ={"{"}")
        for value in row:
            tunefile.write(f"{value},")
        tunefile.write("},\n")
    metainfofile = open("map0_meta.csv", "r")
    metainfo = metainfofile.read().split("\n")
    metainfofile.close()
    metainfo = [i.split(",") for i in metainfo]
    tunefile.write("['inputs'] = {")
    tunefile.write(metainfo[0][0]+","+metainfo[0][1]+"},")
    tunefile.write("['outputs'] = {")
    tunefile.write(metainfo[0][2]+"},")
    tunefile.write("['scales'] = {")
    tunefile.write(metainfo[0][3]+","+metainfo[0][4]+","+metainfo[0][5]+"},")
    tunefile.write(midportion)
    tunefile.write(f"['size'] = {{{len(_map[0])}, {len(_map)}}}")
    tunefile.write(tailend)
    tunefile.close()
    mapfile = open("map0.csv", "w")
    mapfile.write("\n".join([",".join([str(j) for j in i]) for i in _map]))
    mapfile.close()
Button(root, text="Save", command=save).grid(row=len(map_reprs), column=0)
selected_option = StringVar(root)
Xaxis_dropdown = OptionMenu(root, selected_option, availible_Inputs[int(map_meta[0][0])], *availible_Inputs)
Yaxis_dropdown = OptionMenu(root, selected_option, availible_Inputs[int(map_meta[0][1])], *availible_Inputs)
Output_dropdown = OptionMenu(root, selected_option, availible_Outputs[int(map_meta[0][2])], *availible_Outputs)
X_Scale = Entry(root, text="",width=10)
Y_Scale = Entry(root, text="",width=10)
Output_Scale = Entry(root, text="",width=10)
labels = [
    Label(root, text="X-Axis"),
    Label(root, text="Y-Axis"),
    Label(root, text="Output"),
    Label(root, text="X-Scale"),
    Label(root, text="Y-Scale"),
    Label(root, text="Output-Scale")
]
metainfo  = [
    Xaxis_dropdown,
    Yaxis_dropdown,
    Output_dropdown,
    X_Scale,
    Y_Scale,
    Output_Scale
]
Xaxis_dropdown.grid(row=2, column=1)
Yaxis_dropdown.grid(row=2, column=2)
Output_dropdown.grid(row=2, column=3)
X_Scale.grid(row=2, column=4)
Y_Scale.grid(row=2, column=5)
Output_Scale.grid(row=2, column=6)
labels[0].grid(row=1, column=1)
labels[1].grid(row=1, column=2)
labels[2].grid(row=1, column=3)
labels[3].grid(row=1, column=4)
labels[4].grid(row=1, column=5)
labels[5].grid(row=1, column=6)
root.geometry("1500x800")
def open_map_window():
    window2 = Toplevel(root)
    window2.title("Map 0")
    update(True, window2)
    
root.bind_all('<Return>', Return)
root.bind_all('<Key>', key)
root.after(1000,open_map_window)
root.mainloop()