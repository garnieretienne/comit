$(document).ready ->

  # Display the 'return home' icon when user hover the blog title.
  $('#header h1').hover ->
    $('#return-home').fadeIn(50)
  , ->
    $('#return-home').fadeOut(50)

  # Animate post title when user hover it
  $('.post-description').hover ->
    $(this).data('padding-left', parseInt($(this).css('padding-left'), 10)) if !$(this).data('padding-left')
    $(this).animate {'padding-left': ($(this).data('padding-left') + 12)+ 'px'}, 100
  , ->
    $(this).animate {'padding-left': "#{$(this).data('padding-left')}px"}, 100 

  # Animate blog name when user hover it
  $('.blog-description').hover ->
    $(this).parent().children('.typewriter').animate {'margin-right': '0.2em'}, 100
  , ->
    $(this).parent().children('.typewriter').animate {'margin-right': '0'}, 100 

