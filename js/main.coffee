$(document).ready ->
  recentHistory = new RecentHistory('#page_content')
  taskList = new TaskList('#page_content')
  taskForm = new TaskForm('#page_content')
  taskRun = new TaskRun('#page_content')

  routes =
    '/': () ->
      recentHistory.render()
    '/task_list': ->
      taskList.render()
    '/tasks/:taskId': (taskId) ->
      taskForm.render(taskId)
    '/tasks/:taskId/runs/:taskRunId': (taskId, taskRunId) ->
      taskRun.render(taskId, taskRunId)

  director.Router(routes).init()

  document.location.hash = '#/' if document.location.hash == ''
