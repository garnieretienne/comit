$(document).ready ->

  # Display gravatar if they exists
  $('#avatars').find('div').each (index, div) ->
    $div = $(div)
    gravatarUrl = $div.attr('data-gravatar')
    $('<img>').attr('src', gravatarUrl).load ->
      $div.append(this).fadeIn()
