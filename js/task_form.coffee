class TaskForm

  constructor: (wrapper) ->
    @wrapper = wrapper

  render: (taskId) ->
    @fetch taskId, (data) =>
      @updateTemplate data
      @initEvents()

  initEvents: () ->
    $('#task_form').submit (e) =>
      e.preventDefault()
      data =
        cron_schedule: $('#cron_schedule').val()
        cmd: $('#cmd').val()
      task_id = $('#task_id').val()
      @updateTask(task_id, data)

  updateTask: (taskId, data) ->
    url = [window.SERVER_HOST, 'tasks', taskId].join('/')
    promise = $.post url, JSON.stringify(data)
    promise.done (response) =>
      html = """
      <div class="col-md-4 col-md-offset-4 alert alert-success fade in">
        <a href="#" class="close" data-dismiss="alert">×</a>
        Saved
      </div>
      """
      $(@wrapper).prepend(html)

    promise.fail (response) =>
      html = """
      <div class="col-md-4 col-md-offset-4 alert alert-danger fade in">
        <a href="#" class="close" data-dismiss="alert">×</a>
        Error! Check schedule and cmd
      </div>
      """
      $(@wrapper).prepend(html)



  updateTemplate: (data) ->
    form =
      """
        <div class="row">
          <div class="col-md-6 col-md-offset-3">
            <form id='task_form'>
              <div class="form-group">
                <input type="hidden" id="task_id" value="#{data.config.name}">
                <label for="schedule">Schedule</label>
                <input type="text" class="form-control" id="cron_schedule"
                  value="#{data.config.cron_schedule}" placeholder="Cron schedule">
                <label for="cmd">Cmd</label>
                <input type="text" class="form-control" id="cmd"
                  value="#{data.config.cmd}" placeholder="Cmd">
              </div>
              <button id="task_form__submit" type="submit" class="btn btn-default">Update</button>
            </form>
          </div>
        </div>
      """

    rows = data.runs.map (run) =>
      """
        <tr>
          <td> #{run.started_at} </td>
          <td> #{ if run.finished_at? then run.finished_at else run.current } </td>
          <td> #{ if run.exit_code == 0 then 'Success' else 'Fail' } </td>
          <td> <a href="#"> More </a> </td>
        <tr>
      """

    html = [
      form,
      "<div class='row'>",
      "<br>",
      "<div class='col-md-6 col-md-offset-3'> <table class='table'>",
      rows.join(''),
      "</table></div>",
      "</div>"
    ].join('')

    $(@wrapper).html html

  fetch: (taskId, callback, useStub=false) ->
    if useStub
      stub =
        config:
          cron_schedule: '* * * * *'
          cmd: 'echo foo'
          name: 'foo'
        runs: [
          task_id: 'bar'
          exit_code: 0
          started_at: '2015-07-11 20:05:00'
          finished_at: '2015-07-11 20:10:00'
          current: 'finished'
        ,
          task_id: 'baz'
          started_at: '2015-07-11 20:05:00'
          current: 'started'
        ,
          task_id: 'foo'
          exit_code: -1
          started_at: '2015-07-11 20:05:00'
          finished_at: '2015-07-11 20:10:00'
          current: 'finished'
        ]
      callback(stub)
    else
      url = [window.SERVER_HOST, 'tasks', taskId].join('/')
      promise = $.get url

      promise.done (response) ->

        callback JSON.parse(response)

      promise.fail (response) ->
        callback []



module.exports = TaskForm
