class TaskList

  constructor: (wrapper) ->
    @wrapper = wrapper

  render: (taskId, taskRunId) ->
    @fetch taskId, taskRunId, (data) =>
      @updateTemplate data

  updateTemplate: (data) ->
    rows = data.map (task) =>
      """
        <tr>
          <td> <a href="#/tasks/#{task.name}"> #{task.name} </a> </td>
          <td> #{task.cron_schedule} </td>
          <td> #{task.cmd} </td>
        </td>
      """

    html =
      """
        <div class="row">
          <div class="col-md-6 col-md-offset-3">
            <h4> Task list </h4>
            <table class="table">
            <thead>
              <tr>
                <th> Name </th>
                <th> Schedule </th>
                <th> Cmd </th>
              </tr>
            </thead>
              #{ rows.join('') }
            </table>
          </div>
        </div>
      """

    $(@wrapper).html html

  fetch: (taskId, taskRunId, callback, useStub=false) ->
    if useStub
      stub = [
        cron_schedule: '* * * * *'
        cmd: 'echo foo'
        name: 'foo'
      ,
        cron_schedule: '* * * * *'
        cmd: 'echo bar'
        name: 'bar'
      ]
      callback(stub)
    else
      url = [window.SERVER_HOST, 'tasks'].join('/')
      promise = $.get url

      promise.done (response) ->

        callback JSON.parse(response)

      promise.fail (response) ->
        callback []



module.exports = TaskList
