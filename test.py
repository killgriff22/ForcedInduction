from tkinter import *

root = Tk()
map = []
height = 5
width = 5
for i in range(height): #Rows
    map.append([])
    for j in range(width): #Columns
        b = Entry(root, text="")
        b.grid(row=i, column=j)
        map[i].append(b)

mainloop()