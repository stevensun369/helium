module he

pub struct Res {
	pub mut:
	// for the response in and of itself
	status int
	headers map[string]string
	body string

	// for other helpful features
	locals map[string]string
	end bool
}

// error is a helper function for returning standardized
// error message formatting
pub fn (mut res Res) error(status int, message string) {
	if !res.end {
		res.status = status
		res.headers['Content-Type'] = 'application/json'
		res.body = '{"message": "$message"}'
		res.end = true
	}
}

// json simply sets content-type to json
pub fn (mut res Res) json(status int, body string) {
	if !res.end {
		res.status = status
		res.headers['Content-Type'] = 'application/json'
		res.body = body
		res.end = true
	}
}

// send just sends a plaintext message
pub fn (mut res Res) send(status int, message string) {
	if !res.end {
		res.status = status
		res.headers['Content-Type'] = 'text/plain'
		res.body = message
		res.end = true
	}
}