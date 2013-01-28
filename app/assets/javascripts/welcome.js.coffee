$(document).ready ->
  minHeight = if $(window).height() > 800 then $(window).height() else 800 
  $('#landing-page .part').css('min-height', minHeight)

  # Smooth scroll
  $('a').smoothScroll();

  # Vertically center the banner
  window.setTimeout ->
    welcomeScreenHeight = $('#welcome-screen').outerHeight(true)
    simpleHeight = $('#simple').outerHeight(true)
    headerHeight = $('header').outerHeight(true)
    bannerHeight = $('#banner').height()
    marginTop = (welcomeScreenHeight - simpleHeight - bannerHeight - headerHeight) /2 /2
    $('#banner').animate({'padding-top': marginTop}, 1000)
  , 1000
