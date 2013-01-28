<% if @access.id then %>
  # Hide form for early access and dislpay validation message
  $('.cs-error').text('')
  $('.cs-form').hide ->
    $('.cs-thanks').fadeIn()

<% else %>

  <% @access.errors.messages.each_key do |key| %>
    err = "This email address <%= escape_javascript(@access.errors.messages[key].first) %>"
    $('.cs-error').text err
  <% end %>

<% end %>
