# How mouse cursor works

If any of these tasks succeeds, don't move on and please end it there.

1. If mouse on popup, do mouse event on popup
2. If mouse on taskbar, do mouse event on taskbar
3. For all windows, in order of Z on the screen -> into the screen, check if the mouse is on the window.
	1. If the mouse is on the title bar, do mouse event on the window's border.
	2. If the mouse is on the contents, do mouse event.
4. If mouse not on taskbar or windows, do mouse event on desktop

## Better:

Make a function to get what is currently being hovered over. Always iterate from front to back, and return when you find it.
1. 

# How input callbacks work

See mouse cursor, but replace mouse event with any event.

# How the titlebar works

1. You make a window with a titlebar.
2. It automatically calls a function that makes a small form.
3. The form makes three things:
	1. A title label (if this is dragged, it will move the window.)
	2. A minimize button
	3. A close button
4. Profit

# How window z-sorting will work

1. A window will be marked as "go to the front please"
2. Its z-index will be set to #self.windows + 1
3. The windows will be sorted by z-index
4. Next update cycle, all windows' z coords will be reset from 1 -> #self.windows.

# How forms will work

1. Form will get event from the window.
2. Form

# TODO:

* Add events (callback functions when things happen)
* Add proper mouse cursor events (taskbar -> windows -> desktop, as said)
* == make git repo around here ==
* Start work on forms
