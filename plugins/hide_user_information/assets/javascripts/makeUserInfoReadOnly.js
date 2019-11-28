function hideUserInfoUnlessAdmin() {
  var isAdmin = $('#is_admin').val() === 'true'
  if (isAdmin) return false

  var firstName = $('#user_firstname')
  var lastName = $('#user_lastname')
  var email = $('#user_mail')

  var fields = [firstName, lastName, email]

  fields.forEach(function(el) {
    el.prop('disabled', true)
  })

  firstName
    .parent()
    .parent()
    .prepend('<p><em class="info">Non sei autorizzato a modificare questi elementi</em></p>')

  return true
}

$(document).ready(hideUserInfoUnlessAdmin);
