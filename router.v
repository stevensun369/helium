module he

import picoev

pub struct Router {
	pub mut:
	routes map[string]map[string][]Handler
	config_headers map[string]string
}

type Handler = fn (req Req, mut res Res)

// running the router
pub fn (mut r Router) run(method string, path string, headers map[string]string, body string) (int, map[string]string, string) {
	req := Req {
		method: method
		path: path
		headers: headers
		body: body
	}
	mut res := Res {}

	// adding config headers
	for name, value in r.config_headers {
		res.headers[name] = value
	}

	// todo: add options
	router_handlers := r.routes[method][path.split('?')[0]]
	if router_handlers.len > 0 {
		for router_handler in router_handlers {
			if !res.end {
				router_handler(req, mut res)
			}
		}
	} else {
		res.status = 404
		res.headers = map[string]string
		res.body = 'Not Found'
	}

	return res.status, res.headers, res.body
}

// adding routes to the router
pub fn (mut r Router) get(path string, handlers ...Handler) {
	r.routes['GET'][path] = handlers
}

pub fn (mut r Router) post(path string, handlers ...Handler) {
	r.routes['POST'][path] = handlers
}

pub fn (mut r Router) put(path string, handlers ...Handler) {
	r.routes['PUT'][path] = handlers
}

pub fn (mut r Router) delete(path string, handlers ...Handler) {
	r.routes['DELETE'][path] = handlers
}

pub fn (mut r Router) serve(port int) {
	println('Server running at http://localhost:$port')
	picoev.new(
		port: port
		cb: &callback
		user_data: &r
	).serve()
}