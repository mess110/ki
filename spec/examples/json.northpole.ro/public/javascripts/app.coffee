userCreated = () ->
  notify("user created", "label label-success")
  $("#user").attr('disabled','disabled')
  $("#pass").attr('disabled','disabled')
  $("#signup")
    .blur()
    .fadeOut()
  $("#extra-info").fadeIn()

userNotCreated = (jqXHR) ->
  result = JSON.parse(jqXHR.responseText)
  notify(result['error'], "label label-important")

reqSuccess = (data) ->
  str = JSON.stringify(data, `undefined`, 2)
  output = $('#parsedJson')
  if (output.length > 0)
    output[0].innerHTML = syntaxHighlight(str)

storageNotCreated = (jqXHR) ->
  $('#parsedJson')[0].innerHTML = syntaxHighlight("{}")

signupPage = () ->
  $("#user").focus()
  notify("press enter to submit", "label label-info")

  $("#pass").keypress (event) ->
    if event.which is 13
      event.preventDefault()
      user = $('#user').val()
      pass = $('#pass').val()
      jNorthPole.createUser(user, pass, userCreated, userNotCreated)

addTryRow = (keyVal, valVal) ->
  clone = $('.templateTr').clone().removeClass('templateTr')
  clone.find('.templateKey').val(keyVal)
  clone.find('.templateValue').val(valVal)
  clearButton = clone.find('.clearButton')
  clearButton.show()
  clearButton.click () ->
    $(this).parent().parent().remove()
  $('#tryNowTable tr:last').after(clone)
  $('#tryNowTable tr:last input:first').focus()

tryNowPage = () ->
  npSecret = $('#tryNowTable').data('npsecret')
  npGuestSecret = $('#tryNowTable').data('npguestsecret')

  addTryRow(npSecret, npGuestSecret)
  addTryRow('color', 'green')

  $("#addTableRow").click ->
    addTryRow('', '')

  $("#postButton").click ->
    data = getDataFromTable()
    jNorthPole.createStorage(data, reqSuccess)

  $("#getButton").click ->
    data = getDataFromTable()
    jNorthPole.getStorage(data, reqSuccess)

  $("#putButton").click ->
    data = getDataFromTable()
    jNorthPole.putStorage(data, reqSuccess)

  $("#deleteButton").click ->
    data = getDataFromTable()
    jNorthPole.deleteStorage(data, reqSuccess)

if typeof String::endsWith isnt "function"
  String::endsWith = (suffix) ->
    @indexOf(suffix, @length - suffix.length) isnt -1

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

setActiveMenuClass = () ->
  checkFor = (s) ->
    if document.URL.endsWith(s)
      $('.' + s).addClass('active')

  checkFor 'playground'
  checkFor 'examples'

randomlyFlipBear = () ->
  if Math.random() > 0.5
    $(".bear").toggleClass('flipit')

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

  $('#npAction').click () ->
    verb = $('#verb').text();
    if verb == 'GET'
      verb = 'SEARCH'
    resource = $('#resource').text()
    try
      jsonObj = JSON.parse(($('#playground').val()))
    catch err
      reqSuccess(JSON.parse('{}'))
      return 0

    $.ajax
      type: verb
      url: "/" + resource + ".json"
      data: JSON.stringify(jsonObj)
      success: (data, textStatus, jqXHR) ->
        reqSuccess(data)
      error: (jqXHR, textstatus, errorthrown) ->
        reqSuccess(JSON.parse(jqXHR.responseText))
