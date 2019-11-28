function hideUserInfoUnlessAdmin() {
  const isAdmin = JSON.parse(document.getElementById('is_admin').value)
  if (isAdmin) return

  const content = document.getElementById('content');
  const info = document.getElementById('my_account_form');
  const warn = document.createElement('p');
  const text = document.createTextNode('Non sei autorizzato a modificare le tue informazioni.');
  
  info.style.display = 'none';
  warn.appendChild(text);
  content.insertBefore(warn, content.childNodes[content.childNodes.length - 2]);
}

$(document).ready(hideUserInfoUnlessAdmin);
