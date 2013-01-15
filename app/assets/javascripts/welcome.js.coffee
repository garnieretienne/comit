$(document).ready ->
  $('#welcome-page .part').css('min-height', $(window).height())
  $('#landing-page .part').css('min-height', $(window).height())

  # smooth scroll
  $('a').smoothScroll();
