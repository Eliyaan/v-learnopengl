import sokol.sapp
import sokol.gfx

@[heap]
struct App {
mut:
	pass_action gfx.PassAction
}

fn main() {
	mut app := &App{}
	sapp.run(
		width:             800
		height:            600
		user_data:         app
		init_userdata_cb:  init
		frame_userdata_cb: frame
		event_userdata_cb: event
		window_title:      c'HelloWindow'
	)
}

fn init(mut app App) {
	mut desc := sapp.create_desc()
	gfx.setup(&desc)
	//	app.pass_action = gfx.create_clear_pass_action(0.2, 0.3, 0.3, 1.0)
	app.pass_action.colors[0] = gfx.ColorAttachmentAction{
		load_action: .clear
		clear_value: gfx.Color{0.2, 0.3, 0.3, 1.0}
	}
}

fn event(mut e sapp.Event, mut app App) {
	if e.type == .key_down {
		if e.key_code == .escape {
			sapp.request_quit()
		}
	}
}

fn frame(mut app App) {
	//	pass := sapp.create_default_pass(app.pass_action)
	pass := &gfx.Pass{
		action:    app.pass_action
		swapchain: sapp.glue_swapchain()
	}
	gfx.begin_pass(pass)
	gfx.end_pass()
	gfx.commit()
}
