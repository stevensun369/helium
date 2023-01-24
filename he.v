module he

import picohttpparser
import picoev

const sep = '\r\n'

pub fn callback(mut router Router, req picohttpparser.Request, mut res picohttpparser.Response) {
	mut req_headers := map[string]string {}
	unsafe {
		pico_headers := req.headers[0].name.vstring()
		pico_headers_split := pico_headers.split('\r\n')
		for i in 0 .. req.num_headers {
			header_split := pico_headers_split[i].split(": ")
			req_headers[header_split[0]] = header_split[1]
		}
	}

	status, headers, body := router.run(req.method, req.path, req_headers, req.body)
	
	mut res_headers := ''
	for name, value in headers {
		res_headers += '${sep}${name}: ${value}'
	}

	res.write_string('HTTP/1.1 $status')
	unsafe { res.write_string('${sep}Date: ${tos(res.date, 29)}') }
	res.write_string('${sep}Content-Length: $body.len')
	res.write_string(res_headers)
	res.write_string(sep.repeat(2))
	res.write_string(body)
	res.end()
}
