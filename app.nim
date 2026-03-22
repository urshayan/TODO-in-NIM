import std/strformat
import std/strutils
import std/sequtils

type 
  TaskStatus = enum
      Todo, Doing, Done

  Task = object
        description: string
        status: TaskStatus
        t_id: int 


# helpers
proc getStatusfromString() : TaskStatus =
  echo "1.TODO 2.DOING 3.Done"
  


# initialize 
var todolist: seq[Task] = @[]
var nextID = 0;

#show tasks 
proc showtasks() =
    if len(todolist) == 0:
      echo "No Tasks Added...."

    for i,task in todolist:
      let statusStr = $task.status
      let id = $task.t_id
      echo &"{id}. [{statusStr}] {task.description}"
 


#add task
proc addTask(desc: string) =
    let newTask: Task = Task(description: desc, status: Todo, t_id: nextID)
    todolist.add(newTask)
    inc nextID


# discard Task
proc discardTask(id: int) =

  for i in 0 ..< todolist.len:
    if todolist[i].t_id == id:
        echo "Deleted Task : " , todolist[i].description
        del(todolist, i)
        
        break
    else:
      echo "Invalid Id!"

# update Task 
proc updateTask(id: int, newenum: int) =
    for i in 0 ..< todolist.len:
      if todolist[i].t_id == id:
        todolist[i].status = TaskStatus(newenum)
        echo "Status Changed!"
        break
      else:
        echo "Invalid ID"



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
        echo "0.TODO 1.DOING 2.DONE"
        var newenum: int = parseInt(readline(stdin))
        updateTask(target,newenum)


    if choice == 4 :
      echo "Enter the Task-ID to Remove: "
      var target: int = parseInt(readline(stdin))
      discardTask(target)
  

when isMainModule:
  menu()





