reqSuccess = (data) ->
  str = JSON.stringify(data, `undefined`, 2)
  output = $('#parsedJson')
  if (output.length > 0)
    output[0].innerHTML = syntaxHighlight(str)

if typeof String::endsWith isnt "function"
  String::endsWith = (suffix) ->
    @indexOf(suffix, @length - suffix.length) isnt -1

setActiveMenuClass = () ->
  checkFor = (s) ->
    if document.URL.endsWith(s)
      $('.' + s).addClass('active')

  checkFor 'playground'
  checkFor 'examples'
  checkFor 'faq'

randomlyFlipBear = () ->
  if Math.random() > 0.5
    $(".bear").toggleClass('flipit')

window.syntaxHighlight = (json) ->
  json = json.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
  json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
    cls = "number value"
    if /^"/.test(match)
      if /:$/.test(match)
        cls = "key"
      else
        cls = "string value"
    else if /true|false/.test(match)
      cls = "boolean value"
    else cls = "null value"  if /null/.test(match)
    "<span class=\"" + cls + "\">" + match + "</span>"

$(document).ready ->
  setActiveMenuClass()
  setInterval(randomlyFlipBear, 1000)

  $('#playground').focus()

  $(".dropdown-menu li a").click () ->
    selText = $(this).text()
    $(this).parents('.btn-group').find('.dropdown-toggle span')[0].innerHTML = selText

  $('#myTab a').click (e) ->
    e.preventDefault()
    $(this).tab('show')
    window.location.hash = $(this)[0].hash

  if window.location.hash?
    $("#myTab a[href='#{window.location.hash}']").tab('show')

  $('#npAction').click () ->
    verb = $('#verb').text();
    verb = 'SEARCH' if verb == 'GET'

    resource = $('#resource').text()
    try
      jsonObj = JSON.parse(($('#playground').val()))
    catch err
      reqSuccess(JSON.parse('{"error": "invalid json input"}'))
      return

    jNorthPole.genericRequest(jsonObj, verb, resource, reqSuccess)
