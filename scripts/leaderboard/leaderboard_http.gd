extends Node

signal completed(operation: String, result: Dictionary, status: int)
signal download_completed(operation: String, body: PackedByteArray, status: int, result: int)

var base_url := ""
var _http: HTTPRequest
var _operation := ""
var _binary_operations := {}

func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 30.0
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)

func is_busy() -> bool:
	return not _operation.is_empty()

func request_json(operation: String, method: HTTPClient.Method, route: String, payload: Dictionary = {}, token: String = "") -> bool:
	var headers := PackedStringArray(["Content-Type: application/json", "Accept: application/json"])
	if not token.is_empty():
		headers.append("Authorization: Bearer " + token)
	var body := "" if method == HTTPClient.METHOD_GET or method == HTTPClient.METHOD_DELETE else JSON.stringify(payload)
	return _request(operation, method, route, headers, body.to_utf8_buffer())

func upload(operation: String, route: String, payload: PackedByteArray, token: String) -> bool:
	var headers := PackedStringArray(["Content-Type: application/octet-stream", "Authorization: Bearer " + token])
	return _request(operation, HTTPClient.METHOD_PUT, route, headers, payload)

func download(operation: String, route: String) -> bool:
	var headers := PackedStringArray(["Accept: application/octet-stream"])
	if not _request(operation, HTTPClient.METHOD_GET, route, headers, PackedByteArray()):
		return false
	_binary_operations[operation] = true
	return true

func _request(operation: String, method: HTTPClient.Method, route: String, headers: PackedStringArray, body: PackedByteArray) -> bool:
	if _http == null or is_busy() or operation.is_empty() or not route.begins_with("/api/"):
		return false
	if not (base_url.begins_with("https://") or base_url.begins_with("http://127.0.0.1:")):
		return false
	_operation = operation
	var error: Error = _http.request_raw(base_url.trim_suffix("/") + route, headers, method, body)
	if error != OK:
		_operation = ""
		return false
	return true

func _on_request_completed(result: int, status: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var operation := _operation
	_operation = ""
	if _binary_operations.has(operation):
		_binary_operations.erase(operation)
		download_completed.emit(operation, body, status, result)
		return
	var response: Dictionary = {}
	var parser := JSON.new()
	if parser.parse(body.get_string_from_utf8()) == OK and parser.data is Dictionary:
		response = parser.data
	if result != HTTPRequest.RESULT_SUCCESS:
		response["network_error"] = result
	completed.emit(operation, response, status)
