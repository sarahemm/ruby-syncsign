# SyncSign - Ruby interface to the SyncSign e-paper display system

## Description

Ruby class/gem to access the [SyncSign](http://sync-sign.com) cloud service to display information on e-paper displays.

## Features
 * Display circles, lines, rectangles, QR codes, and text on the displays.
 * Obtain information about associated hubs and displays.

## TODO
 * Support non-display nodes that connect to the SyncSign hub (like temperature or occupancy sensors)
 * Support display-resident images (item type IMAGE)
 * Support bitmap images from a URI (item type BITMAP\_URI)
 * Support icons in text boxes

## Use

Create a SyncSign Service instance using your API key (found in the SyncSign portal settings):

    require 'syncsign'

    signsvc = SyncSign::Service.new('<api key>')
    node = signsvc.node('<node id>')
    items = [
        SyncSign::Widget::Rectangle.new(x: 8, y: 8, width: 208, height: 60, pen_width: 2),
        SyncSign::Widget::Textbox.new(x: 16, y: 16, width: 192, height: 44, font: :roboto_slab, size: 24, align: :center, text: "Hello, World!")
    ]
    template = SyncSign::Template.new(items: items)
    node.render(template: template)

## Direct Rendering
The SyncSign hubs have a simplified API that can be used, bypassing the cloud service. This can result in significant time savings (15s vs 25s) as well as less time between sending the request and the first visible change on the display. This is especially useful for the 4.2" model with buttons, as the time a user spends waiting after pressing a button can be significantly reduced.

To enable direct rendering, create a file named signhubs.cfg in either the same directory as your app, the current directory, or /etc/signhubs.cfg. This file should have the following format:
hub-serial-nbr  hub-ip  hub-apikey

As an example:
MCFEF5583A9DCA  192.168.0.50  8ab8125b-5d23-1b9a-e55e-a8b3d8c04614

Once this is created, you can test it using examples/hubs.rb which should now list your hub as direct rendering capable. To enable this in your app, pass "render\_direct: true" when instantiating a new SyncSign::Service object.


## Examples

Check out the examples/ folder for:
 * account\_info.rb - Show information about the account associated with the provided API key.
 * nodes.rb - List all nodes on the system and information about them.
 * hubs.rb - List all hubs on the system and whether we have enough info to support direct rendering.
 * render.rb - Render a sample screen to the given node.

## Full Documentation
YARD docs included, also available on [RubyDoc.info](https://www.rubydoc.info/github/sarahemm/ruby-syncsign/master)
