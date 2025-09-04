import sokol.sapp
import sokol.gfx

#include "@VMODROOT/hellotriangle/simple.h" # # It should be generated with `v shader simple.glsl`

fn C.simple_shader_desc(gfx.Backend) &gfx.ShaderDesc // simple name comes from the name specified in the shader in @program

const vs_in_position_loc = C.ATTR_vs_position

@[heap]
struct App {
mut:
	bindings    gfx.Bindings
	pipeline    gfx.Pipeline
	pass_action gfx.PassAction
}

struct Vertex {
	x f32
	y f32
	z f32
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
		high_dpi:          true
		window_title:      c'HelloWindow'
	)
}

fn init(mut app App) {
	mut desc := sapp.create_desc()
	gfx.setup(&desc)

	vertices := [
		Vertex{0.5, 0.5, 0.0},
		Vertex{0.5, -0.5, 0.0},
		Vertex{-0.5, -0.5, 0.0},
		Vertex{-0.5, 0.5, 0.0},
	]
	vsize := u32(vertices.len) * sizeof(Vertex)
	vertex_buffer_desc := &gfx.BufferDesc{
		size:  vsize
		data:  gfx.Range{
			ptr:  vertices.data
			size: vsize
		}
		label: c'quad-vertices'
	}
	app.bindings.vertex_buffers[0] = gfx.make_buffer(vertex_buffer_desc)

	indices := [u16(1), 0, 3, 1, 2, 3]
	i_size := u32(indices.len) * sizeof(u16)
	index_buffer_desc := &gfx.BufferDesc{
		type:  .indexbuffer
		size:  i_size
		data:  gfx.Range{
			ptr:  indices.data
			size: i_size
		}
		label: c'quad-indices'
	}
	app.bindings.index_buffer = gfx.make_buffer(index_buffer_desc)

	shader := gfx.make_shader(C.simple_shader_desc(gfx.query_backend()))
	mut pipeline_desc := &gfx.PipelineDesc{
		shader:         shader
		index_type:     .uint16
		primitive_type: .line_strip
		label:          c'quad-pipeline'
	}

	pipeline_desc.layout.attrs[vs_in_position_loc] = gfx.VertexAttrDesc{
		buffer_index: vs_in_position_loc
		offset:       0
		format:       .float3
	}
	// pipeline_desc.layout.buffers[vs_in_position_loc] = VertexBufferLayoutState{ // optionnal, the array is tightly packed
	// 	stride: 3 * sizeof(f32)
	// }

	app.pipeline = gfx.make_pipeline(pipeline_desc)

	app.pass_action = gfx.create_clear_pass_action(0.2, 0.3, 0.3, 1.0)
}

fn event(mut e sapp.Event, mut app App) {
	if e.type == .key_down {
		if e.key_code == .escape {
			sapp.request_quit()
		}
	}
}

fn frame(mut app App) {
	pass := sapp.create_default_pass(app.pass_action)
	gfx.begin_pass(pass)
	gfx.apply_pipeline(app.pipeline)
	gfx.apply_bindings(app.bindings)
	gfx.draw(vs_in_position_loc, 6, 1)
	gfx.end_pass()
	gfx.commit()
}
