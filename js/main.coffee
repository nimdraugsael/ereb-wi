$(document).ready ->

  routes =
    '/': () ->
      $('#test').html('root')
      recentHistory = new RecentHistory('#page_content')
    '/test': () ->
      $('#test').html('/test')
    '/another': () ->
      $('#test').html('/another')

  director.Router(routes).init()

  document.location.hash = '#/' if document.location.hash == ''
