$(document).ready ->

  # Display the 'return home' icon when user hover the blog title.
  $('#header h1').hover ->
    $('#return-home').fadeIn(50)
  , ->
    $('#return-home').fadeOut(50)

  # Change the asterisk icon when user hover a blog title
  $('.post-description').hover ->
    $(this).parent().children('.asterisk').animate {'margin-right': '0.2em'}, 100
  , ->
    $(this).parent().children('.asterisk').animate {'margin-right': '0'}, 100 

