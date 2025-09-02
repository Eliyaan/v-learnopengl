import gg
import sokol.sapp
import sokol.gfx

@[heap]
struct App {
mut:
	ctx &gg.Context = unsafe { nil }
	pass_action gfx.PassAction
}

fn main() {
	mut app := &App {
	}
	app.ctx = gg.new_context(
		width: 800
		height: 600
		user_data: app
		init_fn: init
		frame_fn: frame
		event_fn: event
		window_title: 'HelloWindow'
	)
	app.ctx.run()
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

fn event(mut e gg.Event, mut app App) {
	if e.typ == .key_down {
		if e.key_code == .escape {
			app.ctx.quit()
		}
	}
}

fn frame(mut app App) {
//	pass := sapp.create_default_pass(app.pass_action)
	pass := &gfx.Pass{
		action: app.pass_action
		swapchain: sapp.glue_swapchain()
	}
	gfx.begin_pass(pass)
	gfx.end_pass()
	gfx.commit()
}
