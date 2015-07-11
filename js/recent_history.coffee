class RecentHistory

  constructor: (wrapper) ->
    @wrapper = wrapper
    @update()

  update: () ->
    @fetch ((data) =>
      @updateTemplate data
    ), false

  updateTemplate: (data) ->
    rows = data.map (run) =>
      """
        <tr>
          <td> #{run.task_id} </td>
          <td> #{run.started_at} </td>
          <td> #{ if run.finished_at? then run.finished_at else run.current } </td>
          <td> #{ if run.exit_code == 0 then 'Success' else 'Fail' } </td>
        <tr>
      """

    html = [
      "<table class='table'>",
      rows.join(''),
      "</table>"
    ].join('')

    $(@wrapper).html html

  fetch: (callback, useStub=false) ->
    if useStub
      stub =
        [
          task_id: 'bar'
          exit_code: 0
          started_at: '2015-07-11 20:05:00'
          finished_at: '2015-07-11 20:10:00'
          current: 'finished'
        ,
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
      url = [window.SERVER_HOST, 'status', 'recent_history'].join('/')
      promise = $.get url

      promise.done (response) ->

        callback JSON.parse(response)

      promise.fail (response) ->
        callback []



module.exports = RecentHistory

