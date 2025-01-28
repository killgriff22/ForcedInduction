from functions import *
class window:
    def __init__(self, size:tuple[int,int]=None, title:str="Window", screenObject=Toplevel):
        self.size = size
        self.title = title
        self.screen:Tk = screenObject()
        self.screen.title(self.title)
        if self.size != None:
            self.screen.geometry(f"{self.size[0]}x{self.size[1]}")
        self.objects = []
    def clear_window(self):
        for obj in self.objects:
            obj.destroy()
            

class MainWindow(window):
    def __init__(self):
        super().__init__((500,800),title="Projects", screenObject=Tk)
        self.Project = None
        self.Frame = Frame(self.screen)
        self.Frame.grid(row=1,column=1)
        self.screen.after(10,self.populate_Main)
        self.xaxislabel = None
        self.yaxislabel = None
        self.checkboxes:list[Checkbutton] = []
    def populate_Main(self):
        self.objects.append(Button(self.Frame, text="New",command=print))
        self.objects[-1].grid(row=0,column=0)
        for i,folder in enumerate(os.listdir("Projects")):
            if os.path.isdir(f"Projects/{folder}"):
                self.objects.append(Frame(self.Frame))
                self.objects[-1].grid(row=i+1, column=1)
                Label(self.objects[-1], text=folder).grid(row=0,column=0)
                Button(self.objects[-1], text="Open", command=lambda: self.openProject(folder)).grid(row=0,column=1)
                Button(self.objects[-1], text="Delete", command=lambda: self.deleteProject(folder)).grid(row=0,column=2)
    def New_Project(self):
        pass
    def NewMap(self):
        self.clear_window()
        
        self.Project = Project()
        self.Project.maps.append(Map(len(self.Project.maps),self.Project.File,self.screen))
        self.Project.save()
        self.populate_Maps()
        pass
    def deleteMaps(self):
        for i,checkbox in enumerate(self.checkboxes):
            print(i)
            if self.Project.maps[i].selected.get():
                _map = self.Project.maps.pop(i)
                if _map.MapWindow:
                    _map.MapWindow.screen.destroy()
                if _map.SettingsWindow:
                    _map.SettingsWindow.screen.destroy()
                shutil.rmtree("Projects/"+_map.projectfile+"/Maps/")
                self.Project.save()
                break
        self.clear_window()
        self.Project.clear_maps()
        self.populate_Maps()
    def populate_Maps(self):
        self.topframe = Frame(self.screen)
        self.topframe.grid(row=0,column=1)
        self.objects.append(Button(self.screen, text="New Map",command=self.NewMap))
        self.objects[-1].grid(row=0,column=0)
        self.objects.append(Button(self.topframe, text="Save", command=self.Project.save))
        self.objects[-1].grid(row=0,column=1)
        self.objects.append(Button(self.topframe, text="Export to Gearblocks", command=self.Project.export))
        self.objects[-1].grid(row=0,column=2)
        self.objects.append(Button(self.topframe, text="Delete Selected Maps", command=self.deleteMaps))
        self.objects[-1].grid(row=0,column=3)
        for i in range(len(self.Project.maps)):
            self.objects.append(Frame(self.Frame))
            frame = self.objects[-1]
            self.objects[-1].grid(row=i+1, column=1)
            Label(frame, text=str(i)).grid(row=0,column=0)
            self.objects.append(Button(frame, text="Open", command=self.Project.maps[i].openMapWindow))
            self.objects[-1].grid(row=0,column=1)
            self.objects.append(Button(frame, text="Open Settings Window", command=self.Project.maps[i].openSettingsWindow))
            self.objects[-1].grid(row=0,column=2)
            self.objects.append(Button(frame, text="Delete", command=lambda: self.Project.maps[i].delete(self)))
            self.objects[-1].grid(row=0,column=3)
            self.checkboxes.append(Checkbutton(frame,variable=self.Project.maps[i].selected))
            self.checkboxes[-1].grid(row=0,column=4)
    def openProject(self,name):
        self.Project = Project(name,self.screen)
        self.clear_window()
        self.populate_Maps()
        self.screen.title(name)
    def closeProject(self):
        self.Project = None
        pass
    def deleteProject(self,name):
        pass
    def mainloop(self):
        self.screen.mainloop()


