$(document).ready ->

  # Display the form to add a new blog
  $('#build-form').click (e) ->
    e.preventDefault()
    $('#new-blog').fadeToggle 200, ->
      $('#blog_name').focus()

  # Display the personnal information form
  $('#edit-personnal').click (e) ->
    e.preventDefault()
    $('#personnal-information').fadeToggle 200, ->
      $('#user_name').focus()

  # Display the account eraser button
  $('#delete-my-account').click (e) ->
    e.preventDefault()
    $('#delete-my-account-button').fadeToggle 200
