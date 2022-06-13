module he

pub struct Res {
	pub mut:
	// for the res in and of itself
	status int
	headers map[string]string
	body string

	// for other helpful features
	locals map[string]string
	end bool
}

pub fn (mut res Res) error(status int, message string) {
	if !res.end {
		res.status = status
		res.headers['Content-Type'] = 'application/json'
		res.body = '{"message": "$message"}'
		res.end = true
	}
}

pub fn (mut res Res) json(status int, body string) {
	if !res.end {
		res.status = status
		res.headers['Content-Type'] = 'application/json'
		res.body = body
		res.end = true
	}
}

pub fn (mut res Res) send(status int, message string) {
	if !res.end {
		res.status = status
		res.headers['Content-Type'] = 'text/plain'
		res.body = message
		res.end = true
	}
}