class Map:
    def __init__(self,Name, ProjectFile, master):
        self.map = [[0,0],
                    [0,0]]
        self.meta = [[0,0,0,0,0,0],
                     [2,2]]
        self.Name = Name
        self.MapWindow:window = None
        self.SettingsWindow:window = None
        self.projectfile = ProjectFile
        self.selected = BooleanVar(master)
        _map = None
        meta = None
        if os.path.exists(f"Projects/{ProjectFile}/Maps/{Name}"):
            with open(f"Projects/{ProjectFile}/Maps/{Name}/map.csv") as mapfile, open(f"Projects/{ProjectFile}/Maps/{Name}/map_meta.csv") as meta_file:
                _map = mapfile.read()
                meta = meta_file.read()
                meta_file.close()
                mapfile.close()
            meta = [i.split(",") for i in meta.split("\n")]
            _map = _map.split("\n")
            _map = [list(_map[i].split(",")) for i in range(len(_map))]
            _map = [[int(_map[i][j])for j in range(len(_map[i]))] for i in range(len(_map))]
            self.map = _map
            self.meta = meta
    def PopulateGraph(self):
        self.MapWindow.objects.append(Label(self.MapWindow.screen,text=availible_Inputs[int(self.meta[0][0])]))
        self.xaxislabel:Label = self.MapWindow.objects[-1]
        self.MapWindow.objects.append(Label(self.MapWindow.screen,text=availible_Inputs[int(self.meta[0][1])]))
        self.yaxislabel:Label = self.MapWindow.objects[-1]
        self.xaxislabel.grid(row=0,column=1)
        self.yaxislabel.grid(row=1,column=0)
        self.buttonframe = Frame(self.MapWindow.screen)
        self.buttonframe.grid(row=0,column=0)
        self.MapWindow.objects.append(Button(self.buttonframe, text="New Row ",command=self.newrow))
        self.MapWindow.objects[-1].grid(row=0,column=0)
        self.MapWindow.objects.append(Button(self.buttonframe, text="New Col.",command=self.newcol))
        self.MapWindow.objects[-1].grid(row=1,column=0)
        minval = min([min(i) for i in self.map])
        maxval = max([max(i) for i in self.map])
        self.GraphFrame = Frame(self.MapWindow.screen)
        self.GraphFrame.grid(row=1,column=1)
        self.map_reprs = []
        for x in range(len(self.map[0])):
            self.MapWindow.objects.append(Label(self.GraphFrame,text=str(x*int(self.meta[0][4]))))
            self.MapWindow.objects[-1].grid(row=0, column=x)
        for i in range(len(self.map)): #Rows
            self.map_reprs.append([])
            for j in range(len(self.map[0])): #Columns
                b = Entry(self.GraphFrame, text="",width=10)
                self.map_reprs[i].append(b)
                b.grid(row=i+1, column=j+1)
                #rgb_to_hex(interpolate_color(self.map[i][j],minval,maxval))
                b.config(bg=rgb_to_hex(interpolate_color(self.map[i][j]+1,minval+1,maxval+2)))
                b.delete(0, END)
                b.insert(0, str(self.map[i][j]))
    def newrow(self):
        self.map.append([])
        for x in range(len(self.map[0])):
            self.map[-1].append(0)
        self.MapWindow.clear_window()
        self.PopulateGraph()
        self.updateGraph()
    def newcol(self):
        for y in range(len(self.map)):
            self.map[y].append(0)
        self.MapWindow.clear_window()
        self.PopulateGraph()
        self.updateGraph()
    def updateGraph(self):
        close = False
        if not self.SettingsWindow:
            self.openSettingsWindow()
            close=True
        self.meta = [
            [availible_Inputs.index(self.XaxisOption.get()),availible_Inputs.index(self.YaxisOption.get()),availible_Outputs.index(self.OutputOption.get()),self.X_Scale.get(), self.Y_Scale.get(), self.Output_Scale.get()],
            [len(self.map[0]),len(self.map)]
        ]
        self.map = [[int(self.map_reprs[i][j].get() if self.map_reprs[i][j].get().isdecimal() else 0) for j in range(len(self.map_reprs[i]))] for i in range(len(self.map_reprs))]
        minval = min([min(i) for i in self.map])
        maxval = max([max(i) for i in self.map])
        for i in range(len(self.map)): #Rows
            for j in range(len(self.map[0])): #Columns
                b=self.map_reprs[i][j]
                b.config(bg=rgb_to_hex(interpolate_color(self.map[i][j],minval,maxval)))  # Red
                b.delete(0, END)
                b.insert(0, str(self.map[i][j]))
        if close:
            self.SettingsWindow.screen.destroy()
            self.SettingsWindow = None
        pass
    def updateSettings(self):
        pass
    def openSettingsWindow(self):
        self.SettingsWindow = window()
        self.XaxisOption = StringVar(self.SettingsWindow.screen)
        self.XaxisOption.set(availible_Inputs[int(self.meta[0][0])])
        self.Xaxis_dropdown = OptionMenu(self.SettingsWindow.screen, self.XaxisOption, *availible_Inputs)
        self.YaxisOption = StringVar(self.SettingsWindow.screen)
        self.YaxisOption.set(availible_Inputs[int(self.meta[0][1])])
        self.Yaxis_dropdown = OptionMenu(self.SettingsWindow.screen, self.YaxisOption,*availible_Inputs)
        self.OutputOption = StringVar(self.SettingsWindow.screen)
        self.OutputOption.set(availible_Outputs[int(self.meta[0][2])])
        self.Output_dropdown = OptionMenu(self.SettingsWindow.screen, self.OutputOption, *availible_Outputs)
        self.X_Scale = Entry(self.SettingsWindow.screen, text="",width=10)
        self.Y_Scale = Entry(self.SettingsWindow.screen, text="",width=10)
        self.Output_Scale = Entry(self.SettingsWindow.screen, text=str(self.meta[0][5]),width=10)
        self.X_Scale.delete(0, END)
        self.X_Scale.insert(0, str(self.meta[0][3]))
        self.Y_Scale.delete(0, END)
        self.Y_Scale.insert(0, str(self.meta[0][4]))
        self.Output_Scale.delete(0, END)
        self.Output_Scale.insert(0, str(self.meta[0][5]))
        self.labels = [
            Label(self.SettingsWindow.screen, text="X-Axis"),
            Label(self.SettingsWindow.screen, text="Y-Axis"),
            Label(self.SettingsWindow.screen, text="Output"),
            Label(self.SettingsWindow.screen, text="X-Scale"),
            Label(self.SettingsWindow.screen, text="Y-Scale"),
            Label(self.SettingsWindow.screen, text="Output-Scale")
        ]
        self.metainfo  = [
            self.Xaxis_dropdown,
            self.Yaxis_dropdown,
            self.Output_dropdown,
            self.X_Scale,
            self.Y_Scale,
            self.Output_Scale
        ]
        self.Xaxis_dropdown.grid(row=2, column=1)
        self.Yaxis_dropdown.grid(row=2, column=2)
        self.Output_dropdown.grid(row=2, column=3)
        self.X_Scale.grid(row=2, column=4)
        self.Y_Scale.grid(row=2, column=5)
        self.Output_Scale.grid(row=2, column=6)
        self.labels[0].grid(row=1, column=1)
        self.labels[1].grid(row=1, column=2)
        self.labels[2].grid(row=1, column=3)
        self.labels[3].grid(row=1, column=4)
        self.labels[4].grid(row=1, column=5)
        self.labels[5].grid(row=1, column=6)
    def Return(self, event):
        self.updateGraph()
        if event.char == '\r':
            done= False
            for i in range(len(self.map_reprs)):
                for j in range(len(self.map_reprs[i])):
                    if self.map_reprs[i][j] == self.MapWindow.screen.focus_get():
                        self.map_reprs[i][j+1 if j+1 < len(self.map[i]) else 0].focus_set()
                        done=True
                        break
                    if done:
                        break
    def key(self, event):
        self.updateGraph()
        done = False
        x,y = 0,0
        for i in range(len(self.map_reprs)):
            for j in range(len(self.map_reprs[i])):
                if self.map_reprs[i][j] == self.MapWindow.screen.focus_get():
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
                    x=len(self.map_reprs)-1
            case 37: #left
                if y > 0:
                    y-=1
                else:
                    y=len(self.map_reprs[x])-1
            case 40: #down
                if x < len(self.map_reprs)-1:
                    x+=1
                else:
                    x=0
            case 39: #right
                if y < len(self.map_reprs[x])-1:
                    y+=1
                else:
                    y=0
        self.map_reprs[x][y].focus_set()

    def openMapWindow(self):
        self.MapWindow = window(title=self.Name)
        self.PopulateGraph()
        self.MapWindow.screen.bind_all('<Return>', self.Return)
        self.MapWindow.screen.bind_all('<Key>', self.key)
        pass
