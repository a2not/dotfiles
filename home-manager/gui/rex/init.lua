-- Next tab on shift+right, previous tab on shift+left, assuming toolbar on "above"
rex.bind("shift+right", "client.tab.next")
rex.bind("shift+left", "client.tab.previous")

-- tmux like bindings
rex.bind("ctrl+b>c", "client.tab.new")
-- rex.bind("ctrl+b>[", "copy_mode")
