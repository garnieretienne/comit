$(document).ready ->

  # Display the 'return home' icon when user hover the blog title.
  $('#header h1').hover ->
    $('#return-home').fadeIn(50)
  , ->
    $('#return-home').fadeOut(50)

  # Animate post title when user hover it
  $('.post-description').hover ->
    $(this).parent().children('.asterisk').animate {'margin-right': '0.2em'}, 100
  , ->
    $(this).parent().children('.asterisk').animate {'margin-right': '0'}, 100 

  # Animate blog name when user hover it
  $('.blog-description').hover ->
    $(this).parent().children('.typewriter').animate {'margin-right': '0.2em'}, 100
  , ->
    $(this).parent().children('.typewriter').animate {'margin-right': '0'}, 100 