class Project:
    
    
    def __init__(self,File=None,master=None):
        self.name = "Project"
        self.File = f"{File}"
        self.maps:list[Map] = []
        self.metadata = {}
        self.windows = {
            "MapWindows":[],
            "SettingsWindows":[],
        }
        self.populated = False
        if File:
            if not master:
                raise Exception("Project missing master!")
            self.Open(File, master)
    def save(self,path=None):
        if not path:
            path = f"Projects/{self.File}"
        with open(path+"/main.lua","w") as scriptfile:
            write = """--CONFIG
local SelectorKey = 'tab'
local Maps = {
"""
            for i in range(len(self.maps)):
                self.maps[i].openMapWindow()
                self.maps[i].openSettingsWindow()
                self.maps[i].meta = [
                    [availible_Inputs.index(self.maps[i].XaxisOption.get()),
                     availible_Inputs.index(self.maps[i].YaxisOption.get()),
                     availible_Outputs.index(self.maps[i].OutputOption.get()),
                     self.maps[i].X_Scale.get(), 
                     self.maps[i].Y_Scale.get(), 
                     self.maps[i].Output_Scale.get()],
                    [len(self.maps[i].map[0]),len(self.maps[i].map)]
                ]
                write+=f"\t[{i}] = "+"{\n"
                for y, line in enumerate(self.maps[i].map):
                    write += f"\t\t[{y}] = "+"{"
                    for val in line:
                        write+= str(val)+","
                    write += "},\n"
                write+="\t\t['inputs'] = {"+f"{availible_Inputs.index(self.maps[i].XaxisOption.get())}, {availible_Inputs.index(self.maps[i].YaxisOption.get())}"+"},['outputs'] = { "+f"{availible_Outputs.index(self.maps[i].OutputOption.get())}"+"},['scales'] = { "+f"{self.maps[i].X_Scale.get()}, {self.maps[i].Y_Scale.get()}, {self.maps[i].Output_Scale.get()}"+"},\n"
                write+="""        ['meta']={
            ['window']= nil,
            ['objects'] = {
                ['x_dropdown'] = nil,
                ['y_dropdown'] = nil,
                ['output_dropdown'] = nil,
                ['x_scale'] = nil,
                ['y_scale'] = nil,
                ['output_scale'] = nil,
                ['x'] = nil,
                ['y'] = nil,
                ['output'] = nil,
                ['before'] = nil,
                ['after'] = nil,
                """
                write+="['size'] = {"+str(self.maps[i].meta[1][0])+", "+str(self.maps[i].meta[1][1])+"}\n"
                write+="""
            },
        }
    },
                """
                self.maps[i].MapWindow.screen.destroy()
                self.maps[i].SettingsWindow.screen.destroy()
            write+="}\n"
            write+=Script
            scriptfile.write(write)
            scriptfile.close()
        if not os.path.exists(path+"/Maps/") or not all(m in os.listdir(path+"/Maps/") for m in range(len(self.maps))):
            if not os.path.exists(path+"/Maps/"):
                os.mkdir(path+"/Maps")
            for _i, _map in enumerate(self.maps):
                mapfolder = path+"/Maps/"+str(_i)
                if not os.path.exists(mapfolder):
                    os.mkdir(mapfolder)
                with open(mapfolder+"/map.csv","w") as mapcsv:
                    mapcsv.write("\n".join([",".join([str(j) for j in i]) for i in _map.map]))
                    mapcsv.close()
                with open(mapfolder+"/map_meta.csv","w") as metacsv:
                    metacsv.write("\n".join([",".join([str(j) for j in i]) for i in _map.meta]))
                    metacsv.close()
        if not os.path.exists(path+"/Project.config"):
            with open(path+"/Project.config","w") as config:
                config.write(f"name, {self.name}")
                config.close()
        if not os.path.exists(path+"/meta.json"):
            self.writemeta(path)
    def writemeta(self,path):
        with open(path+"/meta.json","w") as metafile:
            metafile.write("{"+f"""
  "name": "{self.name}",
  "desc": "{self.name} tune made using thisisx-x's Volumetric Tuning mod",
  "tags": [
    "Tuning",
    "{self.name}"
  ],
  "publishedID": 3394381750
"""+"}")
        pass
    def export(self):
        if not os.path.exists(ExportLocation+f"/{self.name}"):
            os.mkdir(ExportLocation+f"/{self.name}")
        self.save()
        self.save(ExportLocation+f"/{self.name}")
    def clear_maps(self):
        self.maps = []
        for i in range(len(os.listdir(f"Projects/{self.File}/Maps/"))):
                self.maps.append(Map(i,self.File, self.master))
    def Open(self,File,master):
        self.master = master
        if os.path.isdir(f"Projects/{File}"):
            with open(f"Projects/{File}/Project.config","r") as f:
                for line in f.read().split("\n"):
                    name, val = line.split(", ")
                    print(name, val)
                    match name:
                        case "name":
                            self.name = val
                f.close()
            for i in range(len(os.listdir(f"Projects/{File}/Maps/"))):
                print(File)
                print(self.File)
                self.maps.append(Map(i,File, master))