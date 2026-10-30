extends SceneTree

var done := false
var success := false
func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var client = load("res://scripts/leaderboard/leaderboard_http.gd").new()
	root.add_child(client)
	await process_frame
	client.base_url = "http://127.0.0.1:38891"
	client.completed.connect(func(operation, body, status):
		print("HTTP test: ", operation, " ", status, " ", body)
		success = operation == "health" and status == 200 and body.get("ok", false)
		done = true
	)
	if not client.request_json("health", HTTPClient.METHOD_GET, "/api/health"):
		printerr("FAIL: health request did not start")
		quit(1)
		return
	for frame in range(300):
		await create_timer(0.02).timeout
		if done:
			break
	if not success:
		printerr("FAIL: health request failed")
		quit(1)
		return
	client.base_url = "http://example.com"
	if client.request_json("unsafe", HTTPClient.METHOD_GET, "/api/health"):
		printerr("FAIL: remote cleartext URL must be rejected")
		quit(1)
		return
	client.queue_free()
	print("LEADERBOARD_HTTP_PASS")
	quit(0)


