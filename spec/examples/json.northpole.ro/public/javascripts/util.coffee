window.notify = (text, label) ->
  $("#signup-info")
    .text(text)
    .removeClass()
    .addClass(label)

window.syntaxHighlight = (json) ->
  json = json.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
  json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
    cls = "number"
    if /^"/.test(match)
      if /:$/.test(match)
        cls = "key"
      else
        cls = "string"
    else if /true|false/.test(match)
      cls = "boolean"
    else cls = "null"  if /null/.test(match)
    "<span class=\"" + cls + "\">" + match + "</span>"

window.getDataFromTable = () ->
  obj = {}
  # :gt(0) skips the header
  $('#tryNowTable tr:gt(0)').each (index) ->
    elements = $(this).find('input');
    key = $(elements[0]).val()
    val = $(elements[1]).val()
    if (key != '' && val != '')
      obj[key]=val
  obj

