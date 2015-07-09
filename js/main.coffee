routes =
  '/': () ->
    $('#test').html('root')
  '/test': () ->
    $('#test').html('/test')
  '/another': () ->
    $('#test').html('/another')

director.Router(routes).init()

