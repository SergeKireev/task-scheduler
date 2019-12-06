# task-scheduler
Schedule a list of tasks with precedence constraints

Given a list of tasks and a list of precedence constraints, 
task-scheduler schedules the tasks in order to fulfill the constraints

## Input
List of List of String in stdin  
Example: ```[["1", "2", "3"], ["2", "4"]]```  
Which means, execute tasks "1", "2", "3", "4" with constraints:
* "2" comes after "1"
* "3" comes after "2"
* "4" comes after "2"

If the program detects a cycle in the constraints, it throws an error:  
```"Impossible to find a schedule (maybe there is a cycle in the graph?)"```

## Output 
List of String, the tasks in order of execution  
Example: ```["1", "2", "3", "4"]```
