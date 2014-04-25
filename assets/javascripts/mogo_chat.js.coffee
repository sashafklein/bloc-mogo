MogoChat = {}

#TODO This config should go in the db
MogoChat.config =
  messagesPerLoad: 20

class MogoChat.PluginRegistry
  plugins: []

  all: -> @plugins

  register: (name, regex, callback)->
    for plugin in @plugins
      if plugin.name == name
        throw("Plugin with name \"#{name}\" already registered")
    @plugins.push({name, regex, callback})


  unregister: (name)->
    registeredIndex = null
    for plugin, index in @plugins
      if plugin.name == name
        registeredIndex = index
        break
    return false unless registeredIndex
    @plugins.splice(registeredIndex, 1)[0]


  processMessageBody: (body, type, history = false) ->
    for plugin, index in @plugins
      if body.match(plugin.regex)
        body = plugin.callback(body, type, history)
    body


class MogoChat.PaintBox
  nextColor: 0
  colors: [
    "00adad"
    "0b666b"
    "162d3c"
    "705ca0"
    "f15a24"
    "ff931e"
    "e74c3c"
    "aa0804"
    "e84c3c"
    "66CCFF"
  ]

  getColor: ->
    color = @colors[@nextColor]
    @nextColor = @nextColor + 1
    if @nextColor >= @colors.length
      @nextColor = 0
    "##{color}"


window.MogoChat = MogoChat