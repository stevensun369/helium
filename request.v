module he

import net.urllib

pub struct Req {
	pub: 
	method string
	path string
	headers map[string]string
	body string
}

pub fn (req Req) parse_query() map[string]string {
	mut queries := map[string]string

	path_arr := req.path.split('?')
	mut queries_string := ''
	if path_arr.len > 1 {
		queries_string = path_arr[1]
	}

	if qvalues := urllib.parse_query(queries_string) {
		query_map := qvalues.to_map()

		for name, values in query_map {
			queries[name] = values[0]
		}
	}

	return queries
}