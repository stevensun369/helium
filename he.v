module he

import picohttpparser
import picoev

const sep = '\r\n'

pub fn callback(mut router Router, req picohttpparser.Request, mut res picohttpparser.Response) {
	mut req_headers := map[string]string {}
	
	for i in 0 .. req.num_headers {
		unsafe {
			name := req.headers[i].name.vstring()
			value := req.headers[i].value.vstring()
			req_headers[name] = value
		}
	}

	status, headers, body := router.run(req.method, req.path, req_headers, req.body)
	
	mut res_headers := ''
	for name, value in headers {
		res_headers += '${sep}${name}: ${value}'
	}

	res.write_string('HTTP/1.1 ${status}')
	unsafe { res.write_string('${sep}Date: ${tos(res.date, 29)}') }
	res.write_string('${sep}Content-Length: $body.len')
	res.write_string(res_headers)
	res.write_string(sep.repeat(2))
	res.write_string(body)
	res.end()
}

fn handler(req Req, mut res Res) {
	queries := req.parse_query()
	res.json(200, queries['hello'])
}

pub fn serve(router Router, port int) {
	println('Server running at http://localhost:$port')
	picoev.new(
		port: port
		cb: &callback
		user_data: &router
	).serve()
}
