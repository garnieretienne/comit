$(document).ready ->

  # Display the form to add a new blog
  $('#build-form').click (e) ->
    e.preventDefault()
    $('#new-blog').fadeToggle 200, ->
      $('#blog_name').focus()
