# SyncSign - Ruby interface to the SyncSign e-paper display system.

## Description

Ruby class/gem to access the [SyncSign](http://sync-sign.com) cloud service to display information on e-paper displays.

## Features
 * Display circles, lines, rectangles, QR codes, and text on the displays.
 * Obtain information about associated hubs and displays.

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

## Examples

Check out the examples/ folder for:
 * account_info.rb - Show information about the account associated with the provided API key.
 * nodes.rb - List all nodes on the system and information about them.
 * render.rb - Render a sample screen to the given node.

