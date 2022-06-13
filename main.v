module main

import he

fn handler(req he.Req, mut res he.Res) {
	res.json(200, req.ctx)
}

fn main() {
	mut router := he.Router {}

	router.ctx = 'hello'

	router.config_headers = {
		'Access-Control-Allow-Origin': '*'
	}

	router.get('/api/v1/hello', handler)

	router.serve(9999)
}
