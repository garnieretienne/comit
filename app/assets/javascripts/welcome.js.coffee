$(document).ready ->
  $('#landing-page .part').css('min-height', $(window).height())

  # Smooth scroll
  $('a').smoothScroll();

  # Vertically center the banner
  welcomeScreenHeight = $('#welcome-screen').outerHeight(true)
  simpleHeight = $('#simple').outerHeight(true)
  headerHeight = $('header').outerHeight(true)
  bannerHeight = $('#banner').height()
  marginTop = (welcomeScreenHeight - simpleHeight - bannerHeight - headerHeight) /2 /2
  if marginTop > simpleHeight
    $('#banner').animate({'padding-top': marginTop}, 1000)
