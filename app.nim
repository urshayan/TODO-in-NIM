import std/strformat
import std/strutils
import std/sequtils
import std/[json,jsonutils]
 
var TaskStatus: seq[string] = @["TODO","DOING","DONE"] 
type
  Task = object    
    description: string
    status: string
    t_id: int 


# helpers
proc appendJsonToFile(filename: string, jsonStr: string) =
  ## Appends a JSON string to a file, adding a newline for separation.
  var f = open(filename, fmAppend)
  defer: f.close() # Ensures file closes even if error occurs
  f.writeLine(jsonStr)
  


# initialize 
var todolist: seq[Task] = @[]
var nextID = 0;

#show tasks 
proc showtasks() =
    var f: File
    if open(f,"tasks.json",fmRead):
      if getFileSize(f) == 0:
        echo "No Tasks Added Yet!"
        f.close()
        return
    for line in lines("tasks.json"):
      if line.strip() == "": continue # Skip empty lines
      let task = parseJson(line)
      echo "Title: ", task["description"].getStr()
      echo "Task-ID: ", task["t_id"].getint()
      echo "Status: ", task["status"].getStr()
      echo "-------------------"


 


#add task
proc addTask(desc: string) =
    let newTask: Task = Task(description: desc, status:TaskStatus[0] , t_id: nextID)
    todolist.add(newTask)
    inc nextID
    let jsonString = $newTask.toJson()
    appendJsonToFile("tasks.json", jsonString)


# discard Task
proc discardTask(id: int) =
    var updateTasks : seq[string] = @[]

    for line in lines("tasks.json"):
      if line.strip() == "":continue

      let task = parseJson(line)

      if task["t_id"].getInt() != id:
        updateTasks.add(line)

    writeFile("tasks.json", updateTasks.join("\n") & "\n")
    echo "Task Deleted!"



# update Task 
proc updateTask(id: int, newstatus: string) =
    
    var updateTasks : seq[string] = @[]
    var trimmed : seq[string] = @[]
    for line in lines("tasks.json"):
      if line.strip() == "":continue
      let task = parseJson(line)

      if task["t_id"].getInt() == id:

        task["status"] = %newstatus
        updateTasks.add($task)

      else:
        updateTasks.add(line)
    writeFile("tasks.json", updateTasks.join("\n") & "\n")
    echo "Task Updated!"




# menu
proc menu() =

  while true:
    echo "------- TODO IN NIM -------"
    echo "1. Show Tasks"
    echo "2. Add Task"
    echo "3. Update Task Status"
    echo "4. Discard Task/s"
    echo "5. Exit Application"
    echo "----------------------------"

    echo "Enter Your Choice: "
    var input: string = readline(stdin)
    var choice : int = parseInt(input)

    if choice == 1:
     showtasks()

    if choice == 2:
      echo "enter the name of Task: "
      var TaskName: string = readline(stdin)
      addTask(TaskName)

    if choice == 3:
        echo "Enter The Id of Task: "
        var target: int = parseInt(readline(stdin))
        echo "Enter the Update OPTION:  "
        echo "TODO/DOING/DONE"
        var newstring: string = readline(stdin)
        updateTask(target,newstring)

    if choice == 4 :
      echo "Enter the Task-ID to Remove: "
      var target: int = parseInt(readline(stdin))
      discardTask(target)
    if choice == 5:
      echo "Exiting Application"
      break

when isMainModule:
  menu()





